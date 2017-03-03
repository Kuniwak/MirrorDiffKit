import Foundation


extension Diffable {
    struct Diff {
        let units: [DiffUnit]
    }


    indirect enum DiffUnit {
        case notChanged(Diffable)
        case inserted(Diffable)
        case deleted(Diffable)
        case child(kind: ChildKind, [String: Diff])
    }


    enum ChildKind {
        case dictionary
        case anyStruct(type: Any.Type)
        case anyClass(type: Any.Type)


        var token: (open: String, close: String) {
            switch self {
            case .dictionary:
                return (open: "[", close: "]")
            case .anyStruct, .anyClass:
                return (open: "\(self.name) {", close: "}")
            }
        }


        private var name: String {
            switch self {
            case .dictionary:
                return "Dictionary"
            case let .anyStruct(type: type):
                return "struct \(type)"
            case let .anyClass(type: type):
                return "class \(type)"
            }
        }
    }


    static func diff (between a: Diffable, and b: Diffable) -> Diff {
        guard a != b else {
            return Diff(units: [.notChanged(a)])
        }

        switch (a, b) {
        case let (.array(l), .array(r)):
            return DiffableSequence.diff(
                between: DiffableSequence(l),
                and: DiffableSequence(r)
            )

        case let (.set(l), .set(r)):
            return DiffableSet.diff(
                between: DiffableSet(l),
                and: DiffableSet(r)
            )

        case let (.dictionary(l), .dictionary(r)):
            return DiffableDictionary.diff(
                between: DiffableDictionary(l),
                and: DiffableDictionary(r),
                forKind: .dictionary
            )

        case let (.anyStruct(type: lt, entries: ld), .anyStruct(type: rt, entries: rd)):
            guard lt == rt else {
                return Diff(units: [.deleted(a), .inserted(b)])
            }

            return DiffableDictionary.diff(
                between: DiffableDictionary(ld),
                and: DiffableDictionary(rd),
                forKind: .anyStruct(type: lt)
            )

        case let (.anyClass(type: lt, entries: ld), .anyClass(type: rt, entries: rd)):
            guard lt == rt else {
                return Diff(units: [.deleted(a), .inserted(b)])
            }

            return DiffableDictionary.diff(
                between: DiffableDictionary(ld),
                and: DiffableDictionary(rd),
                forKind: .anyClass(type: lt)
            )

        default:
            return Diff(units: [.deleted(a), .inserted(b)])
        }
    }
}



extension Diffable.DiffUnit: Equatable {
    static func == (_ lhs: Diffable.DiffUnit, _ rhs: Diffable.DiffUnit) -> Bool {
        switch (lhs, rhs) {
        case let (.notChanged(l), .notChanged(r)):
            return l == r
        case let (.inserted(l), .inserted(r)):
            return l == r
        case let (.deleted(l), .deleted(r)):
            return l == r
        case let (.child(kind: lk, ld), .child(kind: rk, rd)):
            return lk == rk
                && ld == rd
        default:
            return false
        }
    }
}



extension Diffable.ChildKind: Equatable {
    static func == (_ lhs: Diffable.ChildKind, _ rhs: Diffable.ChildKind) -> Bool {
        switch (lhs, rhs) {
        case (.dictionary, .dictionary):
            return true
        case let (.anyStruct(type: l), .anyStruct(type: r)):
            return l == r
        case let (.anyClass(type: l), .anyClass(type: r)):
            return l == r
        default:
            return false
        }
    }
}



extension Diffable.Diff: Equatable {
    static func == (_ lhs: Diffable.Diff, _ rhs: Diffable.Diff) -> Bool {
        return lhs.units == rhs.units
    }
}



extension Diffable.DiffUnit: PrettyPrintable {
    var prettyLines: [PrettyLine] {
        switch self {
        case let .notChanged(notChanged):
            return [.line("  \(notChanged.description)")]
        case let .deleted(deleted):
            return [.line("- \(deleted.description)")]
        case let .inserted(inserted):
            return [.line("+ \(inserted.description)")]
        case let .child(kind: kind, dictionary):
            return self.childPrettyLines(kind: kind, dictionary)
        }
    }


    private func childPrettyLines(kind: Diffable.ChildKind, _ dictionary: [String: Diffable.Diff]) -> [PrettyLine] {
        let lines: [PrettyLine] = entries(fromDictionary: dictionary)
            .sorted { $0.0 < $1.0 }
            .flatMap { (childKey, childDiff) -> [PrettyLine] in
                let childLines: [PrettyLine] = childDiff.units.flatMap { childDiffUnit -> [PrettyLine] in
                    switch childDiffUnit {
                    case let .notChanged(value):
                        return [.line("  \(childKey): \(value.description)")]
                    case let .deleted(value):
                        return [.line("- \(childKey): \(value.description)")]
                    case let .inserted(value):
                        return [.line("+ \(childKey): \(value.description)")]
                    case let .child(kind: childKind, childDictionary):
                        return self.childPrettyLines(kind: childKind, childDictionary)
                    }
                }

                return childLines
            }
            .map { .indent($0) }

        guard !lines.isEmpty else {
            return [.line("  \(kind.token.open)\(kind.token.close)")]
        }

        return [.line("  \(kind.token.open)")]
            + lines
            + [.line("  \(kind.token.close)")]
    }
}



extension Diffable.Diff: PrettyPrintable {
    var prettyLines: [PrettyLine] {
        return self.units
            .flatMap { unit -> [PrettyLine] in unit.prettyLines }
    }
}

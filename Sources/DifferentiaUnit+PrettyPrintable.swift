import Foundation



extension DifferentiaUnit: PrettyPrintable {
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


    private func childPrettyLines(kind: DifferentiaUnit.ChildKind, _ dictionary: [String: Differentia]) -> [PrettyLine] {
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

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
        case let .dictionaryChanged(kind: kind, dictionary):
            return self.childPrettyLines(kind: kind, dictionary)
        }
    }


    private func childPrettyLines(kind: DifferentiaUnit.DictionaryType, _ dictionary: [String: Differentia]) -> [PrettyLine] {
        let lines = self.createContentLines(by: dictionary)

        guard !lines.isEmpty else {
            return [.line("  \(kind.token.open)\(kind.token.close)")]
        }

        return [.line("  \(kind.token.open)")]
            + lines
            + [.line("  \(kind.token.close)")]
    }


    private func childPrettyLinesWithKey(key: String, kind: DifferentiaUnit.DictionaryType, _ dictionary: [String: Differentia]) -> [PrettyLine] {
        let lines = self.createContentLines(by: dictionary)

        guard !lines.isEmpty else {
            return [.line("  \(key): \(kind.token.open)\(kind.token.close)")]
        }

        return [.line("  \(key): \(kind.token.open)")]
            + lines
            + [.line("  \(kind.token.close)")]
    }


    private func createContentLines(by dictionary: [String: Differentia]) -> [PrettyLine] {
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
                    case let .dictionaryChanged(kind: childKind, childDictionary):
                        return self.childPrettyLinesWithKey(key: childKey, kind: childKind, childDictionary)
                    }
                }

                return childLines
            }
            .map { .indent($0) }

        return lines
    }
}

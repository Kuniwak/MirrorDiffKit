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
            return self.createPrettyLinesForDictionary(kind: kind, dictionary)
        case let .sequenceChanged(kind: kind, array):
            return self.createPrettyLinesForSequence(kind: kind, array)
        }
    }


    private func createPrettyLinesForSequence(
        kind: DifferentiaUnit.SequenceType,
        _ array: [DifferentiaUnit]
    ) -> [PrettyLine] {
        let lines = self.createSequenceContentLines(by: array)

        guard !lines.isEmpty else {
            return [.line("  []")]
        }

        return [.line("  [")] + lines + [.line("  ]")]
    }


    private func createPrettyLinesForSequenceWithKey(
        key: String,
        kind: DifferentiaUnit.SequenceType,
        _ array: [DifferentiaUnit]
    ) -> [PrettyLine] {
        let lines = self.createSequenceContentLines(by: array)

        guard !lines.isEmpty else {
            return [.line("  \(key): []")]
        }

        return [.line("  \(key): [")]
            + lines
            + [.line("  ]")]
    }


    private func createSequenceContentLines(by array: [DifferentiaUnit]) -> [PrettyLine] {
        let lines: [PrettyLine] = array
            .flatMap { (unit) -> [PrettyLine] in unit.prettyLines }
            .map { .indent($0) }

        return lines
    }


    private func createPrettyLinesForDictionary(
        kind: DifferentiaUnit.DictionaryType,
        _ dictionary: [String: [DifferentiaUnit]]
    ) -> [PrettyLine] {
        let lines = self.createDictionaryContentLines(by: dictionary)

        guard !lines.isEmpty else {
            return [.line("  \(kind.token.open)\(kind.token.close)")]
        }

        return [.line("  \(kind.token.open)")]
            + lines
            + [.line("  \(kind.token.close)")]
    }


    private func createPrettyLinesForDictionaryWithKey(
        key: String,
        kind: DifferentiaUnit.DictionaryType,
        _ dictionary: [String: [DifferentiaUnit]]
    ) -> [PrettyLine] {
        let lines = self.createDictionaryContentLines(by: dictionary)

        guard !lines.isEmpty else {
            return [.line("  \(key): \(kind.token.open)\(kind.token.close)")]
        }

        return [.line("  \(key): \(kind.token.open)")]
            + lines
            + [.line("  \(kind.token.close)")]
    }


    private func createDictionaryContentLines(by dictionary: [String: [DifferentiaUnit]]) -> [PrettyLine] {
        let lines: [PrettyLine] = entries(fromDictionary: dictionary)
            .sorted { $0.0 < $1.0 }
            .flatMap { (childKey, diffUnits) -> [PrettyLine] in
                let childLines: [PrettyLine] = diffUnits.flatMap { childDiffUnit -> [PrettyLine] in
                    switch childDiffUnit {
                    case let .notChanged(value):
                        return [.line("  \(childKey): \(value.description)")]
                    case let .deleted(value):
                        return [.line("- \(childKey): \(value.description)")]
                    case let .inserted(value):
                        return [.line("+ \(childKey): \(value.description)")]
                    case let .dictionaryChanged(kind: childKind, childDictionary):
                        return self.createPrettyLinesForDictionaryWithKey(
                            key: childKey,
                            kind: childKind,
                            childDictionary
                        )
                    case let .sequenceChanged(kind: childKind, childArray):
                        return self.createPrettyLinesForSequenceWithKey(
                            key: childKey,
                            kind: childKind,
                            childArray
                        )
                    }
                }

                return childLines
            }
            .map { .indent($0) }

        return lines
    }
}

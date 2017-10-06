import Foundation



extension Diffable {
    public static func diff(between a: Diffable, and b: Diffable) -> [DifferentiaUnit] {
        guard a != b else {
            return [.notChanged(a)]
        }

        switch (a, b) {
        case let (.array(l), .array(r)):
            return [
                .sequenceChanged(
                    kind: .array,
                    DiffableSequence.diff(
                        between: DiffableSequence(l),
                        and: DiffableSequence(r)
                    )
                )
            ]

        case let (.set(l), .set(r)):
            return [
                .sequenceChanged(
                    kind: .set,
                    DiffableSet.diff(
                        between: DiffableSet(l),
                        and: DiffableSet(r)
                    )
                )
            ]

        case let (.dictionary(l), .dictionary(r)):
            return [
                .dictionaryChanged(
                    kind: .dictionary,
                    DiffableDictionary.diff(
                        between: DiffableDictionary.from(diffableTuples: l),
                        and: DiffableDictionary.from(diffableTuples: r)
                    )
                )
            ]

        case let (.anyStruct(type: lt, entries: ld), .anyStruct(type: rt, entries: rd)):
            guard lt == rt else {
                return [.deleted(a), .inserted(b)]
            }

            return [
                .dictionaryChanged(
                    kind: .anyStruct(type: lt),
                    DiffableDictionary.diff(
                        between: DiffableDictionary(ld),
                        and: DiffableDictionary(rd)
                    )
                )
            ]

        case let (.anyClass(type: lt, entries: ld), .anyClass(type: rt, entries: rd)):
            guard lt == rt else {
                return [.deleted(a), .inserted(b)]
            }

            return [
                .dictionaryChanged(
                    kind: .anyClass(type: lt),
                    DiffableDictionary.diff(
                        between: DiffableDictionary(ld),
                        and: DiffableDictionary(rd)
                    )
                )
            ]

        default:
            return [.deleted(a), .inserted(b)]
        }
    }
}

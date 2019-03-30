import Foundation



extension Diffable {
    public static func diff(between a: Diffable, and b: Diffable) -> [DifferentiaUnit] {
        guard a != b else {
            return [.notChanged(a)]
        }

        switch (a, b) {
        case let (.collection(type: lt, le), .collection(rt, re)):
            return [
                .sequenceChanged(
                    kind: .array,
                    DiffableSequence.diff(
                        between: DiffableSequence(type: lt, elements: le),
                        and: DiffableSequence(type: rt, elements: re)
                    )
                )
            ]

        case let (.set(type: lt, elements: le), .set(type: rt, elements: re)):
            return [
                .sequenceChanged(
                    kind: .set,
                    DiffableSet.diff(
                        between: DiffableSet(type: lt, elements: le),
                        and: DiffableSet(type: rt, elements: re)
                    )
                )
            ]

        case let (.dictionary(type: lt, entries: le), .dictionary(type: rt, entries: re)):
            return [
                .dictionaryChanged(
                    kind: .dictionary,
                    DiffableDictionary.diff(
                        between: DiffableDictionary.from(type: lt, entries: le),
                        and: DiffableDictionary.from(type: rt, entries: re)
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
                        between: DiffableDictionary(type: lt, dictionary: ld),
                        and: DiffableDictionary(type: rt, dictionary: rd)
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
                        between: DiffableDictionary(type: lt, dictionary: ld),
                        and: DiffableDictionary(type: rt, dictionary: rd)
                    )
                )
            ]

        default:
            return [.deleted(a), .inserted(b)]
        }
    }
}

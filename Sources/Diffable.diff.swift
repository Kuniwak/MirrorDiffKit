import Foundation



extension Diffable {
    static func diff (between a: Diffable, and b: Diffable) -> Differentia {
        guard a != b else {
            return Differentia(units: [.notChanged(a)])
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
                between: DiffableDictionary.from(diffableTuples: l),
                and: DiffableDictionary.from(diffableTuples: r),
                forKind: .dictionary
            )

        case let (.anyStruct(type: lt, entries: ld), .anyStruct(type: rt, entries: rd)):
            guard lt == rt else {
                return Differentia(units: [.deleted(a), .inserted(b)])
            }

            return DiffableDictionary.diff(
                between: DiffableDictionary(ld),
                and: DiffableDictionary(rd),
                forKind: .anyStruct(type: lt)
            )

        case let (.anyClass(type: lt, entries: ld), .anyClass(type: rt, entries: rd)):
            guard lt == rt else {
                return Differentia(units: [.deleted(a), .inserted(b)])
            }

            return DiffableDictionary.diff(
                between: DiffableDictionary(ld),
                and: DiffableDictionary(rd),
                forKind: .anyClass(type: lt)
            )

        default:
            return Differentia(units: [.deleted(a), .inserted(b)])
        }
    }
}

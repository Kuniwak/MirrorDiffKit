import Foundation



struct DiffableSet {
    let nonHashables: [Diffable]


    init(_ elements: [Diffable]) {
        self.nonHashables = elements
    }


    static func diff(between a: DiffableSet, and b: DiffableSet) -> Diffable.Diff {
        // NOTE: Elements of [Diffable] may not conform to Hashable.
        // So we cannot use O(1) algorithm such as hash map.

        var notChanged = [Diffable]()
        var deleted = a.nonHashables
        var inserted = b.nonHashables

        deleted.enumerated().forEach { (indexOfDeleted, l) in
            if let indexOfInserted = inserted.index(of: l) {
                inserted.remove(at: indexOfInserted)
                deleted.remove(at: indexOfDeleted)
                notChanged.append(l)
            }
        }

        return Diffable.Diff(units:
            (deleted
                .sorted { String(describing: $0) < String(describing: $1) }
                .map { .deleted($0) })
            + (inserted
                .sorted { String(describing: $0) < String(describing: $1) }
                .map { .inserted($0) })
            + (notChanged
                .sorted { String(describing: $0) < String(describing: $1) }
                .map { .notChanged($0) })
        )
    }
}


extension DiffableSet: Equatable {
    static func == (_ lhs: DiffableSet, _ rhs: DiffableSet) -> Bool {
        return lhs.nonHashables == rhs.nonHashables
    }
}

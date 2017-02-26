import Foundation



public struct DiffableSet {
    let nonHashables: [Diffable]


    init(_ elements: [Diffable]) {
        self.nonHashables = elements
    }


    static func diff(from: DiffableSet, to: DiffableSet) -> Diff {
        // NOTE: Elements of [Diffable] may not conform to Hashable.
        // So we cannot use O(1) algorithm such as hash map.

        var notChanged = [Diffable]()
        var deleted = from.nonHashables
        var inserted = to.nonHashables

        deleted.enumerated().forEach { (indexOfDeleted, l) in
            if let indexOfInserted = inserted.index(of: l) {
                inserted.remove(at: indexOfInserted)
                deleted.remove(at: indexOfDeleted)
                notChanged.append(l)
            }
        }

        return Diff(
            notChanged: DiffableSet(notChanged),
            inserted: DiffableSet(inserted),
            deleted: DiffableSet(deleted)
        )
    }


    struct Diff {
        let notChanged: DiffableSet
        let inserted: DiffableSet
        let deleted: DiffableSet
    }
}


extension DiffableSet: Equatable {
    public static func == (_ lhs: DiffableSet, _ rhs: DiffableSet) -> Bool {
        return lhs.nonHashables == rhs.nonHashables
    }
}


extension DiffableSet.Diff: Equatable {
    static func == (_ lhs: DiffableSet.Diff, _ rhs: DiffableSet.Diff) -> Bool {
        return lhs.notChanged == rhs.notChanged
            && lhs.inserted == rhs.inserted
            && lhs.deleted == rhs.deleted
    }
}

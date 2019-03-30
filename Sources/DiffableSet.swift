import Foundation



struct DiffableSet {
    let type: HashableType
    let elements: Set<Diffable>


    init(type: HashableType, elements: Set<Diffable>) {
        self.type = type
        self.elements = elements
    }


    static func diff(between a: DiffableSet, and b: DiffableSet) -> [DifferentiaUnit] {
        let notChanged = a.elements.intersection(b.elements)
        let deleted = a.elements.subtracting(b.elements)
        let inserted = b.elements.subtracting(a.elements)

        return (deleted
                .sorted { String(describing: $0) < String(describing: $1) }
                .map { .deleted($0) })
            + (inserted
                .sorted { String(describing: $0) < String(describing: $1) }
                .map { .inserted($0) })
            + (notChanged
                .sorted { String(describing: $0) < String(describing: $1) }
                .map { .notChanged($0) })
    }
}

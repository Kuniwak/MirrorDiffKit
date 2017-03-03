import Foundation



struct DiffableDictionary {
    let dictionary: [String: Diffable]


    init(_ dictionary: [String: Diffable]) {
        self.dictionary = dictionary
    }


    static func diff(between lhs: DiffableDictionary, and rhs: DiffableDictionary, forKind kind: Diffable.ChildKind) -> Diffable.Diff {
        // note: elements of [diffable] may not conform to hashable.
        // so we cannot use o(1) algorithm such as hash map.

        var result: [String: Diffable.Diff] = [:]

        let keys = Set(lhs.dictionary.keys)
            .union(Set(rhs.dictionary.keys))

        keys.forEach { key in
            switch (lhs.dictionary[key], rhs.dictionary[key]) {
            case (.none, .none):
                fatalError("This case cannot be executed.")

            case let (.some(lv), .none):
                result[key] = Diffable.Diff(units: [.inserted(lv)])

            case let (.none, .some(rv)):
                result[key] = Diffable.Diff(units: [.deleted(rv)])

            case let (.some(lv), .some(rv)):
                guard lv != rv else {
                    result[key] = Diffable.Diff(units: [.notChanged(lv)])
                    return
                }

                result[key] = Diffable.Diff(units: [
                    .deleted(lv),
                    .inserted(rv),
                ])
            }
        }

        return Diffable.Diff(units: [
            .child(kind: kind, result)
        ])
    }
}


extension DiffableDictionary: Equatable {
    static func == (_ lhs: DiffableDictionary, _ rhs: DiffableDictionary) -> Bool {
        return lhs.dictionary == rhs.dictionary
    }
}

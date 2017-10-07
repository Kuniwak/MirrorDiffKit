import Foundation



struct DiffableDictionary {
    let dictionary: [String: Diffable]


    init(_ dictionary: [String: Diffable]) {
        self.dictionary = dictionary
    }


    static func from(diffableTuples: [(key: Diffable, value: Diffable)]) -> DiffableDictionary {
        var dictionary: [String: Diffable] = [:]

        diffableTuples.forEach { diffableTuple in
            let (key, value) = diffableTuple
            dictionary[key.description] = value
        }

        return DiffableDictionary(dictionary)
    }


    static func diff(between lhs: DiffableDictionary, and rhs: DiffableDictionary) -> [String: [DifferentiaUnit]] {
        // note: elements of [diffable] may not conform to hashable.
        // so we cannot use o(1) algorithm such as hash map.

        var result: [String: [DifferentiaUnit]] = [:]

        let keys = Set(lhs.dictionary.keys)
            .union(Set(rhs.dictionary.keys))

        keys.forEach { key in
            switch (lhs.dictionary[key], rhs.dictionary[key]) {
            case (.none, .none):
                fatalError("This case cannot be executed.")

            case let (.some(lv), .none):
                result[key] = [.inserted(lv)]

            case let (.none, .some(rv)):
                result[key] = [.deleted(rv)]

            case let (.some(lv), .some(rv)):
                guard lv != rv else {
                    result[key] = [.notChanged(lv)]
                    return
                }

                result[key] = Diffable.diff(between: lv, and: rv)
            }
        }

        return result
    }
}


extension DiffableDictionary: Equatable {
    static func == (_ lhs: DiffableDictionary, _ rhs: DiffableDictionary) -> Bool {
        return lhs.dictionary == rhs.dictionary
    }
}

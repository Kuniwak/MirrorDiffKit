import Foundation



struct DiffableDictionary {
    let type: HashableType
    let dictionary: [String: Diffable]


    init(type: HashableType, dictionary: [String: Diffable]) {
        self.type = type
        self.dictionary = dictionary
    }


    static func from(type: HashableType, entries: Set<Diffable.DictionaryEntry>) -> DiffableDictionary {
        var dictionary: [String: Diffable] = [:]

        entries.forEach { entry in
            dictionary[entry.key.description] = entry.value
        }

        return DiffableDictionary(type: type, dictionary: dictionary)
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

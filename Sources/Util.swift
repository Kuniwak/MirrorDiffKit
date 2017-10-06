func entries<K, V>(fromDictionary dictionary: [K: V]) -> [(K, V)] {
    var result: [(K, V)] = []

    for (key ,value) in dictionary {
        result.append((key, value))
    }

    return result
}

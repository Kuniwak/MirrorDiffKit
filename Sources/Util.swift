func entries<K, V>(fromDictionary dictionary: [K: V]) -> [(key: K, value: V)] {
    var result: [(key: K, value: V)] = []

    for (key ,value) in dictionary {
        result.append((key: key, value: value))
    }

    return result
}

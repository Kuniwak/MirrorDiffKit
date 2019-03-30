extension Diffable.DictionaryEntry: Equatable {
    public static func ==(lhs: Diffable.DictionaryEntry, rhs: Diffable.DictionaryEntry) -> Bool {
        return lhs.key == rhs.key
            && lhs.value == rhs.value
    }
}
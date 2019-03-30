extension Diffable.DictionaryEntry: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.key)
        hasher.combine(self.value)
    }
}
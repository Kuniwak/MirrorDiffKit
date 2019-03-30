extension Diffable.DictionaryEntry /* :CustomStringConvertible */ {
    public var description: String {
        return "\(self.key.description): \(self.value.description)"
    }
}
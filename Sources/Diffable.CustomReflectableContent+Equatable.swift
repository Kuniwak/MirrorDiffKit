extension Diffable.CustomReflectableContent: Equatable {
    public static func ==(lhs: Diffable.CustomReflectableContent, rhs: Diffable.CustomReflectableContent) -> Bool {
        switch (lhs, rhs) {
        case (.empty(description: let l), .empty(description: let r)):
            return l == r

        case (.notEmpty(entries: let l), .notEmpty(entries: let r)):
            return l == r

        default:
            return false
        }
    }
}
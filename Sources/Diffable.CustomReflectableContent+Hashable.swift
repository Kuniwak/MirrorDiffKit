extension Diffable.CustomReflectableContent: Hashable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .empty(description: let description):
            hasher.combine(description)

        case .notEmpty(entries: let entries):
            hasher.combine(entries)
        }
    }
}
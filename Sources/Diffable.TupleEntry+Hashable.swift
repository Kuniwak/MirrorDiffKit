extension Diffable.TupleEntry: Hashable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .labeled(label: let label, value: let value):
            hasher.combine(label)
            hasher.combine(value)

        case .notLabeled(index: let index, value: let value):
            hasher.combine(index)
            hasher.combine(value)
        }
    }
}
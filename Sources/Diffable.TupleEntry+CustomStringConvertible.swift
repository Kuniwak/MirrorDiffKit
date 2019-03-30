extension Diffable.TupleEntry /* : CustomStringConvertible */ {
    var description: String {
        switch self {
        case let .labeled(label: label, value: value):
            return "\(label): \(value.description)"

        case let .notLabeled(index: _, value: value):
            return "\(value.description)"
        }
    }
}
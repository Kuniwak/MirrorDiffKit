/// Since Swift 3.1, enums become labeled tuple such as (key: K, value: V).
/// But before Swift 3.1, enums become not labeled tuple such as (K, V).
enum TupleRepresentation {
    /// For example, (key: K, value: V) becomes ["key": K, "value" V].
    /// This is Swift 3.1+.
    case labeled

    /// For example, (key: K, value: V) becomes [".0": K, ".1" V].
    /// This is Swift 3.0.2-.
    case notLabeled


    var isLabeled: Bool {
        switch self {
        case .labeled:
            return true
        case .notLabeled:
            return false
        }
    }


    static let current = TupleRepresentation.detect()


    private static func detect() -> TupleRepresentation {
        let mirror = Mirror(reflecting: (label1: "value1", label2: "value2"))

        let label = mirror.children.first!.label

        // NOTE: This is Swift 3.1+.
        if label == "label1" {
            return .labeled
        }

        // NOTE: This is Swift 3.0.2-.
        if label == ".0" {
            return .notLabeled
        }

        fatalError("Cannot detect enum representation: " + String(describing: label))
    }
}
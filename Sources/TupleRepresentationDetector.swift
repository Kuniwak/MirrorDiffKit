/// Since Swift 3.1, enums become labeled tuple such as (key: K, value: V).
/// But before Swift 3.1, enums become not labeled tuple such as (K, V).
public enum TupleRepresentation {
    /// For example, (key: K, value: V) becomes ["key": K, "value" V] and
    /// an associated tuple of .something(associated: K) becomes ["associated": K].
    /// This is Swift >= 4.2.
    case fullyLabeled

    /// For example, an associated tuple of .something(associated: K) becomes K.
    /// This is Swift 3.1..<4.2.
    case labeledWithoutSingleAssociatedType

    /// For example, (key: K, value: V) becomes [".0": K, ".1" V].
    /// This is Swift < 3.0.2.
    case notLabeled


    public var isFullyLabeled: Bool {
        switch self {
        case .fullyLabeled:
            return true
        case .labeledWithoutSingleAssociatedType:
            return false
        case .notLabeled:
            return false
        }
    }

    public var isAlmostLabeled: Bool {
        switch self {
        case .fullyLabeled:
            return true
        case .labeledWithoutSingleAssociatedType:
            return true
        case .notLabeled:
            return false
        }
    }


    public static let current = TupleRepresentation.detect()


    private static func detect() -> TupleRepresentation {
        let mirror = Mirror(reflecting: (label1: "value1", label2: "value2"))

        let label = mirror.children.first!.label

        // NOTE: This is Swift 3.1+.
        if label == "label1" {
            let anotherMirror = Mirror(reflecting: SampleEnum.caseAssociatedSingleType(label: "value"))

            return type(of: anotherMirror.children.first!.value) != String.self
                ? .fullyLabeled // NOTE: This is Swift 4.2+
                : .labeledWithoutSingleAssociatedType
        }

        // NOTE: This is Swift 3.0.2-.
        if label == ".0" {
            return .notLabeled
        }

        fatalError("Cannot detect enum representation: " + String(describing: label))
    }


    fileprivate enum SampleEnum {
        case caseAssociatedSingleType(label: String)
    }
}

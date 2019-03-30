public struct EnumCaseName: Equatable, Hashable {
    private let name: String


    public var description: String {
        return self.name
    }


    public init(_ name: String) {
        self.name = name
    }


    public static func from(mirror: Mirror, original x: Any) throws -> EnumCaseName {
        guard let firstChild = mirror.children.first else {
            // XXX: This is a no-associated enum case.
            return EnumCaseName("\(x)")
        }

        guard let label = firstChild.label else {
            throw CreationError.labelMustBeNotNil
        }

        return EnumCaseName(label)
    }


    public enum CreationError: Error {
        case labelMustBeNotNil
    }
}

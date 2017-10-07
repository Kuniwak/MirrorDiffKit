public struct EnumCaseName {
    fileprivate let name: String


    var description: String {
        return self.name
    }


    init(_ name: String) {
        self.name = name
    }


    static func from(mirror: Mirror, original x: Any) throws -> EnumCaseName {
        guard let firstChild = mirror.children.first else {
            // XXX: This is a no-associated enum case.
            return EnumCaseName("\(x)")
        }

        guard let label = firstChild.label else {
            throw CreationError.labelMustBeNotNil
        }

        return EnumCaseName(label)
    }


    enum CreationError: Error {
        case labelMustBeNotNil
    }
}



extension EnumCaseName: Equatable {
    public static func ==(lhs: EnumCaseName, rhs: EnumCaseName) -> Bool {
        return lhs.name == rhs.name
    }
}

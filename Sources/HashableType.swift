public struct HashableType {
    public let actualType: Any.Type


    public init(type: Any.Type) {
        self.actualType = type
    }


    public init(of x: Any) {
        self.actualType = Swift.type(of: x)
    }


    public static func type(_ type: Any.Type) -> HashableType {
        return HashableType(type: type)
    }


    public static func type(of x: Any) -> HashableType {
        return HashableType(type: Swift.type(of: x))
    }
}


extension HashableType: CustomStringConvertible {
    public var description: String {
        // NOTE: Do not use String(reflecting:) because omitting their module names but enough.
        return String(describing: self.actualType)
    }
}


extension HashableType: Equatable {
    public static func ==(lhs: HashableType, rhs: HashableType) -> Bool {
        return lhs.actualType == rhs.actualType
    }
}


extension HashableType: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(String(reflecting: self.actualType))
    }
}

internal struct HashableType {
    public let type: Any.Type


    init(_ type: Any.Type) {
        self.type = type
    }
}


extension HashableType: Equatable {
    public static func ==(lhs: HashableType, rhs: HashableType) -> Bool {
        return lhs.type == rhs.type
    }
}


extension HashableType: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(String(reflecting: self.type))
    }
}

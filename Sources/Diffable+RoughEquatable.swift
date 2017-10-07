extension Diffable: RoughEquatable {
    public static func =~ (_ lhs: Diffable, _ rhs: Diffable) -> Bool {
        switch (lhs, rhs) {
        // NOTE: This is an only difference between Equatable and RoughEquatable.
        case let (.notSupported(value: r), .notSupported(value: l)):
            return Mirror(reflecting: l).subjectType == Mirror(reflecting: r).subjectType
                && String(describing: l) == String(describing: r)

        default:
            return lhs == rhs
        }
    }
}

extension Diffable: RoughEquatable {
    public static func =~ (_ lhs: Diffable, _ rhs: Diffable) -> Bool {
        switch (lhs, rhs) {
        // NOTE: This is an only difference between Equatable and RoughEquatable.
        case let (.notSupported(value: r), .notSupported(value: l)):
            return Swift.type(of: r) == Swift.type(of: l)
                && String(describing: r) == String(describing: l)

        default:
            return lhs == rhs
        }
    }
}

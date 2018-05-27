extension Diffable: RoughEquatable {
    public static func =~ (_ lhs: Diffable, _ rhs: Diffable) -> Bool {
        switch (lhs, rhs) {
        // NOTE: This is an only difference between Equatable and RoughEquatable.
        case let (
            .minorCustomReflectable(type: lt, content: .empty(description: ld)),
            .minorCustomReflectable(type: rt, content: .empty(description: rd))
        ):
            return lt == rt
                && ld == rd

        default:
            return lhs == rhs
        }
    }
}

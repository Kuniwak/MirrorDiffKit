extension Diffable: Equatable {
    public static func == (_ lhs: Diffable, _ rhs: Diffable) -> Bool {
        switch (lhs, rhs) {
        case (.null, .null):
            return true

        case (.none, .none):
            return true

        case let (.string(l), .string(r)):
            return l == r

        case let (.number(type: lt, value: lv), .number(type: rt, value: rv)):
            return lt == rt
                && lv == rv

        case let (.bool(l), .bool(r)):
            return l == r

        case let (.date(l), .date(r)):
            return l == r

        case let (.url(l), .url(r)):
            return l == r

        case let (.type(l), .type(r)):
            return l == r

        case let (.tuple(l), .tuple(r)):
            return l == r

        case let (.collection(type: lt, elements: le), .collection(type: rt, elements: re)):
            return lt == rt
                && le == re

        case let (.set(l), .set(r)):
            return DiffableSet(l) == DiffableSet(r)

        case let (.dictionary(l), .dictionary(r)):
            guard l.count == r.count else { return false }

            return DiffableSet(l.map { $0.key }) == DiffableSet(r.map { $0.key })
                && DiffableSet(l.map { $0.value }) == DiffableSet(r.map { $0.value })

        case let (.anyEnum(type: lt, caseName: lc, associated: le), .anyEnum(type: rt, caseName: rc, associated: re)):
            return lt == rt
                && lc == rc
                && le == re

        case let (.anyStruct(type: lt, entries: le), .anyStruct(type: rt, entries: re)):
            return lt == rt
                && le == re

        case let (.anyClass(type: lt, entries: le), .anyClass(type: rt, entries: re)):
            return lt == rt
                && le == re

        case (.notSupported, .notSupported):
            // NOTE: This is an only only difference between Equatable and RoughEquatable.
            return false

        case (.unrecognizable, .unrecognizable):
            return false

        default:
            return false
        }
    }
}

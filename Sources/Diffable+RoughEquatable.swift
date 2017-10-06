extension Diffable: RoughEquatable {
    public static func =~ (_ lhs: Diffable, _ rhs: Diffable) -> Bool {
        switch (lhs, rhs) {
        case (.null, .null):
            return true

        case (.none, .none):
            return true

        case let (.string(l), .string(r)):
            return l == r

        case let (.number(l), .number(r)):
            return l == r

        case let (.bool(l), .bool(r)):
            return l == r

        case let (.tuple(l), .tuple(r)):
            return l == r

        case let (.array(l), .array(r)):
            return l == r

        case let (.set(l), .set(r)):
            return DiffableSet(l) == DiffableSet(r)

        case let (.dictionary(l), .dictionary(r)):
            guard l.count == r.count else { return false }

            for lEntry in l {
                if let rEntry = r.first(where: { rEntry in rEntry.key == lEntry.key }) {
                    if rEntry.value == rEntry.value {
                        continue
                    }
                    else {
                        return false
                    }
                }
                else {
                    return false
                }
            }

            return true

        case let (.date(l), .date(r)):
            return l == r

        case let (.url(l), .url(r)):
            return l == r

        case let (.anyEnum(type: lt, value: lv, associated: le), .anyEnum(type: rt, value: rv, associated: re)):
            do {
                return try lt == rt
                    && getEnumCaseName(lv) == getEnumCaseName(rv)
                    && le == re
            }
            catch {
                fatalError("\(error)")
            }

        case let (.anyStruct(type: lt, entries: le), .anyStruct(type: rt, entries: re)):
            return lt == rt
                && le == re

        case let (.anyClass(type: lt, entries: le), .anyClass(type: rt, entries: re)):
            return lt == rt
                && le == re

        case let (.notSupported(value: r), .notSupported(value: l)):
            // NOTE: This is an only difference between Equatable and RoughEquatable.
            return Mirror(reflecting: l).subjectType == Mirror(reflecting: r).subjectType
                && String(describing: l) == String(describing: r)

        case (.unrecognizable, .unrecognizable):
            return false

        default:
            return false
        }
    }
}

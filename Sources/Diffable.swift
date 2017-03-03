import Foundation


public indirect enum Diffable {
    case null
    case none
    case string(String)
    case number(Double)
    case bool(Bool)
    case date(Date)
    case type(Any.Type)
    case tuple([String: Diffable])
    case array([Diffable])

    // XXX: We can collect only Hashable values into Sets, but we cannot know
    // whether Diffable is a Hashable or not. And also we cannot cast to
    // Hashable because it is a generic protocol. Therefore we cannot handle
    // types that have a type restrictions.
    //
    case set([Diffable])

    case dictionary([String: Diffable])
    case anyEnum(type: Any.Type, value: Any, associated: [Diffable])
    case anyStruct(type: Any.Type, entries: [String: Diffable])
    case anyClass(type: Any.Type, entries: [String: Diffable])
    case generic(type: Any.Type, entries: [String: Diffable])
    case notSupported(value: Any)
    case unrecognizable(debugInfo: String)
}



extension Diffable: Equatable {
    public static func == (_ lhs: Diffable, _ rhs: Diffable) -> Bool {
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
        case let (.date(l), .date(r)):
            return l == r
        case let (.tuple(l), .tuple(r)):
            return l == r
        case let (.array(l), .array(r)):
            return l == r
        case let (.set(l), .set(r)):
            return DiffableSet(l) == DiffableSet(r)
        case let (.dictionary(l), .dictionary(r)):
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
        case let (.generic(type: lt, entries: le), .generic(type: rt, entries: re)):
            return lt == rt
                && le == re
        case (.notSupported, .notSupported):
            // NOTE: This is an only only defference between Equatable and RoughEquatable.
            return false
        case (.unrecognizable, .unrecognizable):
            return false
        default:
            return false
        }
    }
}


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
            return l == r
        case let (.date(l), .date(r)):
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
            // NOTE: This is an only defference between Equatable and RoughEquatable.
            return Mirror(reflecting: l).subjectType == Mirror(reflecting: r).subjectType
              && String(describing: l) == String(describing: r)
        case (.unrecognizable, .unrecognizable):
            return false
        default:
            return false
        }
    }
}

import Foundation


public indirect enum Diffable {
    case null
    case none
    case string(String)
    case number(Double)
    case bool(Bool)
    case tuple([String: Diffable])
    case array([Diffable])

    // XXX: We can collect only Hashable values into Sets, but we cannot know
    // whether Diffable is a Hashable or not. And also we cannot cast to
    // Hashable because it is a generic protocol. Therefore we cannot handle
    // types that have a type restrictions.
    //
    // case set([Diffable])

    case dictionary([String: Diffable])
    case anyNotAssociatedEnum(type: Any.Type, value: Any)
    case anyAssociatedEnum(type: Any.Type, entries: [String: Diffable])
    case anyStruct(type: Any.Type, entries: [String: Diffable])
    case anyClass(type: Any.Type, entries: [String: Diffable])
    case generic(type: Any.Type, entries: [String: Diffable])
    case unknown(Any)

    case date(Date)


    public static func from<T: DiffableConvertible>(_ x: T) -> Diffable {
        return x.diffable
    }


    public static func from(any x: Any) -> Diffable {
        return transform(fromAny: x)
    }


    public static func from(mirrorOf x: Any) -> Diffable {
        return transform(fromMirrorOf: x)
    }
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
        case let (.tuple(l), .tuple(r)):
            return l == r
        case let (.array(l), .array(r)):
            return l == r
        case let (.dictionary(l), .dictionary(r)):
            return l == r
        case let (.date(l), .date(r)):
            return l == r
        case let (.anyNotAssociatedEnum(type: lt, value: lv), .anyNotAssociatedEnum(type: rt, value: rv)):
            return lt == rt
                && String(describing: lv) == String(describing: rv)
        case let (.anyAssociatedEnum(type: lt, entries: le), .anyAssociatedEnum(type: rt, entries: re)):
            return lt == rt
                && le == re
        case let (.anyStruct(type: lt, entries: le), .anyStruct(type: rt, entries: re)):
            return lt == rt
                && le == re
        case let (.anyClass(type: lt, entries: le), .anyClass(type: rt, entries: re)):
            return lt == rt
                && le == re
        case let (.generic(type: lt, entries: le), .generic(type: rt, entries: re)):
            return lt == rt
                && le == re
        case (.unknown, .unknown):
            return false
        default:
            return false
        }
    }
}


func transform(fromAny x: Any?) -> Diffable {
    switch x {
    case .none:
        return .none
    case let .some(y):
        return transform(fromNonOptionalAny: y)
    }
}


private func transform(fromNonOptionalAny x: Any) -> Diffable {
    if let y = x as? NSNull {
        return Diffable.from(y)
    }

    // MARK: - Integer subtypes
    if let y = x as? Int {
        return Diffable.from(y)
    }

    if let y = x as? Int8 {
        return Diffable.from(y)
    }

    if let y = x as? Int16 {
        return Diffable.from(y)
    }

    if let y = x as? Int32 {
        return Diffable.from(y)
    }

    if let y = x as? Int64 {
        return Diffable.from(y)
    }

    if let y = x as? UInt {
        return Diffable.from(y)
    }

    if let y = x as? UInt8 {
        return Diffable.from(y)
    }

    if let y = x as? UInt16 {
        return Diffable.from(y)
    }

    if let y = x as? UInt32 {
        return Diffable.from(y)
    }

    if let y = x as? UInt64 {
        return Diffable.from(y)
    }


    // MARK: - FloatingPoint subtypes
    if let y = x as? Double {
        return Diffable.from(y)
    }

    if let y = x as? Float {
        return Diffable.from(y)
    }

    if let y = x as? Float32 {
        return Diffable.from(y)
    }

    if let y = x as? Float64 {
        return Diffable.from(y)
    }

    if let y = x as? Float80 {
        return Diffable.from(y)
    }


    // MARK: - String related types
    if let y = x as? Character {
        return Diffable.from(y)
    }

    if let y = x as? String {
        return Diffable.from(y)
    }


    // MARK: - Bool subtypes
    if let y = x as? Bool {
        return Diffable.from(y)
    }


    if let y = x as? Date {
        return Diffable.from(y)
    }


    // XXX: Avoid the following error (at least, Swift 3.0.2 or eariler):
    //
    // > Protocol "SpecialController" can only be used as a generic constraint
    // > because it has Self or associated type requirements.
    //
    // So, we can only try to cast concrete collection types. See all concerte
    // types in SDK: http://swiftdoc.org/v3.0/protocol/Collection/hierarchy/
    if let y = x as? [Any] {
        return Diffable.from(y)
    }

    return transform(fromMirrorOf: x)
}



func transform(fromMirrorOf x: Any) -> Diffable {
    do {
        let mirror = Mirror(reflecting: x)

        switch mirror.displayStyle {
            // XXX: Handle `nil` in a variable typed Any here.
            //
            // (lldb) po let $var: Any? = nil
            // (lldb) po let $container: Any = $var
            // (lldb) po $container == nil
            // false <- FUUUUUUUUUUUUU
            //
            // (lldb) po Mirror(reflecting: $container)
            // Mirror for Optional<Any>
            //
            // Therefore we can handle it by only using Mirrors.
        case .some(.optional):
            return .none

        case .some(.tuple):
            let entries = try transform(fromLabeledMirror: mirror)
            return .tuple(entries)

        case .some(.enum):
            if mirror.children.isEmpty {
                return .anyNotAssociatedEnum(type: mirror.subjectType, value: x)
            }

            let entries = try transform(fromLabeledMirror: mirror)
            return .anyAssociatedEnum(type: mirror.subjectType, entries: entries)

        case .some(.struct):
            let entries = try transform(fromLabeledMirror: mirror)
            return .anyStruct(type: mirror.subjectType, entries: entries)

        case .some(.class):
            let entries = try transform(fromLabeledMirror: mirror)
            return .anyClass(type: mirror.subjectType, entries: entries)

        case .none:
            // XXX: I don't know why but Generic structs and classes do not have .displayStyle.
            let entries = try transform(fromLabeledMirror: mirror)
            return .generic(type: mirror.subjectType, entries: entries)

        default:
            return .unknown(x)
        }
    }
    catch {
        return .unknown(x)
    }
}



private func transform(fromLabeledMirror mirror: Mirror) throws -> [String: Diffable] {
    var dictionary = [String: Diffable]()

    try mirror.children.forEach { (label, value) throws in
        guard let label = label else {
            let debugInfo = String(describing: ["entryValue": value])
            throw TransformError.unexpectedNilLabel(debugInfo: debugInfo)
        }
        dictionary[label] = transform(fromAny: value)
    }

    return dictionary
}



public enum TransformError: Error {
    case unexpectedNilLabel(debugInfo: String)
}


extension TransformError: Equatable {
    public static func == (_ lhs: TransformError, _ rhs: TransformError) -> Bool {
        switch (lhs, rhs) {
        case (.unexpectedNilLabel, .unexpectedNilLabel):
            return true
        }
    }
}

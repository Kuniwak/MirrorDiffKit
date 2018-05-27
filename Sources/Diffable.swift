import Foundation


public indirect enum Diffable {
    case null
    case none
    case string(type: Any.Type, content: String)
    case number(type: Any.Type, value: String)
    case bool(Bool)
    case date(Date)
    case url(URL)
    case type(Any.Type)
    case tuple(type: Any.Type, entries: [TupleEntry])
    case collection(type: Any.Type, elements: [Diffable])

    // XXX: We can collect only Hashable values into Sets, but we cannot know
    // whether Diffable is a Hashable or not. And also we cannot cast to
    // Hashable because it is a generic protocol. Therefore we cannot handle
    // types that have a type restrictions.
    case set(type: Any.Type, elements: [Diffable])

    case dictionary(type: Any.Type, entries: [(key: Diffable, value: Diffable)])
    case anyEnum(type: Any.Type, caseName: EnumCaseName, associated: [TupleEntry])
    case anyStruct(type: Any.Type, entries: [String: Diffable])
    case anyClass(type: Any.Type, entries: [String: Diffable])
    case minorCustomReflectable(type: Any.Type, content: CustomReflectableContent)
    case unrecognizable(debugInfo: String)


    public enum TupleEntry {
        case labeled(label: String, value: Diffable)
        case notLabeled(index: Int, value: Diffable)


        var value: Diffable {
            switch self {
            case let .labeled(label: _, value: value):
                return value

            case let .notLabeled(index: _, value: value):
                return value
            }
        }
    }


    public enum CustomReflectableContent {
        // NOTE: Some builtin types such as UnicodeScalar and Character have only empty children, but have identifiable description.
        // https://github.com/apple/swift/blob/ec5b51ec7c6f31e8d16bae762368032463bbac83/stdlib/public/core/Mirrors.swift.gyb#L21-L26
        case empty(description: String)
        case notEmpty(entries: [String: Diffable])
    }
}

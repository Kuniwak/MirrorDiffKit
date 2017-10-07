import Foundation


public indirect enum Diffable {
    case null
    case none
    case string(String)
    case number(Double)
    case bool(Bool)
    case date(Date)
    case url(URL)
    case type(Any.Type)
    case tuple([TupleEntry])
    case array([Diffable])

    // XXX: We can collect only Hashable values into Sets, but we cannot know
    // whether Diffable is a Hashable or not. And also we cannot cast to
    // Hashable because it is a generic protocol. Therefore we cannot handle
    // types that have a type restrictions.
    case set([Diffable])

    case dictionary([(key: Diffable, value: Diffable)])
    case anyEnum(type: Any.Type, caseName: EnumCaseName, associated: [TupleEntry])
    case anyStruct(type: Any.Type, entries: [String: Diffable])
    case anyClass(type: Any.Type, entries: [String: Diffable])
    case generic(type: Any.Type, entries: [String: Diffable])
    case notSupported(value: Any)
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
}

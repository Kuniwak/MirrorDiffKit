import Foundation


public indirect enum Diffable: Equatable, Hashable {
    case null
    case none
    case string(type: HashableType, content: String)
    case number(type: HashableType, value: String)
    case bool(Bool)
    case date(Date)
    case url(URL)
    case anyType(HashableType)
    case tuple(type: HashableType, entries: [TupleEntry])
    case collection(type: HashableType, elements: [Diffable])
    case set(type: HashableType, elements: Set<Diffable>)
    case dictionary(type: HashableType, entries: Set<DictionaryEntry>)
    case anyEnum(type: HashableType, caseName: EnumCaseName, associated: [TupleEntry])
    case anyStruct(type: HashableType, entries: [String: Diffable])
    case anyClass(type: HashableType, entries: [String: Diffable])
    case minorCustomReflectable(type: HashableType, content: CustomReflectableContent)
    case unrecognizable(debugInfo: String)


    public enum TupleEntry: Equatable, Hashable {
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


        var description: String {
            switch self {
            case let .labeled(label: label, value: value):
                return "\(label): \(value.description)"

            case let .notLabeled(index: _, value: value):
                return "\(value.description)"
            }
        }
    }


    public struct DictionaryEntry: Equatable, Hashable {
        public let key: Diffable
        public let value: Diffable


        public var description: String {
            return "\(self.key.description): \(self.value.description)"
        }


        public init(entry: (key: Diffable, value: Diffable)) {
            self.init(key: entry.key, value: entry.value)
        }


        public init(key: Diffable, value: Diffable) {
            self.key = key
            self.value = value
        }
    }


    public enum CustomReflectableContent: Equatable, Hashable {
        // NOTE: Some builtin types such as UnicodeScalar and Character have only empty children, but have identifiable description.
        // https://github.com/apple/swift/blob/ec5b51ec7c6f31e8d16bae762368032463bbac83/stdlib/public/core/Mirrors.swift.gyb#L21-L26
        case empty(description: String)
        case notEmpty(entries: [String: Diffable])
    }
}

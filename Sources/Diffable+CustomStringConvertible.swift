import Foundation



extension Diffable /*: CustomStringConvertible */ {
    public var description: String {
        switch self {
        case .null:
            return "NSNull()"

        case .none:
            return "nil"

        case let .unicodeScalar(unicodeScalar):
            return "UnicodeScalar(\"\(unicodeScalar)\")"

        case let .character(character):
            return "Character(\"\(character)\")"

        case let .string(type: type, content: content):
            if type == String.self {
                return "\"\(content)\""
            }
            return "\(type)(\"\(content)\")"

        case let .number(type: type, value: value):
            return "\(type)(\(value))"

        case let .bool(bool):
            return bool.description

        case let .date(date):
            return String(describing: date)

        case let .url(url):
            return url.absoluteString

        case let .type(type):
            return String(describing: type)

        case let .tuple(type: _, entries: entries):
            let content = entries
                .map { $0.description }
                .joined(separator: ", ")

            return "(" + content + ")"

        case let .collection(type: type, elements: entries):
            let content = entries
                .map { value in value.description }
                .joined(separator: ", ")

            return "\(type) [" + content + "]"

        case let .set(type: type, elements: elements):
            let content = elements
                .map { value in value.description }
                .joined(separator: ", ")

            return "\(type) [" + content + "]"

        case let .dictionary(type: type, entries: entries):
            guard !entries.isEmpty else { return "\(type) [:]" }

            let content = entries
                .sorted { $0.key.description <= $1.key.description }
                .map { (key, value) in "\(key.description): \(value.description)" }
                .joined(separator: ", ")

            return "\(type) [" + content + "]"

        case let .anyEnum(type: type, caseName: caseName, associated: associated):
            if associated.isEmpty {
                return "\(type).\(caseName.description)"
            }

            // INPUT: one("value")
            let tuplePart = associated
                .map { $0.description }
                .joined(separator: ", ")

            return "\(type).\(caseName.description)(\(tuplePart))"

        case let .anyStruct(type: type, entries: dictionary):
            let array = entries(fromDictionary: dictionary)

            guard !array.isEmpty else {
                return "struct \(type) {}"
            }

            let content = array
                .sorted { $0.key < $1.key }
                .map { (key, value) in "\(key): \(value.description)" }
                .joined(separator: ", ")

            return "struct \(type) { \(content) }"

        case let .anyClass(type: type, entries: dictionary):
            let array = entries(fromDictionary: dictionary)

            guard !array.isEmpty else {
                return "class \(type) {}"
            }

            let content = array
                .sorted { $0.key < $1.key }
                .map { (key, value) in "\(key): \(value.description)" }
                .joined(separator: ", ")

            return "class \(type) { \(content) }"

        case let .notSupported(value: x):
            return "notSupported<<value: \(x)>>"

        case let .unrecognizable(debugInfo):
            return "unrecognizable<<debugInfo: \(debugInfo)>>"
        }
    }
}

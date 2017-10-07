import Foundation



extension Diffable /*: CustomStringConvertible */ {
    public var description: String {
        switch self {
        case .null:
            return "NSNull()"

        case .none:
            return "nil"

        case let .string(string):
            return "\"\(string)\""

        case let .number(number):
            return number.description

        case let .bool(bool):
            return bool.description

        case let .date(date):
            return String(describing: date)

        case let .url(url):
            return url.absoluteString

        case let .type(type):
            return String(describing: type)

        case let .tuple(entries):
            let content = entries
                .map { $0.description }
                .joined(separator: ", ")

            return "(" + content + ")"

        case let .array(array):
            let content = array
                .map { value in value.description }
                .joined(separator: ", ")

            return "[" + content + "]"

        case let .set(array):
            let content = array
                .map { value in value.description }
                .joined(separator: ", ")

            return "Set [" + content + "]"

        case let .dictionary(diffables):
            guard !diffables.isEmpty else { return "[:]" }

            let content = diffables
                .sorted { $0.key.description <= $1.key.description }
                .map { (key, value) in "\(key.description): \(value.description)" }
                .joined(separator: ", ")

            return "[" + content + "]"

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

        case let .generic(type: type, entries: dictionary):
            guard !dictionary.isEmpty else {
                return "generic \(type) {}"
            }

            let content = entries(fromDictionary: dictionary)
                .sorted { $0.key < $1.key }
                .map { (key, value) in "\(key): \(value.description)" }
                .joined(separator: ", ")

            return "generic \(type) { (\(content)) }"

        case let .notSupported(value: x):
            return "notSupported<<value: \(x)>>"

        case let .unrecognizable(debugInfo):
            return "unrecognizable<<debugInfo: \(debugInfo)>>"
        }
    }
}

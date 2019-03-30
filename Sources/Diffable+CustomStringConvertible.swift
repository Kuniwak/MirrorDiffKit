import Foundation



extension Diffable /*: CustomStringConvertible */ {
    public var description: String {
        switch self {
        case .null:
            return "NSNull()"

        case .none:
            return "nil"

        case let .string(type: type, content: content):
            if type.actualType == String.self {
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

        case let .anyType(type):
            return "\(type).self"

        case let .tuple(type: _, entries: entries):
            let children = entries
                .map { $0.description }
                .joined(separator: ", ")

            return "(" + children + ")"

        case let .collection(type: type, elements: entries):
            let children = entries
                .map { value in value.description }
                .joined(separator: ", ")

            return "\(type) [" + children + "]"

        case let .set(type: type, elements: elements):
            let children = elements
                .map { value in value.description }
                .joined(separator: ", ")

            return "\(type) [" + children + "]"

        case let .dictionary(type: type, entries: entries):
            guard !entries.isEmpty else { return "\(type) [:]" }

            let children = entries
                .sorted { $0.key.description <= $1.key.description }
                .map { entry in entry.description }
                .joined(separator: ", ")

            return "\(type) [" + children + "]"

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

            let children = array
                .sorted { $0.key < $1.key }
                .map { (key, value) in "\(key): \(value.description)" }
                .joined(separator: ", ")

            return "struct \(type) { \(children) }"

        case let .anyClass(type: type, entries: dictionary):
            let array = entries(fromDictionary: dictionary)

            guard !array.isEmpty else {
                return "class \(type) {}"
            }

            let children = array
                .sorted { $0.key < $1.key }
                .map { (key, value) in "\(key): \(value.description)" }
                .joined(separator: ", ")

            return "class \(type) { \(children) }"

        case let .minorCustomReflectable(type: type, content: content):
            switch content {
            case let .empty(description: description):
                return "(unknown) \(type): CustomReflectable { description: \"\(description)\" }"

            case let .notEmpty(entries: dictionary):
                let array = entries(fromDictionary: dictionary)

                let children = array
                    .sorted { $0.key < $1.key }
                    .map { (key, value) in "\(key): \(value.description)" }
                    .joined(separator: ", ")

                return "(unknown) \(type): CustomReflectable { \(children) }"
            }

        case let .unrecognizable(debugInfo):
            return "unrecognizable<<debugInfo: \(debugInfo)>>"
        }
    }
}

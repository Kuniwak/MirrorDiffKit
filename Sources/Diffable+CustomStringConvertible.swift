import Foundation



extension Diffable /*: CustomStringConvertible */ {
    public var description: String {
        do {
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

            case let .type(type):
                return String(describing: type)

            case let .tuple(dictionary):
                let content = entries(fromDictionary: dictionary)
                    .sorted { $0.0 <= $1.0 }
                    .map { (key, value) in
                        let hasLabel = key[key.startIndex] != "."
                        if hasLabel {
                            return "\(key): \(value.description)"
                        }

                        return value.description
                    }
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

            case let .dictionary(dictionary):
                guard !dictionary.isEmpty else { return "[:]" }

                let content = entries(fromDictionary: dictionary)
                    .sorted { $0.0 <= $1.0 }
                    .map { (key, value) in "\"\(key)\": \(value.description)" }
                    .joined(separator: ", ")

                return "[" + content + "]"

            case let .anyEnum(type: type, value: value, associated: associated):
                if associated.isEmpty {
                    return "\(type).\(value)"
                }

                // INPUT: one("value")
                let caseName = try getEnumCaseName(value)
                let tuplePart = associated
                    .map { value in
                        // NOTE: value is a tuple but it has no labels.
                        return value.description
                    }
                    .joined(separator: ", ")

                return "\(type).\(caseName)(\(tuplePart))"

            case let .anyStruct(type: type, entries: dictionary):
                let array = entries(fromDictionary: dictionary)

                guard !array.isEmpty else {
                    return "struct \(type) {}"
                }

                let content = array
                    .sorted { $0.0 < $1.0 }
                    .map { (key, value) in "\(key): \(value.description)" }
                    .joined(separator: ", ")

                return "struct \(type) { \(content) }"

            case let .anyClass(type: type, entries: dictionary):
                let array = entries(fromDictionary: dictionary)

                guard !array.isEmpty else {
                    return "class \(type) {}"
                }

                let content = array
                    .sorted { $0.0 < $1.0 }
                    .map { (key, value) in "\(key): \(value.description)" }
                    .joined(separator: ", ")

                return "class \(type) { \(content) }"

            case let .generic(type: type, entries: dictionary):
                let array = entries(fromDictionary: dictionary)
                guard !array.isEmpty else { return "generic \(type) {}"
                }

                let content = array
                    .sorted { $0.0 < $1.0 }
                    .map { (key, value) in "\(key): \(value.description)" }
                    .joined(separator: ", ")

                return "generic \(type) { (\(content)) }"

            case let .notSupported(value: x):
                return "notSupported<<value: \(x)>>"

            case let .unrecognizable(debugInfo):
                return "unrecognizable<<debugInfo: \(debugInfo)>>"
            }
        }
        catch {
            return "unrecognizable<<error: \(error)>>"
        }
    }
}


func getEnumCaseName(_ value: Any) throws -> String {
    guard let caseName = String(describing: value).components(separatedBy: "(").first else {
        throw EnumCaseNameIsNil(value: value)
    }

    return caseName
}


struct EnumCaseNameIsNil: Error {
    let value: Any
}


struct UnknownType: Error {
    let value: Any
}

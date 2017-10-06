import Foundation



extension DifferentiaUnit {
    public enum DictionaryType {
        case dictionary
        case anyStruct(type: Any.Type)
        case anyClass(type: Any.Type)


        var token: (open: String, close: String) {
            switch self {
            case .dictionary:
                return (open: "[", close: "]")
            case .anyStruct, .anyClass:
                return (open: "\(self.name) {", close: "}")
            }
        }


        private var name: String {
            switch self {
            case .dictionary:
                return "Dictionary"
            case let .anyStruct(type: type):
                return "struct \(type)"
            case let .anyClass(type: type):
                return "class \(type)"
            }
        }
    }
}



extension DifferentiaUnit.DictionaryType: Equatable {
    public static func == (_ lhs: DifferentiaUnit.DictionaryType, _ rhs: DifferentiaUnit.DictionaryType) -> Bool {
        switch (lhs, rhs) {
        case (.dictionary, .dictionary):
            return true
        case let (.anyStruct(type: l), .anyStruct(type: r)):
            return l == r
        case let (.anyClass(type: l), .anyClass(type: r)):
            return l == r
        default:
            return false
        }
    }
}

import Foundation



struct OptionalStub {
    static let someValue = 10
    static var some: Int? { return self.someValue }
    static let none: Int? = nil
}



struct StructStub {
    struct Empty {}

    struct OneEntry {
        let key1: String
    }

    struct TwoEntries {
        let key1: String
        let key2: String
    }
}



struct ClassStub {
    class Empty {}

    class OneEntry {
        let key1: String

        init(key1: String) {
            self.key1 = key1
        }
    }

    class TwoEntries {
        let key1: String
        let key2: String

        init(key1: String, key2: String) {
            self.key1 = key1
            self.key2 = key2
        }
    }
}


struct EnumStub {
    enum NotAssociated {
        case one
        case two
    }

    enum NotAssociatedButTyped: Int {
        case one = 1
        case two = 2
    }

    enum AssociatedBySameKeys {
        case one(key: String)
        case two(key: String)
    }

    enum AssociatedByNotSameKeys {
        case one(key1a: String)
        case two(key1b: String, key2b: String)
    }
}


struct GenericStub<T> {
    let value: T
}

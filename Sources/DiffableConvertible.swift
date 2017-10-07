import Foundation

public protocol DiffableConvertible {
    var diffable: Diffable { get }
}


extension Int: DiffableConvertible {
    public var diffable: Diffable {
        return .number(Double(self))
    }
}


extension Int8: DiffableConvertible {
    public var diffable: Diffable {
        return .number(Double(self))
    }
}


extension Int16: DiffableConvertible {
    public var diffable: Diffable {
        return .number(Double(self))
    }
}


extension Int32: DiffableConvertible {
    public var diffable: Diffable {
        return .number(Double(self))
    }
}


extension Int64: DiffableConvertible {
    public var diffable: Diffable {
        return .number(Double(self))
    }
}


extension UInt: DiffableConvertible {
    public var diffable: Diffable {
        return .number(Double(self))
    }
}


extension UInt8: DiffableConvertible {
    public var diffable: Diffable {
        return .number(Double(self))
    }
}


extension UInt16: DiffableConvertible {
    public var diffable: Diffable {
        return .number(Double(self))
    }
}


extension UInt32: DiffableConvertible {
    public var diffable: Diffable {
        return .number(Double(self))
    }
}


extension UInt64: DiffableConvertible {
    public var diffable: Diffable {
        return .number(Double(self))
    }
}


extension Double: DiffableConvertible {
    public var diffable: Diffable {
        return .number(self)
    }
}


extension Float: DiffableConvertible {
    public var diffable: Diffable {
        return .number(Double(self))
    }
}


#if arch(x86_64) || arch(i386)
    extension Float80: DiffableConvertible {
        public var diffable: Diffable {
            return .number(Double(self))
        }
    }
#endif


extension Character: DiffableConvertible {
    public var diffable: Diffable {
        // NOTE: "a" == String(describing: Character("a"))
        return .string(String(describing: self))
    }
}


extension String: DiffableConvertible {
    public var diffable: Diffable {
        return .string(self)
    }
}


extension Bool: DiffableConvertible {
    public var diffable: Diffable {
        return .bool(self)
    }
}


extension Date: DiffableConvertible {
    public var diffable: Diffable {
        return .date(self)
    }
}


extension Array: DiffableConvertible {
    public var diffable: Diffable {
        return .array(self.map(transform(fromAny:)))
    }
}


extension Dictionary: DiffableConvertible {
    public var diffable: Diffable {
        var result = [(key: Diffable, value: Diffable)]()

        self.forEach { entry in
            let (key, value) = entry

            result.append((
                key: transform(fromAny: key),
                value: transform(fromAny: value)
            ))
        }

        return .dictionary(result)
    }
}


extension NSNull: DiffableConvertible {
    public var diffable: Diffable {
        return .null
    }
}


extension Optional: DiffableConvertible {
    public var diffable: Diffable {
        return transform(fromAny: self as Any?)
    }
}


extension Set: DiffableConvertible {
    public var diffable: Diffable {
        return transform(fromAny: self as Any?)
    }
}


extension URL: DiffableConvertible {
    public var diffable: Diffable {
        return .url(self)
    }
}

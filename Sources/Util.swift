internal func entries<K, V>(fromDictionary dictionary: [K: V]) -> [(key: K, value: V)] {
    var result: [(key: K, value: V)] = []

    for (key ,value) in dictionary {
        result.append((key: key, value: value))
    }

    return result
}


internal func isNumberLike(_ x: Any) -> Bool {
    if isNumberType(type(of: x)) {
        return true
    }

    // XXX: For number wrapper types such as CGFloat.
    //      The wrapper have .customMirror based on the wrapped number.
    return isNumberType(Mirror(reflecting: x).subjectType)
}


private func isNumberType(_ type: Any.Type) -> Bool {
    if type == Int.self
           || type == Int8.self
           || type == Int16.self
           || type == Int32.self
           || type == Int64.self
           || type == UInt.self
           || type == UInt8.self
           || type == UInt16.self
           || type == UInt32.self
           || type == UInt64.self
           || type == Double.self
           || type == Float.self
           || type == Float32.self
           || type == Float64.self {
        return true
    }

    #if arch(x86_64) || arch(i386)
        if type == Float64.self {
            return true
        }
    #endif

    return false
}


internal func isStringLike(_ x: Any) -> Bool {
    if type(of: x) == String.self {
        return true
    }

    // XXX: For string like types such as Substring.
    //      The type have .customMirror like a mirror of strings.
    return Mirror(reflecting: x).subjectType == String.self
}

import Foundation



func transform(fromAny x: Any?) -> Diffable {
    switch x {
    case .none:
        return .none
    case let .some(y):
        return transformFromNonOptionalAny(y)
    }
}


private func transformFromNonOptionalAny(_ x: Any) -> Diffable {
    if let y = x as? DiffableConvertible {
        return y.diffable
    }

    let type = Swift.type(of: x)

    if type == NSNull.self {
        return .null
    }

    if isNumberLike(x) {
        return .number(type: type, value: "\(x)")
    }

    if let y = x as? UnicodeScalar {
        return .unicodeScalar(y)
    }

    if let y = x as? Character {
        return .character(y)
    }

    if isStringLike(x) {
        return .string(type: type, content: "\(x)")
    }

    if let y = x as? Bool {
        return .bool(y)
    }

    if let y = x as? Date {
        return .date(y)
    }

    if let y = x as? URL {
        return .url(y)
    }

    return transformMirror(of: x)
}

func transformMirror(of x: Any) -> Diffable {
    do {
        let mirror = Mirror(reflecting: x)

        switch mirror.displayStyle {

        case .some(.optional):
            // XXX: Handle `nil` in a variable typed Any here.
            //
            // (lldb) po let $var: Any? = nil
            // (lldb) po let $container: Any = $var
            // (lldb) po $container == nil
            // false <- FUUUUUUUUUUUUU
            //
            // (lldb) po Mirror(reflecting: $container)
            // Mirror for Optional<Any>
            //
            // Therefore we can handle it by only using Mirrors.
            if let firstChild = mirror.children.first {
                return transform(fromAny: firstChild.value)
            }
            else {
                return .none
            }

        case .some(.tuple):
            let entries = transformFromTupleMirror(of: mirror)
            return .tuple(entries)

        case .some(.set):
            let elements = transformFromNonLabeledMirror(of: mirror)
            // NOTE: .subjectType should not to be used. Because .subjectType can be different from
            // the original type if x is a CustomReflectable.
            let trulyType = type(of: x)
            return .set(type: trulyType, elements: elements)

        case .some(.collection):
            let elements = transformFromNonLabeledMirror(of: mirror)
            // NOTE: .subjectType should not to be used. Because .subjectType can be different from
            // the original type if x is a CustomReflectable.
            let trulyType = type(of: x)
            return .collection(type: trulyType, elements: elements)

        case .some(.dictionary):
            let entries = try transformFromDictionaryEntryMirror(of: mirror)
            // NOTE: .subjectType should not to be used. Because .subjectType can be different from
            // the original type if x is a CustomReflectable.
            let trulyType = type(of: x)
            return .dictionary(type: trulyType, entries: entries)

        case .some(.enum):
            let associated = transformFromEnumMirror(of: mirror)
            // NOTE: .subjectType should not to be used. Because .subjectType can be different from
            // the original type if x is a CustomReflectable.
            let trulyType = type(of: x)

            return .anyEnum(
                type: trulyType,
                caseName: try .from(mirror: mirror, original: x),
                associated: associated
            )

        case .some(.struct):
            let entries = try transformFromLabeledMirror(of: mirror)
            // NOTE: .subjectType should not to be used. Because .subjectType can be different from
            // the original type if x is a CustomReflectable.
            let trulyType = type(of: x)
            return .anyStruct(type: trulyType, entries: entries)

        case .some(.class):
            let entries = try transformFromLabeledMirror(of: mirror)
            // NOTE: .subjectType should not to be used. Because .subjectType can be different from
            // the original type if x is a CustomReflectable.
            let trulyType = type(of: x)
            return .anyClass(type: trulyType, entries: entries)

        case .none:
            return .notSupported(value: x)

        }
    }
    catch {
        return .unrecognizable(debugInfo: "error=`\(error)`, value=`\(x)`")
    }
}



private func transformFromLabeledMirror(of mirror: Mirror) throws -> [String: Diffable] {
    var dictionary = [String: Diffable]()

    try mirror.children.forEach { (label, value) throws in
        guard let label = label else {
            let debugInfo = String(describing: ["entryValue": value])
            throw TransformError.unexpectedNilLabel(debugInfo: debugInfo)
        }
        dictionary[label] = transform(fromAny: value)
    }

    return dictionary
}



private func transformFromDictionaryEntryMirror(of mirror: Mirror) throws -> [(key: Diffable, value: Diffable)] {
    return try mirror.children.map { (_, value) -> (key: Diffable, value: Diffable) in
        guard let tuple = value as? (Any, Any) else {
            throw TransformError.unexpectedNotTuple(debugInfo: "\(value)")
        }

        return (
            key: transform(fromAny: tuple.0),
            value: transform(fromAny: tuple.1)
        )
    }
}



private func transformFromNonLabeledMirror(of mirror: Mirror) -> [Diffable] {
    return mirror.children.map { (_, value) in transform(fromAny: value) }
}


private func transformFromTupleMirror(of mirror: Mirror) -> [Diffable.TupleEntry] {
    // NOTE: Tuple's children of mirror do not have consistent representations:
    //
    //   - void tuple's children = [T] (empty)
    //   - unary tuple's children = T
    //   - N-ary tuple's children = [T]

    // It is a N-ary tuple. (N >= 2)
    return mirror.children
        .enumerated()
        .map { (entry) in
            let (index, child) = entry

            // XXX: In this case, the label is a associated value name.
            //
            //      MyEnum.myCase(label: "value")
            //                    ^^^^^
            //
            // XXX: The labels are ".0", ".1" when given MyEnum.myCase(Any, Any)
            if let label = child.label, label != ".\(index)" {
                return .labeled(
                    label: label,
                    value: transform(fromAny: child.value)
                )
            }
            else {
                return .notLabeled(
                    index: index,
                    value: transform(fromAny: child.value)
                )
            }
        }
}


private func transformFromEnumMirror(of mirror: Mirror) -> [Diffable.TupleEntry] {
    // NOTE: Tuple's children of mirror do not have consistent representations:
    //
    //   - void tuple's children = [T] (empty)
    //   - unary tuple's children = T
    //   - N-ary tuple's children = [T]

    guard let firstChild = mirror.children.first else {
        // It is a void tuple.
        return []
    }

    let childMirror = Mirror(reflecting: firstChild.value)

    guard childMirror.displayStyle == .tuple else {
        // XXX: It is an unary tuple.
        return [
            .notLabeled(
                index: 0,
                value: transform(fromAny: firstChild.value)
            )
        ]
    }

    // It is a N-ary tuple. (N >= 2)
    return childMirror.children
        .enumerated()
        .map { (entry) in
            let (index, child) = entry

            // XXX: In this case, the label is a associated value name.
            //
            //      MyEnum.myCase(label: "value")
            //                    ^^^^^
            //
            // XXX: The labels are ".0", ".1" when given MyEnum.myCase(Any, Any)
            if let label = child.label, label != ".\(index)" {
                return .labeled(
                    label: label,
                    value: transform(fromAny: child.value)
                )
            }
            else {
                return .notLabeled(
                    index: index,
                    value: transform(fromAny: child.value)
                )
            }
        }
}



enum TransformError: Error {
    case unexpectedNilLabel(debugInfo: String)
    case unexpectedMirrorStructureForAssociatedTuple(debugInfo: String)
    case unexpectedNotTuple(debugInfo: String)
}


extension TransformError: Equatable {
    static func == (_ lhs: TransformError, _ rhs: TransformError) -> Bool {
        switch (lhs, rhs) {
        case (.unexpectedNilLabel, .unexpectedNilLabel):
            return true
        case (.unexpectedMirrorStructureForAssociatedTuple, .unexpectedMirrorStructureForAssociatedTuple):
            return true
        default:
            return false
        }
    }
}

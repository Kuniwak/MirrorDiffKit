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
        return .number(type: HashableType(type: type), value: "\(x)")
    }

    if isStringLike(x) {
        return .string(type: HashableType(type: type), content: "\(x)")
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
        
        if let displayStyle = mirror.displayStyle {
            switch displayStyle {
                
            case .optional:
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
                
            case .tuple:
                let entries = transformFromTupleMirror(of: mirror)
                // NOTE: .subjectType should not to be used. Because .subjectType can be different from
                // the original type if x is a CustomReflectable.
                return .tuple(type: .type(of: x), entries: entries)
                
            case .set:
                let elements = transformFromNonLabeledMirror(of: mirror)
                // NOTE: .subjectType should not to be used. Because .subjectType can be different from
                // the original type if x is a CustomReflectable.
                return .set(type: .type(of: x), elements: Set(elements))
                
            case .collection:
                let elements = transformFromNonLabeledMirror(of: mirror)
                // NOTE: .subjectType should not to be used. Because .subjectType can be different from
                // the original type if x is a CustomReflectable.
                return .collection(type: .type(of: x), elements: elements)
                
            case .dictionary:
                let entries = try transformFromDictionaryEntryMirror(of: mirror)
                // NOTE: .subjectType should not to be used. Because .subjectType can be different from
                // the original type if x is a CustomReflectable.
                return .dictionary(type: .type(of: x), entries: Set(entries.map(Diffable.DictionaryEntry.init(entry:))))
                
            case .enum:
                let associated = transformFromEnumMirror(of: mirror)
                // NOTE: .subjectType should not to be used. Because .subjectType can be different from
                // the original type if x is a CustomReflectable.
                return .anyEnum(
                    type: .type(of: x),
                    caseName: try .from(mirror: mirror, original: x),
                    associated: associated
                )
                
            case .struct:
                let entries = try transformFromLabeledMirror(of: mirror)
                // NOTE: .subjectType should not to be used. Because .subjectType can be different from
                // the original type if x is a CustomReflectable.
                return .anyStruct(type: .type(of: x), entries: entries)
                
            case .class:
                let entries = try transformFromLabeledMirror(of: mirror)
                // NOTE: .subjectType should not to be used. Because .subjectType can be different from
                // the original type if x is a CustomReflectable.
                return .anyClass(type: .type(of: x), entries: entries)

            @unknown default:
                return .unrecognizable(debugInfo: "reason=UNKNOWN_DISPLAY_STYLE, displayStyle=`\(displayStyle)`, description=`\(x)`")
            }
        }
    
        // NOTE: The types can have nil .displayType are only MetaTypes and OpaqueImpls and some CustomReflectables.
        // https://github.com/apple/swift/blob/3ec7fc169d21f805366c19c0f8e1d437646c6149/stdlib/public/runtime/ReflectionMirror.mm#L512
        // https://github.com/apple/swift/blob/c35d508600516b892732e2fd3f0f0a17ca4562ba/stdlib/public/core/ReflectionMirror.swift#L154

        if let y = x as? Any.Type {
            return .anyType(HashableType(type: y))
        }

        // NOTE: .subjectType should not to be used. Because .subjectType can be different from
        // the original type if x is a CustomReflectable.
        let trulyType = HashableType(of: x)
        let entries = try transformFromLabeledMirror(of: mirror)

        if let y = x as? CustomReflectable {
            guard !entries.isEmpty else {
                return .minorCustomReflectable(type: trulyType, content: .empty(description: "\(y)"))
            }
            return .minorCustomReflectable(type: trulyType, content: .notEmpty(entries: entries))
        }

        return .unrecognizable(debugInfo: "reason=UNKNOWN_TYPE, type=`\(trulyType)`, description=`\(x)`")
    }
    catch {
        return .unrecognizable(debugInfo: "reason=TRANSFORM_ERROR, error=`\(error)`, value=`\(x)`")
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

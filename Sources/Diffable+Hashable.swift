extension Diffable: Hashable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .null:
            hasher.combine(0)

        case .none:
            hasher.combine(1)

        case let .string(type: type, content: content):
            hasher.combine(HashableType(type))
            hasher.combine(content)

        case let .number(type: type, value: value):
            hasher.combine(HashableType(type))
            hasher.combine(value)

        case let .bool(bool):
            hasher.combine(bool)

        case let .date(date):
            hasher.combine(date)

        case let .url(url):
            hasher.combine(url)

        case let .type(type):
            hasher.combine(HashableType(type))

        case let .tuple(type: type, entries: entries):
            hasher.combine(HashableType(type))
            hasher.combine(entries)

        case let .collection(type: type, elements: elements):
            hasher.combine(HashableType(type))
            hasher.combine(elements)

        case let .set(type: type, elements: elements):
            hasher.combine(HashableType(type))
            hasher.combine(elements)

        case let .dictionary(type: type, entries: entries):
            hasher.combine(HashableType(type))
            hasher.combine(entries)

        case let .anyEnum(type: type, caseName: _, associated: associated):
            hasher.combine(HashableType(type))
            hasher.combine(associated)

        case let .anyStruct(type: type, entries: entries):
            hasher.combine(HashableType(type))
            hasher.combine(entries)

        case let .anyClass(type: type, entries: entries):
            hasher.combine(HashableType(type))
            hasher.combine(entries)

        case let .minorCustomReflectable(type: type, content: content):
            hasher.combine(HashableType(type))
            hasher.combine(content)

        case .unrecognizable:
            hasher.combine(Int.max)
        }
    }
}

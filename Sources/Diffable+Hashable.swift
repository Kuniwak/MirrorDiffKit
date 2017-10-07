extension Diffable: Hashable {
    public var hashValue: Int {
        switch self {
        case .null:
            return 0

        case .none:
            return 1

        case let .string(string):
            return string.hashValue

        case let .number(number):
            return number.hashValue

        case let .bool(bool):
            return bool.hashValue

        case let .date(date):
            return date.hashValue

        case let .url(url):
            return url.hashValue

        case let .type(type):
            return String(describing: type).hashValue

        case let .tuple(entries):
            return entries.reduce(0, { (prev, entry) in prev + entry.value.hashValue })

        case let .array(array):
            return array.reduce(0, { (prev, element) in prev + element.hashValue })

        case let .set(array):
            return array.reduce(0, { (prev, element) in prev + element.hashValue })

        case let .dictionary(entries):
            return entries.map { $0.key }.reduce(0, { (prev, key) in prev + key.hashValue })

        case let .anyEnum(type: type, caseName: _, associated: associated):
            return String(describing: type).hashValue
                + associated.reduce(0, { (prev, element) in prev + element.value.hashValue })

        case let .anyStruct(type: type, entries: entries):
            return String(describing: type).hashValue
                + entries.values.reduce(0, { (prev, value) in prev + value.hashValue })

        case let .anyClass(type: type, entries: entries):
            return String(describing: type).hashValue
                + entries.values.reduce(0, { (prev, value) in prev + value.hashValue })

        case let .generic(type: type, entries: entries):
            return String(describing: type).hashValue
                + entries.values.reduce(0, { (prev, value) in prev + value.hashValue })

        case let .notSupported(value: value):
            return String(describing: value).hashValue

        case .unrecognizable:
            return Int.max
        }
    }
}

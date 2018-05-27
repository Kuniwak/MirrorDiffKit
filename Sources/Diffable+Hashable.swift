extension Diffable: Hashable {
    public var hashValue: Int {
        switch self {
        case .null:
            return 0

        case .none:
            return 1

        case let .unicodeScalar(unicodeScalar):
            return unicodeScalar.hashValue

        case let .character(character):
            return character.hashValue

        case let .string(type: type, content: content):
            return MirrorDiffKit.hashValue(from: type) ^ content.hashValue

        case let .number(type: type, value: value):
            return MirrorDiffKit.hashValue(from: type) ^ value.hashValue

        case let .bool(bool):
            return bool.hashValue

        case let .date(date):
            return date.hashValue

        case let .url(url):
            return url.hashValue

        case let .type(type):
            return MirrorDiffKit.hashValue(from: type)

        case let .tuple(type: type, entries: entries):
            return MirrorDiffKit.hashValue(from: type)
                ^ entries.reduce(0, { (prev, entry) in prev + entry.value.hashValue })

        case let .collection(type: type, elements: elements):
            return MirrorDiffKit.hashValue(from: type)
                ^ elements.reduce(0, { (prev, element) in prev + element.hashValue })

        case let .set(type: type, elements: elements):
            return MirrorDiffKit.hashValue(from: type)
                ^ elements.reduce(0, { (prev, element) in prev + element.hashValue })

        case let .dictionary(type: type, entries: entries):
            return MirrorDiffKit.hashValue(from: type)
                ^ entries.map { $0.key }.reduce(0, { (prev, key) in prev + key.hashValue })

        case let .anyEnum(type: type, caseName: _, associated: associated):
            return MirrorDiffKit.hashValue(from: type)
                ^ associated.reduce(0, { (prev, element) in prev + element.value.hashValue })

        case let .anyStruct(type: type, entries: entries):
            return MirrorDiffKit.hashValue(from: type)
                ^ entries.values.reduce(0, { (prev, value) in prev + value.hashValue })

        case let .anyClass(type: type, entries: entries):
            return MirrorDiffKit.hashValue(from: type)
                ^ entries.values.reduce(0, { (prev, value) in prev + value.hashValue })

        case let .notSupported(value: value):
            return String(describing: value).hashValue

        case .unrecognizable:
            return Int.max
        }
    }
}

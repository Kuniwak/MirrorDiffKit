import Foundation



public indirect enum DifferentiaUnit {
    case notChanged(Diffable)
    case inserted(Diffable)
    case deleted(Diffable)
    case dictionaryChanged(kind: DifferentiaUnit.DictionaryType, [String: [DifferentiaUnit]])
    case sequenceChanged(kind: DifferentiaUnit.SequenceType, [DifferentiaUnit])
}



extension DifferentiaUnit: Equatable {
    public static func == (_ lhs: DifferentiaUnit, _ rhs: DifferentiaUnit) -> Bool {
        switch (lhs, rhs) {
        case let (.notChanged(l), .notChanged(r)):
            return l == r
        case let (.inserted(l), .inserted(r)):
            return l == r
        case let (.deleted(l), .deleted(r)):
            return l == r
        case let (.dictionaryChanged(kind: lk, ld), .dictionaryChanged(kind: rk, rd)):
            return lk == rk
                && DifferentiaUnitComparableDictionary.from(dictionary: ld)
                    == DifferentiaUnitComparableDictionary.from(dictionary: rd)
        case let (.sequenceChanged(kind: lk, ld), .sequenceChanged(kind: rk, rd)):
            return lk == rk
                && ld == rd
        default:
            return false
        }
    }
}

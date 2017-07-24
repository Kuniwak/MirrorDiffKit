import Foundation



indirect enum DifferentiaUnit {
    case notChanged(Diffable)
    case inserted(Diffable)
    case deleted(Diffable)
    case child(kind: DifferentiaUnit.DictionaryType, [String: Differentia])
}



extension DifferentiaUnit: Equatable {
    static func == (_ lhs: DifferentiaUnit, _ rhs: DifferentiaUnit) -> Bool {
        switch (lhs, rhs) {
        case let (.notChanged(l), .notChanged(r)):
            return l == r
        case let (.inserted(l), .inserted(r)):
            return l == r
        case let (.deleted(l), .deleted(r)):
            return l == r
        case let (.child(kind: lk, ld), .child(kind: rk, rd)):
            return lk == rk
                && ld == rd
        default:
            return false
        }
    }
}

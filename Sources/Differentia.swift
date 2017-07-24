import Foundation



struct Differentia {
    let units: [DifferentiaUnit]
}



extension Differentia: Equatable {
    static func == (_ lhs: Differentia, _ rhs: Differentia) -> Bool {
        return lhs.units == rhs.units
    }
}

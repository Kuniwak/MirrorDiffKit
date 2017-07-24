import Foundation



// NOTE: This class is for only the purpose that is making [String: [DifferentiaUnit]] equatable.
// TODO: Fix me when conditional conformance (SE-0143) is arrived.
struct DifferentiaUnitComparableDictionary: Equatable {
    let dictionary: [String: ComparableDifferentiaUnits]



    static func ==(lhs: DifferentiaUnitComparableDictionary, rhs: DifferentiaUnitComparableDictionary) -> Bool {
        return lhs.dictionary == rhs.dictionary
    }


    static func from(dictionary: [String: [DifferentiaUnit]]) -> DifferentiaUnitComparableDictionary {
        var result: [String: ComparableDifferentiaUnits] = [:]

        dictionary.forEach { (key, units) in
            result[key] = ComparableDifferentiaUnits(units: units)
        }

        return DifferentiaUnitComparableDictionary(dictionary: result)
    }


    struct ComparableDifferentiaUnits: Equatable {
        let units: [DifferentiaUnit]


        static func ==(lhs: ComparableDifferentiaUnits, rhs: ComparableDifferentiaUnits) -> Bool {
            return lhs.units == rhs.units
        }
    }
}

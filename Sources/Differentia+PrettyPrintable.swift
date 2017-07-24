import Foundation



extension Differentia: PrettyPrintable {
    var prettyLines: [PrettyLine] {
        return self.units
            .flatMap { unit -> [PrettyLine] in unit.prettyLines }
    }
}

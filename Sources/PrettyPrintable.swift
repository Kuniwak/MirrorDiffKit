import Foundation



protocol PrettyPrintable {
    var prettyLines: [PrettyLine] { get }
}


extension PrettyPrintable /*: CustomStringConvertible */ {
    var description: String {
        return PrettyPrinter.print(fromLines: self.prettyLines)
    }
}


indirect enum PrettyLine /*: CustomStringConvertible */ {
    case indent(PrettyLine)
    case line(String)


    var description: String {
        switch self {
        case let .indent(line):
            return "    \(line.description)"
        case let .line(string):
            return string
        }
    }
}



extension PrettyLine: Equatable {
    static func == (_ lhs: PrettyLine, _ rhs: PrettyLine) -> Bool {
        return lhs.description == rhs.description
    }
}

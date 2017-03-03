import Foundation



protocol PrettyPrintable /*: CustomStringConvertible */ {
    var prettyLines: [PrettyLine] { get }
}


extension PrettyPrintable {
    var description: String {
        return self.prettyLines
            .map { $0.description }
            .joined(separator: "\n")
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

protocol PrettyPrintable {
    var prettyLines: [PrettyLine] { get }
}


extension PrettyPrintable /*: CustomStringConvertible */ {
    var description: String {
        return PrettyPrinter.print(fromLines: self.prettyLines)
    }
}

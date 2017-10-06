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


    var indentLevel: Int {
        switch self {
        case .line:
            return 0

        case let .indent(line):
            return 1 + line.indentLevel
        }
    }


    func addIndentLevel(count: Int) -> PrettyLine {
        guard count > 0 else {
            return self
        }

        return .indent(self.addIndentLevel(count: count - 1))
    }


    static func addIndentLevel(lines: [PrettyLine], count: Int) -> [PrettyLine] {
        return lines.map { $0.addIndentLevel(count: count) }
    }


    static func concatKeyLineAndValueLines(_ a: PrettyLine, and b: PrettyLine, with separator: String) -> PrettyLine {
        switch (a, b) {
        case let (.line(a), .line(b)):
            return .line(a + separator + b)

        case let (.indent(a), .line(b)):
            return .indent(self.concatKeyLineAndValueLines(a, and: .line(b), with: separator))

        case let (.line(a), .indent(b)):
            return self.concatKeyLineAndValueLines(.line(a), and: b, with: separator)

        case let (.indent(a), .indent(b)):
            return .indent(self.concatKeyLineAndValueLines(a, and: b, with: separator))
        }
    }


    static func concatKeyLineAndValueLines(_ a: [PrettyLine], and b: [PrettyLine], with separator: String) -> [PrettyLine] {
        let lastAndRest = self.splitLast(a)
        guard let last = lastAndRest.last else {
            return b
        }

        let firstAndRest = self.splitFirst(b)
        guard let first = firstAndRest.first else {
            return a
        }

        let previousIndentLevel = last.indentLevel

        return lastAndRest.rest
            + [self.concatKeyLineAndValueLines(last, and: first, with: separator)]
            + firstAndRest.rest.map { $0.addIndentLevel(count: previousIndentLevel)}
    }


    private static func splitFirst<T>(_ array: [T]) -> (first: T?, rest: [T]) {
        guard let first = array.first else {
            return (first: nil, rest: [])
        }

        var newArray = array
        newArray.removeFirst()

        return (first: first, rest: newArray)
    }


    private static func splitLast<T>(_ array: [T]) -> (last: T?, rest: [T]) {
        guard let last = array.last else {
            return (last: nil, rest: [])
        }

        var newArray = array
        newArray.removeLast()

        return (last: last, rest: newArray)
    }
}



extension PrettyLine: Equatable {
    static func == (_ lhs: PrettyLine, _ rhs: PrettyLine) -> Bool {
        return lhs.description == rhs.description
    }
}

extension Diffable.TupleEntry: PrettyPrintable {
    internal var prettyLines: [PrettyLine] {
        switch self {
        case let .labeled(label: label, value: value):
            return PrettyLine.concatKeyLineAndValueLines(
                [.line("\(label):")],
                and: value.prettyLines,
                with: " "
            )

        case let .notLabeled(index: _, value: value):
            return value.prettyLines
        }
    }
}
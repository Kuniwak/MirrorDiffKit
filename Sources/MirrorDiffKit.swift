public func diff(between a: Any, and b: Any) -> String {
    let diff = Diffable.diff(
        between: Diffable.from(any: a),
        and: Diffable.from(any: b)
    )

    let prettyLines = diff.flatMap { (unit) in
        return unit.prettyLines
    }

    return "\n\(PrettyPrinter.print(fromLines: prettyLines))\n"
}
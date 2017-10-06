infix operator =~: ComparisonPrecedence
infix operator !~: ComparisonPrecedence


public func =~<T> (_ lhs: T, _ rhs: T) -> Bool {
    return Diffable.from(any: lhs) =~ Diffable.from(any: rhs)
}


public func !~<T> (_ lhs: T, _ rhs: T) -> Bool {
    return Diffable.from(any: lhs) !~ Diffable.from(any: rhs)
}


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
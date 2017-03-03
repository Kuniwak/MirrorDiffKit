public func diff(between a: Any, and b: Any) -> String {
    let result = Diffable.diff(
        between: Diffable.from(any: a),
        and: Diffable.from(any: b)
    )

    return "\n\(result.description)\n"
}
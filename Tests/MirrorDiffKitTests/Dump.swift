func dump(_ x: Any) -> String {
    var result = ""
    Swift.dump(x, to: &result)
    return result
}
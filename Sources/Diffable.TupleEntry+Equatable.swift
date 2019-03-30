extension Diffable.TupleEntry: Equatable {
    public static func ==(lhs: Diffable.TupleEntry, rhs: Diffable.TupleEntry) -> Bool {
        switch (lhs, rhs) {
        case let (.labeled(label: ll, value: lv), .labeled(label: rl, value: rv)):
            return ll == rl
                && lv == rv

        case let (.notLabeled(index: li, value: lv), .notLabeled(index: ri, value: rv)):
            return li == ri
                && lv == rv

        default:
            return false
        }
    }
}
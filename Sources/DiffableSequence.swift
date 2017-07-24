import Foundation



class DiffableSequence {
    let elements: [Diffable]


    init(_ elements: [Diffable]) {
        self.elements = elements
    }


    static func diff(between a: DiffableSequence, and b: DiffableSequence) -> [DifferentiaUnit] {
        var lcs = a.elements.LCS(b.elements)
        let diff = a.elements.diff(b.elements)

        // NOTE; This algorithm is based on the following table:
        //
        // | Insertion | Deletion | LCS consumed | Line diff |
        // | index     | index    |              | Line diff |
        // |:----------|----------|:-------------|:----------|
        // | N         | N        | YES          | +1        |
        // | N + 1     | N        | YES          | +1        |
        // | N         | N + 1    | YES          | +1        |
        // | N + 1     | N + 1    | NO           | +1        | (N > 0)

        // XXX: This algorithm is order-sensitive. But the order of
        // deletions are reversed. So, we should sort these collections
        // to avoid this effect.
        var insertions = diff.insertions.sorted { $0.idx < $1.idx }
        var deletions = diff.deletions.sorted { $0.idx < $1.idx }

        var index = -1
        var result: [DifferentiaUnit] = []
        var wasDeleted = false
        var wasInserted = false

        while !(lcs.isEmpty && insertions.isEmpty && deletions.isEmpty) {
            index += 1
            wasDeleted = false
            wasInserted = false

            if let deletionFirst = deletions.first, deletionFirst.idx <= index {
                var prev = deletionFirst
                var isContinuous = true

                // NOTE: Repeat if this deletion is continuous to next line.
                // Because the Example B is better than Example A.
                //
                // Example A:
                //
                //   - L1 before
                //   + L1 after
                //   - L2 before
                //   + L2 after
                //
                // Example B:
                //
                //   - L1 before
                //   - L2 before
                //   + L1 after
                //   + L2 after
                while isContinuous {
                    prev = deletions.remove(at: 0)
                    result.append(.deleted(prev.value))

                    if let next = deletions.first {
                        isContinuous = next.idx == prev.idx + 1
                    }
                    else {
                        isContinuous = false
                    }
                }

                wasDeleted = true
            }

            if let insertionFirst = insertions.first, insertionFirst.idx <= index {
                var prev = insertionFirst
                var isContinuous = true


                while isContinuous {
                    prev = insertions.remove(at: 0)
                    result.append(.inserted(prev.value))

                    if let next = insertions.first {
                        isContinuous = next.idx == prev.idx + 1
                    }
                    else {
                        isContinuous = false
                    }
                }

                wasInserted = true
            }

            if wasInserted || wasDeleted {
                if wasInserted && wasDeleted {
                    continue
                }
                else if let lcsHead = lcs.first {
                    result.append(.notChanged(lcsHead))
                    lcs.remove(at: 0)
                    continue
                }
            }
            else if let lcsHead = lcs.first {
                result.append(.notChanged(lcsHead))
                lcs.remove(at: 0)
                continue
            }
        }

        return result
    }


    private static func createIndexTable(_ steps: [DiffStep<Diffable>]) -> [Int: Diffable] {
        var table = [Int: Diffable]()

        steps.forEach { step in
            table[step.idx] = step.value
        }

        return table
    }
}

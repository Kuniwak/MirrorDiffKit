import Foundation



class DiffableSequence {
    let elements: [Diffable]


    init(_ elements: [Diffable]) {
        self.elements = elements
    }


    static func diff(from: DiffableSequence, to: DiffableSequence) -> Diff {
        if from.elements.count >= to.elements.count {
            let greater = from
            let less = to
        }
        else {
            let greater = to
            let less = from
        }
    }


    typealias Diff = [Label]


    enum Label {
        case notChanged(Diffable)
        case inserted(Diffable)
        case deleted(Diffable)
    }


    class State {
        var greater: Int
        var less: Int
        var greaterSequence: [Diffable]
        var lessSequence: [Diffable]


        init(greater: Int, less: Int) {
            self.greater = greater
            self.less = less
        }


        func getEditDistance() {
            let offset = self.less + 1
            let delta = self.greater - self.less

            var table = [Int: Int]()
            var p = -1

            repeat {
                p += 1

                for k in -p ..< delta {
                    table[k + offset] = self.snake(
                        k: k,
                        max(
                            table[k - 1 + offset]! + 1,
                            table[k + 1 + offset]!
                        )
                    )
                }

                for k in (delta + 1 ... delta + p).revrese()  {
                    table[k + offset] = self.snake(
                        k: k,
                        max(
                            table[k - 1 + offset]! + 1,
                            table[k + 1 + offset]!
                        )
                    )
                }

                table[delta + offset] = snake(
                    k: delta,
                    max(
                        table[delta - 1 + offset]! + 1,
                        table[delta + 1 + offset]!
                    )
                )

                return delta + 2 * p
            }
            while table[delta + offset] != self.greater
        }


        private func snake(k: Int, _ z: Int) -> Int {
            var y = z
            var x = y - k

            while x < self.less
                && y < self.greater
                && self.greaterSequence[x] == self.lessSequence[y] {
                x += 1
                y += 1
            }

            return y
        }
    }
}


extension DiffableSequence.Label: Equatable {
    static func == (_ lhs: DiffableSequence.Label, _ rhs: DiffableSequence.Label) -> Bool {
        switch (lhs, rhs) {
        case let (.notChanged(l), .notChanged(r)):
            return l == r
        case let (.inserted(l), .inserted(r)):
            return l == r
        case let (.deleted(l), .deleted(r)):
            return l == r
        default:
            return false
        }
    }
}

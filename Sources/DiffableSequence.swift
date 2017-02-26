import Foundation
import Dwifft



class DiffableSequence {
    let elements: [Diffable]


    init(_ elements: [Diffable]) {
        self.elements = elements
    }


    static func diff(from: DiffableSequence, to: DiffableSequence) -> [DiffStep] {
        let results = from.elements.diff(to.elements).results

        // NOTE: Transform to self-defined type to make compatibility stable.
        return results.map { result -> DiffStep in
            switch result {
            case let .insert(index, inserted):
                return .inserted(inserted, atIndex: index)
            case let .delete(index, deleted):
                return .deleted(deleted, atIndex: index)
            }
        }
    }


    enum DiffStep {
        case inserted(Diffable, atIndex: Int)
        case deleted(Diffable, atIndex: Int)
    }
}



extension DiffableSequence.DiffStep: Equatable {
    static func == (_ lhs: DiffableSequence.DiffStep, _ rhs: DiffableSequence.DiffStep) -> Bool {
        switch (lhs, rhs) {
        case let (.inserted(l), .inserted(r)):
            return l == r
        case let (.deleted(l), .deleted(r)):
            return l == r
        default:
            return false
        }
    }
}

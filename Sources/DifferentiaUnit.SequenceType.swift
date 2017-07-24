import Foundation



extension DifferentiaUnit {
    enum SequenceType {
        case array
        case set
    }
}



extension DifferentiaUnit.SequenceType: Equatable {
    static func ==(lhs: DifferentiaUnit.SequenceType, rhs: DifferentiaUnit.SequenceType) -> Bool {
        switch (lhs, rhs) {
        case (.array, .array):
            return true
        case (.set, .set):
            return true
        default:
            return false
        }
    }
}
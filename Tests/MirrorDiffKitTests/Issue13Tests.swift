import XCTest
@testable import MirrorDiffKit


class Issue13Tests: XCTestCase {
    func testDictEquality() {
        let a = [
            "key1": "value1",
            "key2": "value2",
        ]
        let b = [
            "key2": "value2",
            "key1": "value1",
        ]

        XCTAssert(
            Diffable.from(any: a) =~ Diffable.from(any: b),
            diff(between: b, and: a)
        )
    }


    static var allTests: [(String, (Issue13Tests) -> () throws -> Void)] {
        return [
            ("testDictEquality", self.testDictEquality),
        ]
    }
}

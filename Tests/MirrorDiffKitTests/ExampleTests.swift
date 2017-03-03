import XCTest
import MirrorDiffKit


class ExampleTests: XCTestCase {
    func testExample1() {
        let a = Example(
            key1: "I'm not changed",
            key2: "I'm deleted"
        )
        let b = Example(
            key1: "I'm not changed",
            key2: "I'm inserted"
        )

        // NOTE: This is only for the example on README.md
        // XCTAssertEqual(a, b, diff(between: a, and: b))
    }


    func testExample2() {
        let a = NotEquatable(
            key1: "I'm not changed",
            key2: "I'm deleted"
        )
        let b = NotEquatable(
            key1: "I'm not changed",
            key2: "I'm inserted"
        )

        // NOTE: This is only for the example on README.md
        // XCTAssert(
        //     Diffable.from(any: a) =~ Diffable.from(any: b),
        //     diff(between: a, and: b)
        // )
    }


    static var allTests : [(String, (ExampleTests) -> () throws -> Void)] {
        return [
            ("testExample1", self.testExample1),
            ("testExample2", self.testExample2),
        ]
    }


    struct Example: Equatable {
        let key1: String
        let key2: String


        static func == (_ lhs: Example, _ rhs: Example) -> Bool {
            return lhs.key1 == rhs.key1
                && lhs.key2 == rhs.key2
        }
    }


    struct NotEquatable {
        let key1: String
        let key2: String
    }
}

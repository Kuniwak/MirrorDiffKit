import XCTest
import CoreGraphics
@testable import MirrorDiffKit


class Issue30Tests: XCTestCase {
    private struct Parent {
        let child: Child?
    }

    private struct Child {}


    func testCGFloat() {
        let a = CGFloat(0.0)
        let b = CGFloat(1.0)

        let expected = [
            "",
            "- CGFloat(0.0)",
            "+ CGFloat(1.0)",
            "",
        ].joined(separator: "\n")

        XCTAssertEqual(diff(between: a, and: b), expected)
    }


    func testCharacter() {
        let a = "a".first!
        let b = "b".first!

        let expected = [
            "",
            "- (unknown) Character: CustomReflectable { description: \"a\" }",
            "+ (unknown) Character: CustomReflectable { description: \"b\" }",
            "",
        ].joined(separator: "\n")

        XCTAssertEqual(diff(between: a, and: b), expected)
    }


    static var allTests: [(String, (Issue30Tests) -> () throws -> Void)] {
        return [
            ("testCGFloat", self.testCGFloat),
        ]
    }
}

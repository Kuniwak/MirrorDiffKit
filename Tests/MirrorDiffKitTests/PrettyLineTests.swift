import XCTest
@testable import MirrorDiffKit


class PrettyLineTests: XCTestCase {
    private struct TestCase {
        let a: PrettyLine
        let b: PrettyLine
        let separator: String
        let expected: PrettyLine
    }


    func testConcatTwoLines() {
        let testCases: [UInt: TestCase] = [
            #line: TestCase(
                a: .line("line1"),
                b: .line("line2"),
                separator: "|",
                expected: .line("line1|line2")
            ),
            #line: TestCase(
                a: .indent(.line("line1")),
                b: .line("line2"),
                separator: "|",
                expected: .indent(.line("line1|line2"))
            ),
            #line: TestCase(
                a: .line("line1"),
                b: .indent(.line("line2")),
                separator: "|",
                expected: .line("line1|line2")
            ),
            #line: TestCase(
                a: .indent(.line("line1")),
                b: .indent(.line("line2")),
                separator: "|",
                expected: .indent(.line("line1|line2"))
            ),
            #line: TestCase(
                a: .indent(.indent(.line("line1"))),
                b: .line("line2"),
                separator: "|",
                expected: .indent(.indent(.line("line1|line2")))
            ),
            #line: TestCase(
                a: .line("line1"),
                b: .indent(.indent(.line("line2"))),
                separator: "|",
                expected: .line("line1|line2")
            ),
        ]


        testCases.forEach { entry in
            let (line, testCase) = entry
            XCTAssertEqual(
                PrettyLine.concatKeyLineAndValueLines(
                    testCase.a,
                    and: testCase.b,
                    with: testCase.separator
                ),
                testCase.expected,
                line: line
            )
        }
    }


    static var allTests: [(String, (PrettyLineTests) -> () throws -> Void)] {
        return [
            ("testConcatTwoLines", self.testConcatTwoLines),
        ]
    }
}

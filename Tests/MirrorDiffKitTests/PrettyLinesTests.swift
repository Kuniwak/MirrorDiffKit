import XCTest
@testable import MirrorDiffKit


class PrettyLinesTests: XCTestCase {
    private struct TestCase {
        let a: [PrettyLine]
        let b: [PrettyLine]
        let separator: String
        let expected: [PrettyLine]
    }


    func testConcatTwoLineLists() {
        let testCases: [UInt: TestCase] = [
            #line: TestCase(
                a: [],
                b: [],
                separator: "|",
                expected: []
            ),
            #line: TestCase(
                a: [.line("line1")],
                b: [],
                separator: "|",
                expected: [.line("line1")]
            ),
            #line: TestCase(
                a: [],
                b: [.line("line2")],
                separator: "|",
                expected: [.line("line2")]
            ),
            #line: TestCase(
                a: [.line("line1")],
                b: [.line("line2")],
                separator: "|",
                expected: [.line("line1|line2")]
            ),
            #line: TestCase(
                a: [.indent(.line("line1"))],
                b: [.line("line2")],
                separator: "|",
                expected: [.indent(.line("line1|line2"))]
            ),
            #line: TestCase(
                a: [
                    .line("line1"),
                    .line("line2"),
                ],
                b: [
                    .line("line3"),
                    .line("line4"),
                ],
                separator: "|",
                expected: [
                    .line("line1"),
                    .line("line2|line3"),
                    .line("line4"),
                ]
            ),
            #line: TestCase(
                a: [
                    .line("{"),
                    .indent(.line("key:")),
                ],
                b: [
                    .line("["),
                    .indent(.line("0,")),
                    .indent(.line("1,")),
                    .indent(.line("2,")),
                    .line("]"),
                ],
                separator: " ",
                expected: [
                    .line("{"),
                    .indent(.line("key: [")),
                    .indent(.indent(.line("0,"))),
                    .indent(.indent(.line("1,"))),
                    .indent(.indent(.line("2,"))),
                    .indent(.line("]")),
                ]
            ),
        ]


        testCases.forEach { entry in
            let (line, testCase) = entry

            let actual = PrettyLine.concat(
                testCase.a,
                and: testCase.b,
                with: testCase.separator
            )
            let expected = testCase.expected

            XCTAssertEqual(
                actual, expected,
                diff(between: expected, and: actual),
                line: line
            )
        }
    }


    static var allTests: [(String, (PrettyLinesTests) -> () throws -> Void)] {
        return [
            ("testConcatTwoLineLists", self.testConcatTwoLineLists),
        ]
    }
}


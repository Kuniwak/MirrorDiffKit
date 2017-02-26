import XCTest
@testable import TestDiffKit


class DiffableSequenceTests: XCTestCase {
    private struct TestCase {
        let from: DiffableSequence
        let to: DiffableSequence
        let expected: [DiffableSequence.DiffStep]
    }


    func testDiff() {
        let testCases: [UInt: TestCase] = [
            #line: TestCase(
                from: DiffableSequence([]),
                to: DiffableSequence([]),
                expected: []
            ),
            #line: TestCase(
                from: DiffableSequence([
                    .string("I'm not changed"),
                ]),
                to: DiffableSequence([
                    .string("I'm not changed"),
                ]),
                expected: []
            ),
            #line: TestCase(
                from: DiffableSequence([]),
                to: DiffableSequence([
                    .string("I'm inserted"),
                ]),
                expected: [
                    .inserted(.string("I'm inserted"), atIndex: 0),
                ]
            ),
            #line: TestCase(
                from: DiffableSequence([
                    .string("I'm deleted"),
                ]),
                to: DiffableSequence([]),
                expected: [
                    .deleted(.string("I'm deleted"), atIndex: 0),
                ]
            ),
            #line: TestCase(
                from: DiffableSequence([
                    .string("I'm not changed"),
                    .string("I'm deleted"),
                ]),
                to: DiffableSequence([
                    .string("I'm not changed"),
                    .string("I'm inserted"),
                ]),
                expected: [
                    .deleted(.string("I'm deleted"), atIndex: 1),
                    .inserted(.string("I'm inserted"), atIndex: 1),
                ]
            ),
            #line: TestCase(
                from: DiffableSequence([
                    .string("I'm not changed"),
                    .string("I'm deleted"),
                ]),
                to: DiffableSequence([
                    .string("I'm inserted"),
                    .string("I'm not changed"),
                ]),
                expected: [
                    .inserted(.string("I'm inserted"), atIndex: 0),
                    .deleted(.string("I'm deleted"), atIndex: 1),
                ]
            )
        ]


        testCases.forEach { (line, testCase) in
            let diff = DiffableSequence.diff(
                from: testCase.from,
                to: testCase.to
            )

            XCTAssertEqual(diff, testCase.expected, line: #line)
        }
    }


    static var allTests : [(String, (TestDiffKitTests) -> () throws -> Void)] {
        return [
            // ("testExample", testExample),
        ]
    }
}
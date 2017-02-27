import XCTest
@testable import TestDiffKit


class DiffableSequenceTests: XCTestCase {
    private struct TestCase {
        let from: DiffableSequence
        let to: DiffableSequence
        let expected: [DiffableSequence.LineState]
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
                expected: [
                    .notChanged(.string("I'm not changed")),
                ]
            ),
            #line: TestCase(
                from: DiffableSequence([]),
                to: DiffableSequence([
                    .string("I'm inserted"),
                ]),
                expected: [
                    .inserted(.string("I'm inserted")),
                ]
            ),
            #line: TestCase(
                from: DiffableSequence([
                    .string("I'm deleted"),
                ]),
                to: DiffableSequence([]),
                expected: [
                    .deleted(.string("I'm deleted")),
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
                    .notChanged(.string("I'm not changed")),
                    .deleted(.string("I'm deleted")),
                    .inserted(.string("I'm inserted")),
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
                    .inserted(.string("I'm inserted")),
                    .notChanged(.string("I'm not changed")),
                    .deleted(.string("I'm deleted")),
                ]
            ),
            #line: TestCase(
                from: DiffableSequence([
                    .string("I'm deleted"),
                    .string("I'm not changed"),
                ]),
                to: DiffableSequence([
                    .string("I'm inserted"),
                    .string("I'm not changed"),
                ]),
                expected: [
                    .deleted(.string("I'm deleted")),
                    .inserted(.string("I'm inserted")),
                    .notChanged(.string("I'm not changed")),
                ]
            ),
            #line: TestCase(
                from: DiffableSequence([
                    .string("I'm deleted"),
                    .string("I'm not changed"),
                ]),
                to: DiffableSequence([
                    .string("I'm not changed"),
                    .string("I'm inserted"),
                ]),
                expected: [
                    .deleted(.string("I'm deleted")),
                    .notChanged(.string("I'm not changed")),
                    .inserted(.string("I'm inserted")),
                ]
            ),
            #line: TestCase(
                from: DiffableSequence([
                    .string("I'm not changed 1"),
                    .string("I'm not changed 2"),
                    .string("I'm not changed 3"),
                    .string("I'm not changed 4"),
                ]),
                to: DiffableSequence([
                    .string("I'm not changed 1"),
                    .string("I'm not changed 2"),
                    .string("I'm not changed 3"),
                    .string("I'm not changed 4"),
                ]),
                expected: [
                    .notChanged(.string("I'm not changed 1")),
                    .notChanged(.string("I'm not changed 2")),
                    .notChanged(.string("I'm not changed 3")),
                    .notChanged(.string("I'm not changed 4")),
                ]
            ),
            #line: TestCase(
                from: DiffableSequence([
                    .string("I'm deleted 1"),
                    .string("I'm deleted 2"),
                    .string("I'm deleted 3"),
                    .string("I'm deleted 4"),
                    .string("I'm not changed"),
                ]),
                to: DiffableSequence([
                    .string("I'm not changed"),
                ]),
                expected: [
                    .deleted(.string("I'm deleted 1")),
                    .deleted(.string("I'm deleted 2")),
                    .deleted(.string("I'm deleted 3")),
                    .deleted(.string("I'm deleted 4")),
                    .notChanged(.string("I'm not changed")),
                ]
            ),
            #line: TestCase(
                from: DiffableSequence([
                    .string("I'm not changed"),
                ]),
                to: DiffableSequence([
                    .string("I'm inserted 1"),
                    .string("I'm inserted 2"),
                    .string("I'm inserted 3"),
                    .string("I'm inserted 4"),
                    .string("I'm not changed"),
                ]),
                expected: [
                    .inserted(.string("I'm inserted 1")),
                    .inserted(.string("I'm inserted 2")),
                    .inserted(.string("I'm inserted 3")),
                    .inserted(.string("I'm inserted 4")),
                    .notChanged(.string("I'm not changed")),
                ]
            ),
        ]


        testCases.forEach { (line, testCase) in
            let diff = DiffableSequence.diff(
                from: testCase.from,
                to: testCase.to
            )

            XCTAssertEqual(diff, testCase.expected, line: line)
        }
    }


    static var allTests : [(String, (TestDiffKitTests) -> () throws -> Void)] {
        return [
            // ("testExample", testExample),
        ]
    }
}
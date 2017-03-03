import XCTest
@testable import MirrorDiffKit


class DiffableSequenceTests: XCTestCase {
    private struct TestCase {
        let between: DiffableSequence
        let and: DiffableSequence
        let expected: Diffable.Diff
    }


    func testDiff() {
        let testCases: [UInt: TestCase] = [
            #line: TestCase(
                between: DiffableSequence([]),
                and: DiffableSequence([]),
                expected: Diffable.Diff(units: [])
            ),
            #line: TestCase(
                between: DiffableSequence([
                    .string("I'm not changed"),
                ]),
                and: DiffableSequence([
                    .string("I'm not changed"),
                ]),
                expected: Diffable.Diff(units: [
                    .notChanged(.string("I'm not changed")),
                ])
            ),
            #line: TestCase(
                between: DiffableSequence([]),
                and: DiffableSequence([
                    .string("I'm inserted"),
                ]),
                expected: Diffable.Diff(units: [
                    .inserted(.string("I'm inserted")),
                ])
            ),
            #line: TestCase(
                between: DiffableSequence([
                    .string("I'm deleted"),
                ]),
                and: DiffableSequence([]),
                expected: Diffable.Diff(units: [
                    .deleted(.string("I'm deleted")),
                ])
            ),
            #line: TestCase(
                between: DiffableSequence([
                    .string("I'm not changed"),
                    .string("I'm deleted"),
                ]),
                and: DiffableSequence([
                    .string("I'm not changed"),
                    .string("I'm inserted"),
                ]),
                expected: Diffable.Diff(units: [
                    .notChanged(.string("I'm not changed")),
                    .deleted(.string("I'm deleted")),
                    .inserted(.string("I'm inserted")),
                ])
            ),
            #line: TestCase(
                between: DiffableSequence([
                    .string("I'm not changed"),
                    .string("I'm deleted"),
                ]),
                and: DiffableSequence([
                    .string("I'm inserted"),
                    .string("I'm not changed"),
                ]),
                expected: Diffable.Diff(units: [
                    .inserted(.string("I'm inserted")),
                    .notChanged(.string("I'm not changed")),
                    .deleted(.string("I'm deleted")),
                ])
            ),
            #line: TestCase(
                between: DiffableSequence([
                    .string("I'm deleted"),
                    .string("I'm not changed"),
                ]),
                and: DiffableSequence([
                    .string("I'm inserted"),
                    .string("I'm not changed"),
                ]),
                expected: Diffable.Diff(units: [
                    .deleted(.string("I'm deleted")),
                    .inserted(.string("I'm inserted")),
                    .notChanged(.string("I'm not changed")),
                ])
            ),
            #line: TestCase(
                between: DiffableSequence([
                    .string("I'm deleted"),
                    .string("I'm not changed"),
                ]),
                and: DiffableSequence([
                    .string("I'm not changed"),
                    .string("I'm inserted"),
                ]),
                expected: Diffable.Diff(units: [
                    .deleted(.string("I'm deleted")),
                    .notChanged(.string("I'm not changed")),
                    .inserted(.string("I'm inserted")),
                ])
            ),
            #line: TestCase(
                between: DiffableSequence([
                    .string("I'm not changed 1"),
                    .string("I'm not changed 2"),
                    .string("I'm not changed 3"),
                    .string("I'm not changed 4"),
                ]),
                and: DiffableSequence([
                    .string("I'm not changed 1"),
                    .string("I'm not changed 2"),
                    .string("I'm not changed 3"),
                    .string("I'm not changed 4"),
                ]),
                expected: Diffable.Diff(units: [
                    .notChanged(.string("I'm not changed 1")),
                    .notChanged(.string("I'm not changed 2")),
                    .notChanged(.string("I'm not changed 3")),
                    .notChanged(.string("I'm not changed 4")),
                ])
            ),
            #line: TestCase(
                between: DiffableSequence([
                    .string("I'm deleted 1"),
                    .string("I'm deleted 2"),
                    .string("I'm deleted 3"),
                    .string("I'm deleted 4"),
                    .string("I'm not changed"),
                ]),
                and: DiffableSequence([
                    .string("I'm not changed"),
                ]),
                expected: Diffable.Diff(units: [
                    .deleted(.string("I'm deleted 1")),
                    .deleted(.string("I'm deleted 2")),
                    .deleted(.string("I'm deleted 3")),
                    .deleted(.string("I'm deleted 4")),
                    .notChanged(.string("I'm not changed")),
                ])
            ),
            #line: TestCase(
                between: DiffableSequence([
                    .string("I'm not changed"),
                ]),
                and: DiffableSequence([
                    .string("I'm inserted 1"),
                    .string("I'm inserted 2"),
                    .string("I'm inserted 3"),
                    .string("I'm inserted 4"),
                    .string("I'm not changed"),
                ]),
                expected: Diffable.Diff(units: [
                    .inserted(.string("I'm inserted 1")),
                    .inserted(.string("I'm inserted 2")),
                    .inserted(.string("I'm inserted 3")),
                    .inserted(.string("I'm inserted 4")),
                    .notChanged(.string("I'm not changed")),
                ])
            ),
        ]


        testCases.forEach { (line, testCase) in
            let diff = DiffableSequence.diff(
                between: testCase.between,
                and: testCase.and
            )

            XCTAssertEqual(diff, testCase.expected, line: line)
        }
    }


    static var allTests : [(String, (DiffableSequenceTests) -> () throws -> Void)] {
        return [
             ("testDiff", self.testDiff),
        ]
    }
}
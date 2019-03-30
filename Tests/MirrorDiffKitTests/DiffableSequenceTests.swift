import XCTest
@testable import MirrorDiffKit


class DiffableSequenceTests: XCTestCase {
    private struct TestCase {
        let between: DiffableSequence
        let and: DiffableSequence
        let expected: [DifferentiaUnit]
    }


    func testDiff() {
        let testCases: [UInt: TestCase] = [
            #line: TestCase(
                between: DiffableSequence(type: .type(Array<Int>.self), elements: []),
                and: DiffableSequence(type: .type(Array<Int>.self), elements: []),
                expected: []
            ),
            #line: TestCase(
                between: DiffableSequence(type: .type(Array<Int>.self), elements: []),
                and: DiffableSequence(type: .type(Array<Double>.self), elements: []),
                expected: [
                    .deleted(.collection(type: .type(Array<Int>.self), elements: [])),
                    .inserted(.collection(type: .type(Array<Double>.self), elements: [])),
                ]
            ),
            #line: TestCase(
                between: DiffableSequence(type: .type(Array<String>.self), elements: [
                    .string(type: .type(String.self), content: "I'm not changed"),
                ]),
                and: DiffableSequence(type: .type(Array<String>.self), elements: [
                    .string(type: .type(String.self), content: "I'm not changed"),
                ]),
                expected: [
                    .notChanged(.string(type: .type(String.self), content: "I'm not changed")),
                ]
            ),
            #line: TestCase(
                between: DiffableSequence(type: .type(Array<String>.self), elements: []),
                and: DiffableSequence(type: .type(Array<String>.self), elements: [
                    .string(type: .type(String.self), content: "I'm inserted"),
                ]),
                expected: [
                    .inserted(.string(type: .type(String.self), content: "I'm inserted")),
                ]
            ),
            #line: TestCase(
                between: DiffableSequence(type: .type(Array<String>.self), elements: [
                    .string(type: .type(String.self), content: "I'm deleted"),
                ]),
                and: DiffableSequence(type: .type(Array<String>.self), elements: []),
                expected: [
                    .deleted(.string(type: .type(String.self), content: "I'm deleted")),
                ]
            ),
            #line: TestCase(
                between: DiffableSequence(type: .type(Array<String>.self), elements: [
                    .string(type: .type(String.self), content: "I'm not changed"),
                    .string(type: .type(String.self), content: "I'm deleted"),
                ]),
                and: DiffableSequence(type: .type(Array<String>.self), elements: [
                    .string(type: .type(String.self), content: "I'm not changed"),
                    .string(type: .type(String.self), content: "I'm inserted"),
                ]),
                expected: [
                    .notChanged(.string(type: .type(String.self), content: "I'm not changed")),
                    .deleted(.string(type: .type(String.self), content: "I'm deleted")),
                    .inserted(.string(type: .type(String.self), content: "I'm inserted")),
                ]
            ),
            #line: TestCase(
                between: DiffableSequence(type: .type(Array<String>.self), elements: [
                    .string(type: .type(String.self), content: "I'm not changed"),
                    .string(type: .type(String.self), content: "I'm deleted"),
                ]),
                and: DiffableSequence(type: .type(Array<String>.self), elements: [
                    .string(type: .type(String.self), content: "I'm inserted"),
                    .string(type: .type(String.self), content: "I'm not changed"),
                ]),
                expected: [
                    .inserted(.string(type: .type(String.self), content: "I'm inserted")),
                    .notChanged(.string(type: .type(String.self), content: "I'm not changed")),
                    .deleted(.string(type: .type(String.self), content: "I'm deleted")),
                ]
            ),
            #line: TestCase(
                between: DiffableSequence(type: .type(Array<String>.self), elements: [
                    .string(type: .type(String.self), content: "I'm deleted"),
                    .string(type: .type(String.self), content: "I'm not changed"),
                ]),
                and: DiffableSequence(type: .type(Array<String>.self), elements: [
                    .string(type: .type(String.self), content: "I'm inserted"),
                    .string(type: .type(String.self), content: "I'm not changed"),
                ]),
                expected: [
                    .deleted(.string(type: .type(String.self), content: "I'm deleted")),
                    .inserted(.string(type: .type(String.self), content: "I'm inserted")),
                    .notChanged(.string(type: .type(String.self), content: "I'm not changed")),
                ]
            ),
            #line: TestCase(
                between: DiffableSequence(type: .type(Array<String>.self), elements: [
                    .string(type: .type(String.self), content: "I'm deleted"),
                    .string(type: .type(String.self), content: "I'm not changed"),
                ]),
                and: DiffableSequence(type: .type(Array<String>.self), elements: [
                    .string(type: .type(String.self), content: "I'm not changed"),
                    .string(type: .type(String.self), content: "I'm inserted"),
                ]),
                expected: [
                    .deleted(.string(type: .type(String.self), content: "I'm deleted")),
                    .notChanged(.string(type: .type(String.self), content: "I'm not changed")),
                    .inserted(.string(type: .type(String.self), content: "I'm inserted")),
                ]
            ),
            #line: TestCase(
                between: DiffableSequence(type: .type(Array<String>.self), elements: [
                    .string(type: .type(String.self), content: "I'm not changed 1"),
                    .string(type: .type(String.self), content: "I'm not changed 2"),
                    .string(type: .type(String.self), content: "I'm not changed 3"),
                    .string(type: .type(String.self), content: "I'm not changed 4"),
                ]),
                and: DiffableSequence(type: .type(Array<String>.self), elements: [
                    .string(type: .type(String.self), content: "I'm not changed 1"),
                    .string(type: .type(String.self), content: "I'm not changed 2"),
                    .string(type: .type(String.self), content: "I'm not changed 3"),
                    .string(type: .type(String.self), content: "I'm not changed 4"),
                ]),
                expected: [
                    .notChanged(.string(type: .type(String.self), content: "I'm not changed 1")),
                    .notChanged(.string(type: .type(String.self), content: "I'm not changed 2")),
                    .notChanged(.string(type: .type(String.self), content: "I'm not changed 3")),
                    .notChanged(.string(type: .type(String.self), content: "I'm not changed 4")),
                ]
            ),
            #line: TestCase(
                between: DiffableSequence(type: .type(Array<String>.self), elements: [
                    .string(type: .type(String.self), content: "I'm deleted 1"),
                    .string(type: .type(String.self), content: "I'm deleted 2"),
                    .string(type: .type(String.self), content: "I'm deleted 3"),
                    .string(type: .type(String.self), content: "I'm deleted 4"),
                    .string(type: .type(String.self), content: "I'm not changed"),
                ]),
                and: DiffableSequence(type: .type(Array<String>.self), elements: [
                    .string(type: .type(String.self), content: "I'm not changed"),
                ]),
                expected: [
                    .deleted(.string(type: .type(String.self), content: "I'm deleted 1")),
                    .deleted(.string(type: .type(String.self), content: "I'm deleted 2")),
                    .deleted(.string(type: .type(String.self), content: "I'm deleted 3")),
                    .deleted(.string(type: .type(String.self), content: "I'm deleted 4")),
                    .notChanged(.string(type: .type(String.self), content: "I'm not changed")),
                ]
            ),
            #line: TestCase(
                between: DiffableSequence(type: .type(Array<String>.self), elements: [
                    .string(type: .type(String.self), content: "I'm not changed"),
                ]),
                and: DiffableSequence(type: .type(Array<String>.self), elements: [
                    .string(type: .type(String.self), content: "I'm inserted 1"),
                    .string(type: .type(String.self), content: "I'm inserted 2"),
                    .string(type: .type(String.self), content: "I'm inserted 3"),
                    .string(type: .type(String.self), content: "I'm inserted 4"),
                    .string(type: .type(String.self), content: "I'm not changed"),
                ]),
                expected: [
                    .inserted(.string(type: .type(String.self), content: "I'm inserted 1")),
                    .inserted(.string(type: .type(String.self), content: "I'm inserted 2")),
                    .inserted(.string(type: .type(String.self), content: "I'm inserted 3")),
                    .inserted(.string(type: .type(String.self), content: "I'm inserted 4")),
                    .notChanged(.string(type: .type(String.self), content: "I'm not changed")),
                ]
            ),
        ]


        testCases.forEach { entry in
            let (line, testCase) = entry
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
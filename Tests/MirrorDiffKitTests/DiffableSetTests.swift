import XCTest
import Foundation
@testable import MirrorDiffKit



class DiffableSetTests: XCTestCase {
    private struct TestCase {
        let from: DiffableSet
        let to: DiffableSet
        let expected: [DifferentiaUnit]
    }


    func testDiff() {
        let testCases: [UInt: TestCase] = [
            #line: TestCase(
                from: DiffableSet(type: Set<String>.self, elements: []),
                to: DiffableSet(type: Set<String>.self, elements: []),
                expected: []
            ),
            #line: TestCase(
                from: DiffableSet(type: Set<String>.self, elements: [
                    .string(type: String.self, content: "I'm not changed"),
                ]),
                to: DiffableSet(type: Set<String>.self, elements: [
                    .string(type: String.self, content: "I'm not changed"),
                ]),
                expected: [
                    .notChanged(.string(type: String.self, content: "I'm not changed")),
                ]
            ),
            #line: TestCase(
                from: DiffableSet(type: Set<String>.self, elements: [
                    .string(type: String.self, content: "I'm deleted"),
                ]),
                to: DiffableSet(type: Set<String>.self, elements: []),
                expected: [
                    .deleted(.string(type: String.self, content: "I'm deleted")),
                ]
            ),
            #line: TestCase(
                from: DiffableSet(type: Set<String>.self, elements: []),
                to: DiffableSet(type: Set<String>.self, elements: [
                    .string(type: String.self, content: "I'm inserted"),
                ]),
                expected: [
                    .inserted(.string(type: String.self, content: "I'm inserted")),
                ]
            ),
            #line: TestCase(
                from: DiffableSet(type: Set<String>.self, elements: [
                    .string(type: String.self, content: "I'm not changed"),
                    .string(type: String.self, content: "I'm deleted")
                ]),
                to: DiffableSet(type: Set<String>.self, elements: [
                    .string(type: String.self, content: "I'm not changed"),
                    .string(type: String.self, content: "I'm inserted")
                ]),
                expected: [
                    .deleted(.string(type: String.self, content: "I'm deleted")),
                    .inserted(.string(type: String.self, content: "I'm inserted")),
                    .notChanged(.string(type: String.self, content: "I'm not changed")),
                ]
            ),
            #line: TestCase(
                from: DiffableSet(type: Set<String>.self, elements: [
                    // NOTE: Elements are possible to duplicate.
                    .string(type: String.self, content: "I'm deleted"),
                    .string(type: String.self, content: "I'm deleted"),
                ]),
                to: DiffableSet(type: Set<String>.self, elements: [
                    .string(type: String.self, content: "I'm deleted"),
                ]),
                expected: [
                    .deleted(.string(type: String.self, content: "I'm deleted")),
                    .notChanged(.string(type: String.self, content: "I'm deleted")),
                ]
            ),
            #line: TestCase(
                from: DiffableSet(type: Set<String>.self, elements: [
                    .string(type: String.self, content: "I'm inserted"),
                ]),
                to: DiffableSet(type: Set<String>.self, elements: [
                    // NOTE: Elements are possible to duplicate.
                    .string(type: String.self, content: "I'm inserted"),
                    .string(type: String.self, content: "I'm inserted"),
                ]),
                expected: [
                    .inserted(.string(type: String.self, content: "I'm inserted")),
                    .notChanged(.string(type: String.self, content: "I'm inserted")),
                ]
            ),
        ]


        testCases.forEach { entry in
            let (line, testCase) = entry
            XCTAssertEqual(
                DiffableSet.diff(between: testCase.from, and: testCase.to),
                testCase.expected,
                line: line
            )
        }
    }


    static var allTests : [(String, (DiffableSetTests) -> () throws -> Void)] {
        return [
            ("testDiff", self.testDiff),
        ]
    }
}

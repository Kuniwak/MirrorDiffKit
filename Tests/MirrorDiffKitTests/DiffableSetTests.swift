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
                from: DiffableSet(type: .type(Set<String>.self), elements: []),
                to: DiffableSet(type: .type(Set<String>.self), elements: []),
                expected: []
            ),
            #line: TestCase(
                from: DiffableSet(type: .type(Set<String>.self), elements: [
                    .string(type: .type(String.self), content: "I'm not changed"),
                ]),
                to: DiffableSet(type: .type(Set<String>.self), elements: [
                    .string(type: .type(String.self), content: "I'm not changed"),
                ]),
                expected: [
                    .notChanged(.string(type: .type(String.self), content: "I'm not changed")),
                ]
            ),
            #line: TestCase(
                from: DiffableSet(type: .type(Set<String>.self), elements: [
                    .string(type: .type(String.self), content: "I'm deleted"),
                ]),
                to: DiffableSet(type: .type(Set<String>.self), elements: []),
                expected: [
                    .deleted(.string(type: .type(String.self), content: "I'm deleted")),
                ]
            ),
            #line: TestCase(
                from: DiffableSet(type: .type(Set<String>.self), elements: []),
                to: DiffableSet(type: .type(Set<String>.self), elements: [
                    .string(type: .type(String.self), content: "I'm inserted"),
                ]),
                expected: [
                    .inserted(.string(type: .type(String.self), content: "I'm inserted")),
                ]
            ),
            #line: TestCase(
                from: DiffableSet(type: .type(Set<String>.self), elements: [
                    .string(type: .type(String.self), content: "I'm not changed"),
                    .string(type: .type(String.self), content: "I'm deleted")
                ]),
                to: DiffableSet(type: .type(Set<String>.self), elements: [
                    .string(type: .type(String.self), content: "I'm not changed"),
                    .string(type: .type(String.self), content: "I'm inserted")
                ]),
                expected: [
                    .deleted(.string(type: .type(String.self), content: "I'm deleted")),
                    .inserted(.string(type: .type(String.self), content: "I'm inserted")),
                    .notChanged(.string(type: .type(String.self), content: "I'm not changed")),
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

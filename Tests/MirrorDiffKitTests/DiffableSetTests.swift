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
                from: DiffableSet([]),
                to: DiffableSet([]),
                expected: []
            ),
            #line: TestCase(
                from: DiffableSet([
                    .string("I'm not changed"),
                ]),
                to: DiffableSet([
                    .string("I'm not changed"),
                ]),
                expected: [
                    .notChanged(.string("I'm not changed")),
                ]
            ),
            #line: TestCase(
                from: DiffableSet([
                    .string("I'm deleted"),
                ]),
                to: DiffableSet([]),
                expected: [
                    .deleted(.string("I'm deleted")),
                ]
            ),
            #line: TestCase(
                from: DiffableSet([]),
                to: DiffableSet([
                    .string("I'm inserted"),
                ]),
                expected: [
                    .inserted(.string("I'm inserted")),
                ]
            ),
            #line: TestCase(
                from: DiffableSet([
                    .string("I'm not changed"),
                    .string("I'm deleted")
                ]),
                to: DiffableSet([
                    .string("I'm not changed"),
                    .string("I'm inserted")
                ]),
                expected: [
                    .deleted(.string("I'm deleted")),
                    .inserted(.string("I'm inserted")),
                    .notChanged(.string("I'm not changed")),
                ]
            ),
            #line: TestCase(
                from: DiffableSet([
                    // NOTE: Elements are possible to duplicate.
                    .string("I'm deleted"),
                    .string("I'm deleted"),
                ]),
                to: DiffableSet([
                    .string("I'm deleted"),
                ]),
                expected: [
                    .deleted(.string("I'm deleted")),
                    .notChanged(.string("I'm deleted")),
                ]
            ),
            #line: TestCase(
                from: DiffableSet([
                    .string("I'm inserted"),
                ]),
                to: DiffableSet([
                    // NOTE: Elements are possible to duplicate.
                    .string("I'm inserted"),
                    .string("I'm inserted"),
                ]),
                expected: [
                    .inserted(.string("I'm inserted")),
                    .notChanged(.string("I'm inserted")),
                ]
            ),
        ]


        testCases.forEach { (line, testCase) in
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

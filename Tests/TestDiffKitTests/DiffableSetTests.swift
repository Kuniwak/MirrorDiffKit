import XCTest
import Foundation
@testable import TestDiffKit



class DiffableSetTests: XCTestCase {
    private struct TestCase {
        let from: DiffableSet
        let to: DiffableSet
        let expected: DiffableSet.Diff
    }
    
    
    func testDiff() {
        let testCases: [UInt: TestCase] = [
            #line: TestCase(
                from: DiffableSet([]),
                to: DiffableSet([]),
                expected: DiffableSet.Diff(
                    notChanged: DiffableSet([]),
                    inserted: DiffableSet([]),
                    deleted: DiffableSet([])
                )
            ),
            #line: TestCase(
                from: DiffableSet([
                    .string("I'm not changed")
                ]),
                to: DiffableSet([
                    .string("I'm not changed")
                ]),
                expected: DiffableSet.Diff(
                    notChanged: DiffableSet([
                        .string("I'm not changed")
                    ]),
                    inserted: DiffableSet([]),
                    deleted: DiffableSet([])
                )
            ),
            #line: TestCase(
                from: DiffableSet([
                    .string("I'm deleted")
                ]),
                to: DiffableSet([]),
                expected: DiffableSet.Diff(
                    notChanged: DiffableSet([]),
                    inserted: DiffableSet([]),
                    deleted: DiffableSet([
                        .string("I'm deleted")
                    ])
                )
            ),
            #line: TestCase(
                from: DiffableSet([]),
                to: DiffableSet([
                    .string("I'm inserted")
                ]),
                expected: DiffableSet.Diff(
                    notChanged: DiffableSet([]),
                    inserted: DiffableSet([
                        .string("I'm inserted")
                    ]),
                    deleted: DiffableSet([])
                )
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
                expected: DiffableSet.Diff(
                    notChanged: DiffableSet([
                        .string("I'm not changed")
                    ]),
                    inserted: DiffableSet([
                        .string("I'm inserted")
                    ]),
                    deleted: DiffableSet([
                        .string("I'm deleted")
                    ])
                )
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
                expected: DiffableSet.Diff(
                    notChanged: DiffableSet([
                        .string("I'm deleted"),
                    ]),
                    inserted: DiffableSet([]),
                    deleted: DiffableSet([
                        .string("I'm deleted"),
                    ])
                )
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
                expected: DiffableSet.Diff(
                    notChanged: DiffableSet([
                        .string("I'm inserted"),
                    ]),
                    inserted: DiffableSet([
                        .string("I'm inserted"),
                    ]),
                    deleted: DiffableSet([])
                )
            ),
        ]
    
    
        testCases.forEach { (line, testCase) in
            XCTAssertEqual(
                DiffableSet.diff(from: testCase.from, to: testCase.to),
                testCase.expected,
                line: #line
            )
        }
    }


    static var allTests : [(String, (DiffableSetTests) -> () throws -> Void)] {
        return [
            ("testExample", self.testDiff),
        ]
    }
}

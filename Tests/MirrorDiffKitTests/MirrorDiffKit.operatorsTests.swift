import XCTest
@testable import MirrorDiffKit


class MirrorDiffKitOperatorsTests: XCTestCase {
    private struct TestCase<T> {
        let a: T
        let b: T
        let expected: Bool
    }


    private let testCases: [UInt: TestCase<Any>] = [
        #line: TestCase(
            a: "equal",
            b: "equal",
            expected: true
        ),
        #line: TestCase(
            a: "not equal",
            b: "NOT EQUAL",
            expected: false
        ),
        #line: TestCase(
            a: StructStub.OneEntry(key1: "equal"),
            b: StructStub.OneEntry(key1: "equal"),
            expected: true
        ),
        #line: TestCase(
            a: StructStub.OneEntry(key1: "not equal"),
            b: StructStub.OneEntry(key1: "NOT EQUAL"),
            expected: false
        ),
        #line: TestCase(
            a: ClassStub.OneEntry(key1: "equal"),
            b: ClassStub.OneEntry(key1: "equal"),
            expected: true
        ),
        #line: TestCase(
            a: ClassStub.OneEntry(key1: "not equal"),
            b: ClassStub.OneEntry(key1: "NOT EQUAL"),
            expected: false
        ),
        #line: TestCase(
            a: EnumStub.AssociatedBySameKeys.one(key: "equal"),
            b: EnumStub.AssociatedBySameKeys.one(key: "equal"),
            expected: true
        ),
        #line: TestCase(
            a: EnumStub.AssociatedBySameKeys.one(key: "not equal"),
            b: EnumStub.AssociatedBySameKeys.one(key: "NOT EQUAL"),
            expected: false
        ),
    ]


    func testEqualityOperator() {
        self.testCases.forEach { entry in
            let (line, testCase) = entry
            XCTAssertEqual(
                testCase.a =~ testCase.b,
                testCase.expected,
                line: line
            )
        }
    }


    func testDifferenceOperator() {
        self.testCases.forEach { entry in
            let (line, testCase) = entry
            XCTAssertEqual(
                testCase.a !~ testCase.b,
                !testCase.expected,
                line: line
            )
        }
    }


    static var allTests : [(String, (MirrorDiffKitOperatorsTests) -> () throws -> Void)] {
        return [
            ("testEqualityOperator", self.testEqualityOperator),
            ("testDifferenceOperator", self.testDifferenceOperator),
        ]
    }
}

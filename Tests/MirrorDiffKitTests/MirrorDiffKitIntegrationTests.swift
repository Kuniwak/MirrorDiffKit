import XCTest
@testable import MirrorDiffKit


class MirrorDiffKitTests: XCTestCase {
    private struct TestCase {
        let a: Any
        let b: Any
        let expected: String

        init(diffBetween a: Any, and b: Any, is expected: String) {
            self.a = a
            self.b = b
            self.expected = expected
        }
    }


    func testIntegration() {
        let testCases: [UInt: TestCase] = [
            #line: TestCase(
                diffBetween: 3.1416,
                and: 3.1416,
                is: [
                    "",
                    "  3.1416",
                    "",
                ].joined(separator: "\n")
            ),
            #line: TestCase(
                diffBetween: 3.1416,
                and: 2.7183,
                is: [
                    "",
                    "- 3.1416",
                    "+ 2.7183",
                    "",
                ].joined(separator: "\n")
            ),
            #line: TestCase(
                diffBetween: EnumStub.NotAssociated.one,
                and: EnumStub.NotAssociated.one,
                is: [
                    "",
                    "  NotAssociated.one",
                    "",
                ].joined(separator: "\n")
            ),
            #line: TestCase(
                diffBetween: EnumStub.NotAssociated.one,
                and: EnumStub.NotAssociated.two,
                is: [
                    "",
                    "- NotAssociated.one",
                    "+ NotAssociated.two",
                    "",
                ].joined(separator: "\n")
            ),
            #line: TestCase(
                diffBetween: EnumStub.AssociatedBySameKeys.one(key: "value"),
                and: EnumStub.AssociatedBySameKeys.one(key: "value"),
                is: [
                    "",
                    "  AssociatedBySameKeys.one(\"value\")", // NOTE: Label has gone away X-(
                    "",
                ].joined(separator: "\n")
            ),
            #line: TestCase(
                diffBetween: EnumStub.AssociatedByNotSameKeys.two(key1b: "value1b", key2b: "value2b"),
                and: EnumStub.AssociatedByNotSameKeys.two(key1b: "value1b", key2b: "value2b"),
                is: [
                    "",
                    "  AssociatedByNotSameKeys.two(\"value1b\", \"value2b\")", // NOTE: Label has gone away X-(
                    "",
                ].joined(separator: "\n")
            ),
            #line: TestCase(
                diffBetween: StructStub.TwoEntries(
                    key1: "I'm not changed",
                    key2: "I'm deleted"
                ),
                and: StructStub.TwoEntries(
                    key1: "I'm not changed",
                    key2: "I'm inserted"
                ),
                is: [
                    "",
                    "  struct TwoEntries {",
                    "      key1: \"I'm not changed\"",
                    "    - key2: \"I'm deleted\"",
                    "    + key2: \"I'm inserted\"",
                    "  }",
                    "",
                ].joined(separator: "\n")
            ),
            #line: TestCase(
                diffBetween: ClassStub.TwoEntries(
                    key1: "I'm not changed",
                    key2: "I'm deleted"
                ),
                and: ClassStub.TwoEntries(
                    key1: "I'm not changed",
                    key2: "I'm inserted"
                ),
                is: [
                    "",
                    "  class TwoEntries {",
                    "      key1: \"I'm not changed\"",
                    "    - key2: \"I'm deleted\"",
                    "    + key2: \"I'm inserted\"",
                    "  }",
                    "",
                ].joined(separator: "\n")
            ),
            #line: TestCase(
                diffBetween: StructStub.OneEntry(
                    key1: "I'm not changed"
                ),
                and: ClassStub.OneEntry(
                    key1: "I'm not changed"
                ),
                is: [
                    "",
                    "- struct OneEntry { key1: \"I'm not changed\" }",
                    "+ class OneEntry { key1: \"I'm not changed\" }",
                    "",
                ].joined(separator: "\n")
            ),
            #line: TestCase(
                diffBetween: StructStub.TwoEntries(
                    key1: "I'm not changed",
                    key2: "I'm deleted"
                ),
                and: ClassStub.TwoEntries(
                    key1: "I'm not changed",
                    key2: "I'm inserted"
                ),
                is: [
                    "",
                    "- struct TwoEntries { key1: \"I'm not changed\", key2: \"I'm deleted\" }",
                    "+ class TwoEntries { key1: \"I'm not changed\", key2: \"I'm inserted\" }",
                    "",
                ].joined(separator: "\n")
            ),
        ]


        testCases.forEach { (line, testCase) in
            let actual = diff(between: testCase.a, and: testCase.b)
            let expected = testCase.expected

            XCTAssertEqual(actual, expected, line: line)

            // NOTE: Print verbose info for efficient debugging.
            let wasTestFailed = actual != testCase.expected
            if wasTestFailed {
                print("actual:")
                dump(actual.components(separatedBy: "\n"))

                print("\nexpected:")
                dump(expected.components(separatedBy: "\n"))

                print("\nverbose:")
                dump(Diffable.diff(
                    between: Diffable.from(any: testCase.a),
                    and: Diffable.from(any: testCase.b)
                ))
            }
        }
    }


    static var allTests : [(String, (MirrorDiffKitTests) -> () throws -> Void)] {
        return [
            ("testIntegration", self.testIntegration),
        ]
    }
}

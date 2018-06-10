import XCTest
import MirrorDiffKit


class MirrorDiffKitDiffTests: XCTestCase {
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


    func testDiff() {
        let testCases: [UInt: TestCase] = [
            #line: TestCase(
                diffBetween: 3.1416,
                and: 3.1416,
                is: [
                    "",
                    "  Double(3.1416)",
                    "",
                ].joined(separator: "\n")
            ),
            #line: TestCase(
                diffBetween: 3.1416,
                and: 2.7183,
                is: [
                    "",
                    "- Double(3.1416)",
                    "+ Double(2.7183)",
                    "",
                ].joined(separator: "\n")
            ),
            #line: TestCase(
                diffBetween: [0, 1, 2],
                and: [0, 2, 3],
                is: [
                    "",
                    "  [",
                    "      Int(0)",
                    "    - Int(1)",
                    "      Int(2)",
                    "    + Int(3)",
                    "  ]",
                    "",
                ].joined(separator: "\n")
            ),
            #line: TestCase(
                diffBetween: ["key": "value1"],
                and: ["key": "value2"],
                is: [
                    "",
                    "  [",
                    "    - \"key\": \"value1\"",
                    "    + \"key\": \"value2\"",
                    "  ]",
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
                is: TupleRepresentation.current.isFullyLabeled
                    ? [
                        "",
                        "  AssociatedBySameKeys.one(key: \"value\")",
                        "",
                    ].joined(separator: "\n")
                    : [
                        "",
                        "  AssociatedBySameKeys.one(\"value\")", // NOTE: Label has gone away on Swift 4.1 or lower X-(
                        "",
                    ].joined(separator: "\n")
            ),
            #line: TestCase(
                diffBetween: EnumStub.AssociatedByNotSameKeys.two(key1b: "value1b", key2b: "value2b"),
                and: EnumStub.AssociatedByNotSameKeys.two(key1b: "value1b", key2b: "value2b"),
                is: [
                    "",
                    "  AssociatedByNotSameKeys.two(key1b: \"value1b\", key2b: \"value2b\")",
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
            #line: TestCase(
                diffBetween: [
                    "changed": StructStub.OneEntry(key1: "I'm deleted"),
                ],
                and: [
                    "changed": StructStub.OneEntry(key1: "I'm inserted"),
                ],
                is: [
                    "",
                    "  [",
                    "      \"changed\": struct OneEntry {",
                    "        - key1: \"I'm deleted\"",
                    "        + key1: \"I'm inserted\"",
                    "      }",
                    "  ]",
                    "",
                ].joined(separator: "\n")
            ),
        ]


        testCases.forEach { entry in
            let (line, testCase) = entry
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
                dump(diff(between: testCase.a, and: testCase.b))
            }
        }
    }


    static var allTests : [(String, (MirrorDiffKitDiffTests) -> () throws -> Void)] {
        return [
            ("testDiff", self.testDiff),
        ]
    }
}

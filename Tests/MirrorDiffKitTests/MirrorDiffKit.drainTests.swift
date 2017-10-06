import XCTest
import MirrorDiffKit


class MirrorDiffKitDrainTests: XCTestCase {
    private struct TestCase {
        let input: Any
        let expected: String
    }


    func testDrain() {
        let testCases: [UInt: TestCase] = [
            #line: TestCase(
                input: 123,
                expected: "123.0"
            ),
            #line: TestCase(
                input: "string",
                expected: "\"string\""
            ),
            #line: TestCase(
                input: true,
                expected: "true"
            ),
            #line: TestCase(
                input: EnumStub.NotAssociated.one,
                expected: "NotAssociated.one"
            ),
            #line: TestCase(
                input: EnumStub.AssociatedByNotSameKeys.two(key1b: "value1b", key2b: "value2b"),
                expected: [
                    "AssociatedByNotSameKeys.two(",
                    "    key1b: \"value1b\"",
                    "    key2b: \"value2b\"",
                    ")",
                ].joined(separator: "\n")
            ),
            #line: TestCase(
                input: StructStub.OneEntry(key1: "value1"),
                expected: [
                    "struct OneEntry {",
                    "    key1: \"value1\"",
                    "}",
                ].joined(separator: "\n")
            ),
            #line: TestCase(
                input: ClassStub.OneEntry(key1: "value1"),
                expected: [
                    "class OneEntry {",
                    "    key1: \"value1\"",
                    "}",
                ].joined(separator: "\n")
            ),
        ]


        testCases.forEach { (entry) in
            let (line, testCase) = entry
            let actual = drain(testCase.input)
            let expected = testCase.expected

            XCTAssertEqual(actual, expected, line: line)
        }
    }


    static var allTests: [(String, (MirrorDiffKitDrainTests) -> () throws -> Void)] {
        return [
            ("testDrain", self.testDrain),
        ]
    }
}


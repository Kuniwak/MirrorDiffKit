import XCTest
import Foundation
@testable import MirrorDiffKit



class DiffableTests: XCTestCase {
    private struct TestCase {
        let input: Diffable
        let expected: String
    }


    func testDescription() {
        let testCases: [UInt: TestCase] = [
            #line: TestCase(
                input: .null,
                expected: "NSNull()"
            ),
            #line: TestCase(
                input: .none,
                expected: "nil"
            ),
            #line: TestCase(
                input: .string(type: String.self, content: "STRING"),
                expected: "\"STRING\""
            ),
            #line: TestCase(
                input: .number(type: Double.self, value: "10.0"),
                expected: "Double(10.0)"
            ),
            #line: TestCase(
                input: .date(Date(timeIntervalSince1970: 0)),
                expected: "1970-01-01 00:00:00 +0000"
            ),
            #line: TestCase(
                input: .url(URL(string: "http://example.com/path/?q=v#f")!),
                expected: "http://example.com/path/?q=v#f"
            ),
            #line: TestCase(
                input: .tuple(type: Void.self, entries: []),
                expected: "()"
            ),
            #line: TestCase(
                input: .tuple(type: (Optional<Any>, label: Optional<Any>).self, entries: [
                    .notLabeled(index: 0, value: .none),
                    .labeled(label: "label", value: .none),
                ]),
                expected: "(nil, label: nil)"
            ),
            #line: TestCase(
                input: .collection(type: Array<Any>.self, elements: [Diffable]()),
                expected: "Array<Any> []"
            ),
            #line: TestCase(
                input: .collection(type: Array<Optional<Any>>.self, elements: [.none]),
                expected: "Array<Optional<Any>> [nil]"
            ),
            #line: TestCase(
                input: .collection(
                    type: Array<String>.self,
                    elements: [
                        .string(type: String.self, content: "1st"),
                        .string(type: String.self, content: "2nd"),
                    ]),
                expected: "Array<String> [\"1st\", \"2nd\"]"
            ),
            #line: TestCase(
                input: .dictionary(type: [String: String].self, entries: []),
                expected: "Dictionary<String, String> [:]"
            ),
            #line: TestCase(
                input: .dictionary(type: [String: String].self, entries: [
                    (
                        key: .string(type: String.self, content: "KEY"),
                        value: .string(type: String.self, content: "VALUE")
                    ),
                ]),
                expected: "Dictionary<String, String> [\"KEY\": \"VALUE\"]"
            ),
            #line: TestCase(
                input: .dictionary(type: [String: String].self, entries: [
                    (
                        key: .string(type: String.self, content: "KEY1"),
                        value: .string(type: String.self, content: "VALUE1")
                    ),
                    (
                        key: .string(type: String.self, content: "KEY2"),
                        value: .string(type: String.self, content: "VALUE2")
                    ),
                ]),
                expected: "Dictionary<String, String> [\"KEY1\": \"VALUE1\", \"KEY2\": \"VALUE2\"]"
            ),
            #line: TestCase(
                input: .anyEnum(
                    type: EnumStub.NotAssociated.self,
                    caseName: EnumCaseName("one"),
                    associated: []
                ),
                expected: "NotAssociated.one"
            ),
            #line: TestCase(
                input: .anyEnum(
                    type: EnumStub.NotAssociatedButTyped.self,
                    caseName: EnumCaseName("one"),
                    associated: []
                ),
                expected: "NotAssociatedButTyped.one"
            ),
            #line: TestCase(
                input: .anyEnum(
                    type: EnumStub.AssociatedBySameKeys.self,
                    caseName: EnumCaseName("one"),
                    associated: [.labeled(label: "key", value: .string(type: String.self, content: "value"))]
                ),
                expected: "AssociatedBySameKeys.one(key: \"value\")"
            ),
            #line: TestCase(
                input: .anyEnum(
                    type: EnumStub.AssociatedBySameKeys.self,
                    caseName: EnumCaseName("one"),
                    associated: [.notLabeled(index: 0, value: .string(type: String.self, content: "value"))]
                ),
                // NOTE: For Swift 3.0-. the label has gone away. X-(
                expected: "AssociatedBySameKeys.one(\"value\")"
            ),
            #line: TestCase(
                input: .anyEnum(
                    type: EnumStub.AssociatedByNotSameKeys.self,
                    caseName: EnumCaseName("two"),
                    associated: [
                        .labeled(label: "key1b", value: .string(type: String.self, content: "value1b")),
                        .labeled(label: "key2b", value: .string(type: String.self, content: "value2b")),
                    ]
                ),
                expected: "AssociatedByNotSameKeys.two(key1b: \"value1b\", key2b: \"value2b\")"
            ),
            #line: TestCase(
                input: .anyStruct(
                    type: StructStub.Empty.self,
                    entries: [:]
                ),
                expected: "struct Empty {}"
            ),
            #line: TestCase(
                input: .anyStruct(
                    type: StructStub.OneEntry.self,
                    entries: [
                        "key1": .string(type: String.self, content: "value1"),
                    ]
                ),
                expected: "struct OneEntry { key1: \"value1\" }"
            ),
            #line: TestCase(
                input: .anyStruct(
                    type: StructStub.TwoEntries.self,
                    entries: [
                        "key1": .string(type: String.self, content: "value1"),
                        "key2": .string(type: String.self, content: "value2"),
                    ]
                ),
                expected: "struct TwoEntries { key1: \"value1\", key2: \"value2\" }"
            ),
            #line: TestCase(
                input: .anyClass(
                    type: ClassStub.Empty.self,
                    entries: [:]
                ),
                expected: "class Empty {}"
            ),
            #line: TestCase(
                input: .anyClass(
                    type: ClassStub.OneEntry.self,
                    entries: [
                        "key1": .string(type: String.self, content: "value1"),
                    ]
                ),
                expected: "class OneEntry { key1: \"value1\" }"
            ),
            #line: TestCase(
                input: .anyClass(
                    type: ClassStub.TwoEntries.self,
                    entries: [
                        "key1": .string(type: String.self, content: "value1"),
                        "key2": .string(type: String.self, content: "value2"),
                    ]
                ),
                expected: "class TwoEntries { key1: \"value1\", key2: \"value2\" }"
            ),
            // TODO: Generic
        ]


        testCases.forEach { entry in
            let (line, testCase) = entry
            let description = testCase.input.description

            XCTAssertEqual(description, testCase.expected, line: line)
        }
    }


    static var allTests : [(String, (DiffableTests) -> () throws -> Void)] {
        return [
            ("testDescription", self.testDescription),
        ]
    }
}
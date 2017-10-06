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
                input: .string("STRING"),
                expected: "\"STRING\""
            ),
            #line: TestCase(
                input: .number(10.0),
                expected: "10.0"
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
                input: .tuple([]),
                expected: "()"
            ),
            #line: TestCase(
                input: .tuple([
                    .notLabeled(index: 0, value: .none),
                    .labeled(label: "label", value: .none),
                ]),
                expected: "(nil, label: nil)"
            ),
            #line: TestCase(
                input: .array([Diffable]()),
                expected: "[]"
            ),
            #line: TestCase(
                input: .array([.none]),
                expected: "[nil]"
            ),
            #line: TestCase(
                input: .array([.string("1st"), .string("2nd")]),
                expected: "[\"1st\", \"2nd\"]"
            ),
            #line: TestCase(
                input: .dictionary([]),
                expected: "[:]"
            ),
            #line: TestCase(
                input: .dictionary([
                    (
                        key: .string("KEY"),
                        value: .string("VALUE")
                    ),
                ]),
                expected: "[\"KEY\": \"VALUE\"]"
            ),
            #line: TestCase(
                input: .dictionary([
                    (
                        key: .string("KEY1"),
                        value: .string("VALUE1")
                    ),
                    (
                        key: .string("KEY2"),
                        value: .string("VALUE2")
                    ),
                ]),
                expected: "[\"KEY1\": \"VALUE1\", \"KEY2\": \"VALUE2\"]"
            ),
            #line: TestCase(
                input: .anyEnum(
                    type: EnumStub.NotAssociated.self,
                    value: EnumStub.NotAssociated.one,
                    associated: []
                ),
                expected: "NotAssociated.one"
            ),
            #line: TestCase(
                input: .anyEnum(
                    type: EnumStub.NotAssociatedButTyped.self,
                    value: EnumStub.NotAssociatedButTyped.one,
                    associated: []
                ),
                expected: "NotAssociatedButTyped.one"
            ),
            #line: TestCase(
                input: .anyEnum(
                    type: EnumStub.AssociatedBySameKeys.self,
                    value: EnumStub.AssociatedBySameKeys.one(key: "value"),
                    associated: [.labeled(label: "key", value: .string("value"))]
                ),
                expected: "AssociatedBySameKeys.one(key: \"value\")"
            ),
            #line: TestCase(
                input: .anyEnum(
                    type: EnumStub.AssociatedBySameKeys.self,
                    value: EnumStub.AssociatedBySameKeys.one(key: "value"),
                    associated: [.notLabeled(index: 0, value: .string("value"))]
                ),
                // NOTE: For Swift 3.0-. the label has gone away. X-(
                expected: "AssociatedBySameKeys.one(\"value\")"
            ),
            #line: TestCase(
                input: .anyEnum(
                    type: EnumStub.AssociatedByNotSameKeys.self,
                    value: EnumStub.AssociatedByNotSameKeys.two(key1b: "value1b", key2b: "value2b"),
                    associated: [
                        .labeled(label: "key1b", value: .string("value1b")),
                        .labeled(label: "key2b", value: .string("value2b")),
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
                        "key1": .string("value1"),
                    ]
                ),
                expected: "struct OneEntry { key1: \"value1\" }"
            ),
            #line: TestCase(
                input: .anyStruct(
                    type: StructStub.TwoEntries.self,
                    entries: [
                        "key1": .string("value1"),
                        "key2": .string("value2"),
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
                        "key1": .string("value1"),
                    ]
                ),
                expected: "class OneEntry { key1: \"value1\" }"
            ),
            #line: TestCase(
                input: .anyClass(
                    type: ClassStub.TwoEntries.self,
                    entries: [
                        "key1": .string("value1"),
                        "key2": .string("value2"),
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
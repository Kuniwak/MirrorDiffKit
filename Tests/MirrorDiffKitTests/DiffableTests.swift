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
                input: .tuple([".0": .none, "label": .none]),
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
                input: .dictionary([:]),
                expected: "[:]"
            ),
            #line: TestCase(
                input: .dictionary(["key": .string("value")]),
                expected: "[\"key\": \"value\"]"
            ),
            #line: TestCase(
                input: .dictionary(["key1": .string("value1"), "key2": .string("value2")]),
                expected: "[\"key1\": \"value1\", \"key2\": \"value2\"]"
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
                    associated: [.string("value")]
                ),
                // NOTE: the label has gone away. X-(
                expected: "AssociatedBySameKeys.one(\"value\")"
            ),
            #line: TestCase(
                input: .anyEnum(
                    type: EnumStub.AssociatedByNotSameKeys.self,
                    value: EnumStub.AssociatedByNotSameKeys.two(key1b: "value1b", key2b: "value2b"),
                    associated: [.string("value1b"), .string("value2b")]
                ),
                // NOTE: the label has gone away. X-(
                expected: "AssociatedByNotSameKeys.two(\"value1b\", \"value2b\")"
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
    
    
        testCases.forEach { (line, testCase) in
            let description = testCase.input.description

            XCTAssertEqual(description, testCase.expected, line: line)
        }
    }


    static var allTests : [(String, (DiffableTests) -> () throws -> Void)] {
        return [
            // ("testExample", testExample),
        ]
    }
}
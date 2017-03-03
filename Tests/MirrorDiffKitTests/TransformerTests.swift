import XCTest
import Foundation
@testable import MirrorDiffKit


class TransformerTests: XCTestCase {
    // MARK: - Test case definition
    private struct TestCase {
        let input: Any
        let target: Diffable
        let expected: Bool
    }


    func testTransform() {
        let testCases: [UInt: TestCase] = [
            // MARK: - Primitive values
            #line: TestCase(
                input: NSNull(),
                target: .null,
                expected: true
            ),
            #line: TestCase(
                input: OptionalStub.none as Any,
                target: .none,
                expected: true
            ),
            #line: TestCase(
                input: OptionalStub.some as Any,
                // XXX: We cannot know whether the not nil type is an optional or not.
                // Therefore, all not nil values are transformed as non-optional types.
                target: .number(10),
                expected: true
            ),
            #line: TestCase(
                input: 10,
                target: .number(10.0),
                expected: true
            ),
            #line: TestCase(
                input: 10 as Int,
                target: .number(10.0),
                expected: true
            ),
            #line: TestCase(
                input: 10 as Int8,
                target: .number(10.0),
                expected: true
            ),
            #line: TestCase(
                input: 10 as UInt,
                target: .number(10.0),
                expected: true
            ),
            #line: TestCase(
                input: 10 as UInt8,
                target: .number(10.0),
                expected: true
            ),
            #line: TestCase(
                input: -10,
                target: .number(-10),
                expected: true
            ),
            #line: TestCase(
                input: 3.14,
                target: .number(3.14),
                expected: true
            ),
            #line: TestCase(
                input: "",
                target: .string(""),
                expected: true
            ),
            #line: TestCase(
                input: "string",
                target: .string("string"),
                expected: true
            ),
            #line: TestCase(
                input: true,
                target: .bool(true),
                expected: true
            ),
            #line: TestCase(
                input: false,
                target: .bool(false),
                expected: true
            ),


            // MARK: Date
            #line: TestCase(
                input: Date(timeIntervalSince1970: 0.0),
                target: .date(Date(timeIntervalSince1970: 0.0)),
                expected: true
            ),
            #line: TestCase(
                input: Date(timeIntervalSince1970: 0.0),
                target: .date(Date(timeIntervalSince1970: 1000.0)),
                expected: false
            ),


            // MARK: Tuple
            #line: TestCase(
                input: (),
                target: .tuple([String: Diffable]()),
                expected: true
            ),
            #line: TestCase(
                input: (10, 20),
                target: .tuple([
                    ".0": .number(10),
                    ".1": .number(20),
                ]),
                expected: true
            ),
            #line: TestCase(
                input: (label: 10),
                // XXX: Unary labeled tuple is not a tuple! ;-(
                target: .number(10),
                expected: true
            ),
            #line: TestCase(
                input: (label1: 10, label2: 20),
                target: .tuple([
                    ".0": .number(10),
                    ".1": .number(20),
                ]),
                expected: true
            ),


            // MARK: Set
            #line: TestCase(
                input: Set<Int>([]),
                target: .set([]),
                expected: true
            ),
            #line: TestCase(
                input: Set([1]),
                target: .set([
                    .number(1),
                ]),
                expected: true
            ),


            // MARK: Array
            #line: TestCase(
                input: [],
                target: .array([]),
                expected: true
            ),
            #line: TestCase(
                input: [1, 1, 2, 3, 5],
                target: .array([
                    .number(1),
                    .number(1),
                    .number(2),
                    .number(3),
                    .number(5),
                ]),
                expected: true
            ),
            #line: TestCase(
                input: [[0, -1], [1, 0]],
                target: .array([
                    .array([.number(0), .number(-1)]),
                    .array([.number(1), .number(0)]),
                ]),
                expected: true
            ),
            #line: TestCase(
                input: [[0, -1], [1, 0]],
                target: .array([
                    .array([.number(0), .number(-1)]),
                    .array([.number(1), .number(0)]),
                ]),
                expected: true
            ),

            
            // MARK: - Struct
            #line: TestCase(
                input: StructStub.Empty(),
                target: .anyStruct(
                    type: StructStub.Empty.self,
                    entries: [:]
                ),
                expected: true
            ),
            #line: TestCase(
                input: StructStub.OneEntry(
                    key1: "value1"
                ),
                target: .anyStruct(
                    type: StructStub.OneEntry.self,
                    entries: [
                        "key1": .string("value1"),
                    ]
                ),
                expected: true
            ),
            #line: TestCase(
                input: StructStub.TwoEntries(
                    key1: "value1",
                    key2: "value2"
                ),
                target: .anyStruct(
                    type: StructStub.TwoEntries.self,
                    entries: [
                        "key1": .string("value1"),
                        "key2": .string("value2"),
                    ]
                ),
                expected: true
            ),
            #line: TestCase(
                input: 0 ..< 5,
                target: .generic(
                    type: CountableRange<Int>.self,
                    entries: [
                        "lowerBound": .number(0),
                        "upperBound": .number(5),
                    ]
                ),
                expected: true
            ),


            // MARK: - Class
            #line: TestCase(
                input: ClassStub.Empty(),
                target: .anyClass(
                    type: ClassStub.Empty.self,
                    entries: [:]
                ),
                expected: true
            ),
            #line: TestCase(
                input: ClassStub.OneEntry(
                    key1: "value1"
                ),
                target: .anyClass(
                    type: ClassStub.OneEntry.self,
                    entries: [
                        "key1": .string("value1"),
                    ]
                ),
                expected: true
            ),
            #line: TestCase(
                input: ClassStub.TwoEntries(
                    key1: "value1",
                    key2: "value2"
                ),
                target: .anyClass(
                    type: ClassStub.TwoEntries.self,
                    entries: [
                        "key1": .string("value1"),
                        "key2": .string("value2"),
                    ]
                ),
                expected: true
            ),


            // MARK: - Non-associated enum
            #line: TestCase(
                input: EnumStub.NotAssociated.one,
                target: .anyEnum(
                    type: EnumStub.NotAssociated.self,
                    value: EnumStub.NotAssociated.one,
                    associated: []
                ),
                expected: true
            ),
            #line: TestCase(
                input: EnumStub.NotAssociated.one,
                target: .anyEnum(
                    type: EnumStub.NotAssociated.self,
                    value: EnumStub.NotAssociated.two,
                    associated: []
                ),
                expected: false
            ),
            #line: TestCase(
                input: EnumStub.NotAssociatedButTyped.one,
                target: .anyEnum(
                    type: EnumStub.NotAssociatedButTyped.self,
                    value: EnumStub.NotAssociatedButTyped.one,
                    associated: []
                ),
                expected: true
            ),
            #line: TestCase(
                input: EnumStub.NotAssociatedButTyped.one,
                target: .anyEnum(
                    type: EnumStub.NotAssociatedButTyped.self,
                    value: EnumStub.NotAssociatedButTyped.two,
                    associated: []
                ),
                expected: false
            ),


            // MARK: - Non-associated enum
            #line: TestCase(
                input: EnumStub.AssociatedBySameKeys.one(key: "value"),
                target: .anyEnum(
                    type: EnumStub.AssociatedBySameKeys.self,
                    value: EnumStub.AssociatedBySameKeys.one(key: "value") as Any,
                    associated: [
                        .string("value"),
                    ]
                ),
                expected: true
            ),
            #line: TestCase(
                input: EnumStub.AssociatedByNotSameKeys.two(key1b: "value1b", key2b: "value2b"),
                target: .anyEnum(
                    type: EnumStub.AssociatedByNotSameKeys.self,
                    value: EnumStub.AssociatedByNotSameKeys.two(key1b: "value1b", key2b: "value2b") as Any,
                    associated: [
                        .string("value1b"),
                        .string("value2b")
                    ]
                ),
                expected: true
            ),


            // MARK: Generic
            #line: TestCase(
                input: GenericStub(value: "string"),
                target: .anyStruct(
                    type: GenericStub<String>.self,
                    entries: [
                        "value": .string("string"),
                    ]
                ),
                expected: true
            ),
        ]


        // MARK: - Test body
        testCases.forEach { line, testCase in
            let transformed = transform(fromAny: testCase.input)
            let target = testCase.target
            let expected = testCase.expected

            XCTAssertEqual(target == transformed, expected, line: line)

            // NOTE: Print verbose info to efficient debugging.
            if ((target == transformed) != expected) {
                print("expected:")
                dump(expected)

                print("\ntarget:")
                dump(target)

                print("\ntransformed:")
                dump(transformed)
            }
        }
    }


    static var allTests : [(String, (TransformerTests) -> () throws -> Void)] {
        return [
             ("testTransform", self.testTransform),
        ]
    }
}

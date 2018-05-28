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
                target: .number(type: Int.self, value: "10"),
                expected: true
            ),
            #line: TestCase(
                input: 10 as Int,
                target: .number(type: Int.self, value: "10"),
                expected: true
            ),
            #line: TestCase(
                input: 10 as Int8,
                target: .number(type: Int8.self, value: "10"),
                expected: true
            ),
            #line: TestCase(
                input: 10 as UInt,
                target: .number(type: UInt.self, value: "10"),
                expected: true
            ),
            #line: TestCase(
                input: 10 as UInt8,
                target: .number(type: UInt8.self, value: "10"),
                expected: true
            ),
            #line: TestCase(
                input: -10,
                target: .number(type: Int.self, value: "-10"),
                expected: true
            ),
            #line: TestCase(
                input: 3.14,
                target: .number(type: Double.self, value: "3.14"),
                expected: true
            ),
            #line: TestCase(
                input: 3.14 as Float,
                target: .number(type: Float.self, value: "3.14"),
                expected: true
            ),
            #line: TestCase(
                input: 3.14 as Float32,
                target: .number(type: Float32.self, value: "3.14"),
                expected: true
            ),
            #line: TestCase(
                input: 3.14 as Float64,
                target: .number(type: Float64.self, value: "3.14"),
                expected: true
            ),
            #line: TestCase(
                // NOTE: Use fake CGFloat on Linux.
                input: createCGFloat(3.14),
                target: .number(type: CGFloatCompatibleWithLinux.self, value: "3.14"),
                expected: true
            ),

            // MARK: String
            #line: TestCase(
                input: "",
                target: .string(type: String.self, content: ""),
                expected: true
            ),
            #line: TestCase(
                input: "string",
                target: .string(type: String.self, content: "string"),
                expected: true
            ),
            #line: TestCase(
                input: "substring".prefix(3),
                target: .string(type: Substring.self, content: "sub"),
                expected: true
            ),

            // MARK: Bool
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
                target: .tuple(type: Void.self, entries: []),
                expected: true
            ),
            #line: TestCase(
                input: (10, 20),
                target: .tuple(type: (Int, Int).self, entries: [
                    .notLabeled(index: 0, value: .number(type: Int.self, value: "10")),
                    .notLabeled(index: 1, value: .number(type: Int.self, value: "20")),
                ]),
                expected: true
            ),
            #line: TestCase(
                input: (label: 10),
                // XXX: Unary labeled tuple is not a tuple! ;-(
                target: .number(type: Int.self, value: "10"),
                expected: true
            ),
            #line: TestCase(
                input: (label1: 10, label2: 20),
                target: TupleRepresentation.current.isLabeled
                    ? .tuple(type: (label1: Int, label2: Int).self, entries: [
                        .labeled(label: "label1", value: .number(type: Int.self, value: "10")),
                        .labeled(label: "label2", value: .number(type: Int.self, value: "20")),
                    ])
                    : .tuple(type: (label1: Int, label2: Int).self, entries: [
                        .notLabeled(index: 0, value: .number(type: Int.self, value: "10")),
                        .notLabeled(index: 1, value: .number(type: Int.self, value: "20")),
                    ]),
                expected: true
            ),


            // MARK: Set
            #line: TestCase(
                input: Set<Int>([]),
                target: .set(type: Set<Int>.self, elements: []),
                expected: true
            ),
            #line: TestCase(
                input: Set([1]),
                target: .set(type: Set<Int>.self, elements: [
                    .number(type: Int.self, value: "1"),
                ]),
                expected: true
            ),


            // MARK: Collection
            #line: TestCase(
                input: [Int](),
                target: .collection(type: Array<Int>.self, elements: []),
                expected: true
            ),
            #line: TestCase(
                input: [1, 1, 2, 3, 5],
                target: .collection(type: Array<Int>.self, elements: [
                    .number(type: Int.self, value: "1"),
                    .number(type: Int.self, value: "1"),
                    .number(type: Int.self, value: "2"),
                    .number(type: Int.self, value: "3"),
                    .number(type: Int.self, value: "5"),
                ]),
                expected: true
            ),
            #line: TestCase(
                input: [[0, -1], [1, 0]],
                target: .collection(type: Array<Array<Int>>.self, elements: [
                    .collection(type: Array<Int>.self, elements: [.number(type: Int.self, value: "0"), .number(type: Int.self, value: "-1")]),
                    .collection(type: Array<Int>.self, elements: [.number(type: Int.self, value: "1"), .number(type: Int.self, value: "0")]),
                ]),
                expected: true
            ),
            #line: TestCase(
                input: [0, 1, 2][0...2],
                target: .collection(type: ArraySlice<Int>.self, elements: [
                    .number(type: Int.self, value: "0"),
                    .number(type: Int.self, value: "1"),
                    .number(type: Int.self, value: "2"),
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
                        "key1": .string(type: String.self, content: "value1"),
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
                        "key1": .string(type: String.self, content: "value1"),
                        "key2": .string(type: String.self, content: "value2"),
                    ]
                ),
                expected: true
            ),
            #line: TestCase(
                input: StructStub.Optional(value: nil),
                target: .anyStruct(
                    type: StructStub.Optional.self,
                    entries: [
                        "value": .none,
                    ]
                ),
                expected: true
            ),
            #line: TestCase(
                input: StructStub.Optional(value: StructStub.Empty()),
                target: .anyStruct(
                    type: StructStub.Optional.self,
                    entries: [
                        "value": .anyStruct(
                            type: StructStub.Empty.self,
                            entries: [:]
                        ),
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
                        "key1": .string(type: String.self, content: "value1"),
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
                        "key1": .string(type: String.self, content: "value1"),
                        "key2": .string(type: String.self, content: "value2"),
                    ]
                ),
                expected: true
            ),


            // MARK: - Non-associated enum
            #line: TestCase(
                input: EnumStub.NotAssociated.one,
                target: .anyEnum(
                    type: EnumStub.NotAssociated.self,
                    caseName: EnumCaseName("one"),
                    associated: []
                ),
                expected: true
            ),
            #line: TestCase(
                input: EnumStub.NotAssociated.one,
                target: .anyEnum(
                    type: EnumStub.NotAssociated.self,
                    caseName: EnumCaseName("two"),
                    associated: []
                ),
                expected: false
            ),
            #line: TestCase(
                input: EnumStub.NotAssociatedButTyped.one,
                target: .anyEnum(
                    type: EnumStub.NotAssociatedButTyped.self,
                    caseName: EnumCaseName("one"),
                    associated: []
                ),
                expected: true
            ),
            #line: TestCase(
                input: EnumStub.NotAssociatedButTyped.one,
                target: .anyEnum(
                    type: EnumStub.NotAssociatedButTyped.self,
                    caseName: EnumCaseName("two"),
                    associated: []
                ),
                expected: false
            ),


            // MARK: - Non-associated enum
            #line: TestCase(
                input: EnumStub.AssociatedBySameKeys.one(key: "value"),
                target: .anyEnum(
                    type: EnumStub.AssociatedBySameKeys.self,
                    caseName: EnumCaseName("one"),
                    associated: [
                         // NOTE: Label has gone away X-(
                        .notLabeled(index: 0, value: .string(type: String.self, content: "value")),
                    ]
                ),
                expected: true
            ),
            #line: TestCase(
                input: EnumStub.AssociatedByNotSameKeys.two(key1b: "value1b", key2b: "value2b"),
                target: .anyEnum(
                    type: EnumStub.AssociatedByNotSameKeys.self,
                    caseName: EnumCaseName("two"),
                    associated: TupleRepresentation.current.isLabeled
                        ? [
                            .labeled(label: "key1b", value: .string(type: String.self, content: "value1b")),
                            .labeled(label: "key2b", value: .string(type: String.self, content: "value2b")),
                        ]
                        : [
                            .notLabeled(index: 0, value: .string(type: String.self, content: "value1b")),
                            .notLabeled(index: 1, value: .string(type: String.self, content: "value2b")),
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
                        "value": .string(type: String.self, content: "string"),
                    ]
                ),
                expected: true
            ),


            // MARK: MetaTypes
            #line: TestCase(
                input: StructStub.self,
                target: .type(StructStub.self),
                expected: true
            ),


            // MARK: - Minor CustomReflectable Types
            #line: TestCase(
                input: "a".first!,
                target: .minorCustomReflectable(type: Character.self, content: .empty(description: "a")),
                expected: true
            ),
            #line: TestCase(
                input: 0 ..< 5,
                target: .minorCustomReflectable(type: Range<Int>.self, content: .notEmpty(entries: [
                    "lowerBound": .number(type: Int.self, value: "0"),
                    "upperBound": .number(type: Int.self, value: "5"),
                ])),
                expected: true
            ),
        ]


        // MARK: - Test body
        testCases.forEach { entry in
            let (line, testCase) = entry
            let transformed = transform(fromAny: testCase.input)
            let target = testCase.target
            let expected = testCase.expected

            XCTAssertEqual(target =~ transformed, expected, line: line)

            // NOTE: Print verbose info to efficient debugging.
            if ((target =~ transformed) != expected) {
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

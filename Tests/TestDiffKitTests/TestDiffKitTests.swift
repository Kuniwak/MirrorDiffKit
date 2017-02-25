import XCTest
import Foundation
@testable import TestDiffKit


class TestDiffKitTests: XCTestCase {
    // MARK: - Test case definition
    private struct TestCase {
        let input: Any
        let target: Diffable
        let expected: Bool
    }


    func testTansform() {
        let testCases: [UInt: TestCase] = [
            // MARK: - Promitive values
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
            #line: TestCase(
                input: [Any](),
                target: .array([Diffable]()),
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
                target: .anyNotAssociatedEnum(
                    type: EnumStub.NotAssociated.self,
                    value: EnumStub.NotAssociated.one
                ),
                expected: true
            ),
            #line: TestCase(
                input: EnumStub.NotAssociated.one,
                target: .anyNotAssociatedEnum(
                    type: EnumStub.NotAssociated.self,
                    value: EnumStub.NotAssociated.two
                ),
                expected: false
            ),
            #line: TestCase(
                input: EnumStub.NotAssociatedButTyped.one,
                target: .anyNotAssociatedEnum(
                    type: EnumStub.NotAssociatedButTyped.self,
                    value: EnumStub.NotAssociatedButTyped.one
                ),
                expected: true
            ),
            #line: TestCase(
                input: EnumStub.NotAssociatedButTyped.one,
                target: .anyNotAssociatedEnum(
                    type: EnumStub.NotAssociatedButTyped.self,
                    value: EnumStub.NotAssociatedButTyped.two
                ),
                expected: false
            ),


            // MARK: - Non-associated enum
            #line: TestCase(
                input: EnumStub.AssociatedBySameKeys.one(key: "value"),
                target: .anyAssociatedEnum(
                    type: EnumStub.AssociatedBySameKeys.self,
                    entries: [
                        "one": .string("value"),
                    ]
                ),
                expected: true
            ),
            #line: TestCase(
                input: EnumStub.AssociatedByNotSameKeys.two(key1b: "value1b", key2b: "value2b"),
                target: .anyAssociatedEnum(
                    type: EnumStub.AssociatedByNotSameKeys.self,
                    entries: [
                        "two": .tuple([
                            ".0": .string("value1b"),
                            ".1": .string("value2b"),
                        ]),
                    ]
                ),
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
        ]


        // MARK: - Test body
        testCases.forEach { line, testCase in
            let actual = transform(fromAny: testCase.input)
            let target = testCase.target

            XCTAssertEqual(
                actual == target,
                testCase.expected,
                line: line
            )

            if ((actual == target) != testCase.expected) {
                dump(["expected": testCase.expected, "target": target, "butGot": actual])
            }
        }
    }


    static var allTests : [(String, (TestDiffKitTests) -> () throws -> Void)] {
        return [
             ("testExample", self.testTansform),
        ]
    }
}



// MARK: - Stubs
private struct OptionalStub {
    static let someValue = 10
    static var some: Int? { return self.someValue }
    static let none: Int? = nil
}



private struct StructStub {
    struct Empty {}

    struct OneEntry {
        let key1: String
    }

    struct TwoEntries {
        let key1: String
        let key2: String
    }
}



private struct ClassStub {
    class Empty {}

    class OneEntry {
        let key1: String

        init(key1: String) {
            self.key1 = key1
        }
    }

    class TwoEntries {
        let key1: String
        let key2: String

        init(key1: String, key2: String) {
            self.key1 = key1
            self.key2 = key2
        }
    }
}


private struct EnumStub {
    enum NotAssociated {
        case one
        case two
    }

    enum NotAssociatedButTyped: Int {
        case one = 1
        case two = 2
    }

    enum AssociatedBySameKeys {
        case one(key: String)
        case two(key: String)
    }

    enum AssociatedByNotSameKeys {
        case one(key1a: String)
        case two(key1b: String, key2b: String)
    }
}

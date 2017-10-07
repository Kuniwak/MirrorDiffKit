import XCTest
@testable import MirrorDiffKit


class DiffablePrettyPrintableTests: XCTestCase {
    private struct TestCase {
        let input: Diffable
        let expected: [PrettyLine]
    }


    func testPrettyLines() {
        let testCases: [UInt: TestCase] = [
            #line: TestCase(
                input: .null,
                expected: [
                    .line("NSNull()"),
                ]
            ),
            #line: TestCase(
                input: .none,
                expected: [
                    .line("nil"),
                ]
            ),
            #line: TestCase(
                input: .string("string"),
                expected: [
                    .line("\"string\""),
                ]
            ),
            #line: TestCase(
                input: .number(123.4),
                expected: [
                    .line("123.4"),
                ]
            ),
            #line: TestCase(
                input: .bool(true),
                expected: [
                    .line("true"),
                ]
            ),
            #line: TestCase(
                input: .date(Date(timeIntervalSince1970: 0)),
                expected: [
                    .line("1970-01-01 00:00:00 +0000"),
                ]
            ),
            #line: TestCase(
                input: .url(URL(string: "http://example.com/path/?q=v#f")!),
                expected: [
                    .line("http://example.com/path/?q=v#f"),
                ]
            ),
            #line: TestCase(
                input: .tuple([]),
                expected: [
                    .line("()"),
                ]
            ),
            #line: TestCase(
                input: .tuple([
                    .notLabeled(index: 0, value: .none),
                    .labeled(label: "label", value: .none),
                ]),
                expected: [
                    .line("("),
                    .indent(.line("nil")),
                    .indent(.line("label: nil")),
                    .line(")"),
                ]
            ),
            #line: TestCase(
                input: .array([]),
                expected: [
                    .line("[]"),
                ]
            ),
            #line: TestCase(
                input: .array([
                    .string("1"),
                    .string("2"),
                    .string("3"),
                ]),
                expected: [
                    .line("["),
                    .indent(.line("\"1\"")),
                    .indent(.line("\"2\"")),
                    .indent(.line("\"3\"")),
                    .line("]"),
                ]
            ),
            #line: TestCase(
                input: .array([
                    .string("1"),
                    .array([
                        .string("2"),
                        .array([
                            .string("3"),
                        ])
                    ])
                ]),
                expected: [
                    .line("["),
                    .indent(.line("\"1\"")),
                    .indent(.line("[")),
                    .indent(.indent(.line("\"2\""))),
                    .indent(.indent(.line("["))),
                    .indent(.indent(.indent(.line("\"3\"")))),
                    .indent(.indent(.line("]"))),
                    .indent(.line("]")),
                    .line("]"),
                ]
            ),
            #line: TestCase(
                input: .set([]),
                expected: [
                    .line("Set []"),
                ]
            ),
            #line: TestCase(
                input: .set([
                    .string("1"),
                    .string("2"),
                    .string("3"),
                ]),
                expected: [
                    .line("Set ["),
                    .indent(.line("\"1\"")),
                    .indent(.line("\"2\"")),
                    .indent(.line("\"3\"")),
                    .line("]"),
                ]
            ),
            #line: TestCase(
                input: .set([
                    .string("1"),
                    .set([
                        .string("2"),
                        .set([
                            .string("3"),
                        ])
                    ])
                ]),
                expected: [
                    .line("Set ["),
                    .indent(.line("Set [")),
                    .indent(.indent(.line("Set ["))),
                    .indent(.indent(.indent(.line("\"3\"")))),
                    .indent(.indent(.line("]"))),
                    .indent(.indent(.line("\"2\""))),
                    .indent(.line("]")),
                    .indent(.line("\"1\"")),
                    .line("]"),
                ]
            ),
            #line: TestCase(
                input: .dictionary([]),
                expected: [
                    .line("[:]")
                ]
            ),
            #line: TestCase(
                input: .dictionary([
                    (key: .string("key1"), value: .string("value1")),
                    (key: .string("key2"), value: .string("value2")),
                    (key: .string("key3"), value: .string("value3")),
                ]),
                expected: [
                    .line("["),
                    .indent(.line("\"key1\": \"value1\"")),
                    .indent(.line("\"key2\": \"value2\"")),
                    .indent(.line("\"key3\": \"value3\"")),
                    .line("]"),
                ]
            ),
            #line: TestCase(
                input: .dictionary([
                    (key: .string("key1"), value: .string("value1")),
                    (key: .string("key2"), value: .dictionary([
                        (key: .string("key3"), value: .string("value3")),
                        (key: .string("key4"), value: .dictionary([
                            (key: .string("key5"), value: .string("value5")),
                        ])),
                    ]))
                ]),
                expected: [
                    .line("["),
                    .indent(.line("\"key1\": \"value1\"")),
                    .indent(.line("\"key2\": [")),
                    .indent(.indent(.line("\"key3\": \"value3\""))),
                    .indent(.indent(.line("\"key4\": ["))),
                    .indent(.indent(.indent(.line("\"key5\": \"value5\"")))),
                    .indent(.indent(.line("]"))),
                    .indent(.line("]")),
                    .line("]"),
                ]
            ),
            #line: TestCase(
                input: .anyEnum(
                    type: EnumStub.NotAssociated.self,
                    caseName: EnumCaseName("one"),
                    associated: []
                ),
                expected: [
                    .line("NotAssociated.one"),
                ]
            ),
            #line: TestCase(
                input: .anyEnum(
                    type: EnumStub.AssociatedBySameKeys.self,
                    caseName: EnumCaseName("one"),
                    associated: [
                        .labeled(label: "key", value: .string("value")),
                    ]
                ),
                expected: [
                    .line("AssociatedBySameKeys.one("),
                    .indent(.line("key: \"value\"")),
                    .line(")"),
                ]
            ),
            #line: TestCase(
                input: .anyEnum(
                    type: EnumStub.Nested.self,
                    caseName: EnumCaseName("two"),
                    associated: [
                        .labeled(
                            label: "key",
                            value: .anyEnum(
                                type: EnumStub.Nested.self,
                                caseName: EnumCaseName("two"),
                                associated: [
                                    .labeled(
                                        label: "key",
                                        value: .anyEnum(
                                            type: EnumStub.Nested.self,
                                            caseName: EnumCaseName("one"),
                                            associated: [
                                                .labeled(
                                                    label: "key",
                                                    value: .string("value")
                                                )
                                            ]
                                        )
                                    )
                                ]
                            )
                        )
                    ]
                ),
                expected: [
                    .line("Nested.two("),
                    .indent(.line("key: Nested.two(")),
                    .indent(.indent(.line("key: Nested.one("))),
                    .indent(.indent(.indent(.line("key: \"value\"")))),
                    .indent(.indent(.line(")"))),
                    .indent(.line(")")),
                    .line(")"),
                ]
            ),
            #line: TestCase(
                input: .anyStruct(
                    type: StructStub.Empty.self,
                    entries: [:]
                ),
                expected: [
                    .line("struct Empty {}"),
                ]
            ),
            #line: TestCase(
                input: .anyStruct(
                    type: StructStub.TwoEntries.self,
                    entries: [
                        "key1": .string("value1"),
                        "key2": .string("value2"),
                    ]
                ),
                expected: [
                    .line("struct TwoEntries {"),
                    .indent(.line("key1: \"value1\"")),
                    .indent(.line("key2: \"value2\"")),
                    .line("}"),
                ]
            ),
            #line: TestCase(
                input: .anyStruct(
                    type: StructStub.Nested.self,
                    entries: [
                        "key1": .string("value1"),
                        "key2": .anyStruct(
                            type: StructStub.Nested.self,
                            entries: [
                                "key1": .string("value1"),
                                "key2": .anyStruct(
                                    type: StructStub.Nested.self,
                                    entries: [
                                        "key1": .string("value1"),
                                        "key2": .string("value2")
                                    ]
                                )
                            ]
                        )
                    ]
                ),
                expected: [
                    .line("struct Nested {"),
                    .indent(.line("key1: \"value1\"")),
                    .indent(.line("key2: struct Nested {")),
                    .indent(.indent(.line("key1: \"value1\""))),
                    .indent(.indent(.line("key2: struct Nested {"))),
                    .indent(.indent(.indent(.line("key1: \"value1\"")))),
                    .indent(.indent(.indent(.line("key2: \"value2\"")))),
                    .indent(.indent(.line("}"))),
                    .indent(.line("}")),
                    .line("}"),
                ]
            ),
            #line: TestCase(
                input: .anyClass(
                    type: ClassStub.Empty.self,
                    entries: [:]
                ),
                expected: [
                    .line("class Empty {}"),
                ]
            ),
            #line: TestCase(
                input: .anyClass(
                    type: ClassStub.TwoEntries.self,
                    entries: [
                        "key1": .string("value1"),
                        "key2": .string("value2"),
                    ]
                ),
                expected: [
                    .line("class TwoEntries {"),
                    .indent(.line("key1: \"value1\"")),
                    .indent(.line("key2: \"value2\"")),
                    .line("}"),
                ]
            ),
            #line: TestCase(
                input: .anyClass(
                    type: ClassStub.Nested.self,
                    entries: [
                        "key1": .string("value1"),
                        "key2": .anyClass(
                            type: ClassStub.Nested.self,
                            entries: [
                                "key1": .string("value1"),
                                "key2": .anyClass(
                                    type: ClassStub.Nested.self,
                                    entries: [
                                        "key1": .string("value1"),
                                        "key2": .string("value2")
                                    ]
                                )
                            ]
                        )
                    ]
                ),
                expected: [
                    .line("class Nested {"),
                    .indent(.line("key1: \"value1\"")),
                    .indent(.line("key2: class Nested {")),
                    .indent(.indent(.line("key1: \"value1\""))),
                    .indent(.indent(.line("key2: class Nested {"))),
                    .indent(.indent(.indent(.line("key1: \"value1\"")))),
                    .indent(.indent(.indent(.line("key2: \"value2\"")))),
                    .indent(.indent(.line("}"))),
                    .indent(.line("}")),
                    .line("}"),
                ]
            ),
            // TODO: Generic
        ]


        testCases.forEach { (line, testCase) in
            let actual = testCase.input.prettyLines
            let expected = testCase.expected

             XCTAssertEqual(
                 actual, expected,
                 diff(between: expected, and: actual),
                 line: line
             )
        }
    }


    static var allTests: [(String, (DiffablePrettyPrintableTests) -> () throws -> Void)] {
        return [
            ("testPrettyLine", self.testPrettyLines),
        ]
    }
}


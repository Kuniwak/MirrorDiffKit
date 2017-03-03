import XCTest
@testable import MirrorDiffKit


class Diffable_PrettyPrintableTests: XCTestCase {
    private struct TestCase {
        let input: Diffable.Diff
        let expected: String
    }


    func testPrettyLines() {
        let testCases: [UInt: TestCase] = [
            #line: TestCase(
                input: Diffable.Diff(
                    units: []
                ),
                expected: ""
            ),
            #line: TestCase(
                input: Diffable.Diff(
                    units: [
                        .notChanged(.string("I'm not changed"))
                    ]
                ),
                expected: "  \"I'm not changed\""
            ),
            #line: TestCase(
                input: Diffable.Diff(
                    units: [
                        .deleted(.string("I'm deleted"))
                    ]
                ),
                expected: "- \"I'm deleted\""
            ),
            #line: TestCase(
                input: Diffable.Diff(
                    units: [
                        .inserted(.string("I'm inserted"))
                    ]
                ),
                expected: "+ \"I'm inserted\""
            ),
            #line: TestCase(
                input: Diffable.Diff(
                    units: [
                        .child(kind: .dictionary, [
                            "child": Diffable.Diff(units: [])
                        ])
                    ]
                ),
                expected: "  []"
            ),
            #line: TestCase(
                input: Diffable.Diff(
                    units: [
                        .child(kind: .anyStruct(type: StructStub.Empty.self), [
                            "child": Diffable.Diff(units: [])
                        ])
                    ]
                ),
                expected: "  struct Empty {}"
            ),
            #line: TestCase(
                input: Diffable.Diff(
                    units: [
                        .child(kind: .anyClass(type: ClassStub.Empty.self), [
                            "child": Diffable.Diff(units: [])
                        ])
                    ]
                ),
                expected: "  class Empty {}"
            ),
            #line: TestCase(
                input: Diffable.Diff(
                    units: [
                        .child(kind: .dictionary, [
                            "child": Diffable.Diff(units: [
                                .notChanged(.string("I'm not changed")),
                            ])
                        ])
                    ]
                ),
                expected: [
                    "  [",
                    "      child: \"I'm not changed\"",
                    "  ]"
                ].joined(separator: "\n")
            ),
            #line: TestCase(
                input: Diffable.Diff(
                    units: [
                        .child(kind: .dictionary, [
                            "child": Diffable.Diff(units: [
                                .deleted(.string("I'm deleted")),
                            ])
                        ])
                    ]
                ),
                expected: [
                    "  [",
                    "    - child: \"I'm deleted\"",
                    "  ]"
                ].joined(separator: "\n")
            ),
            #line: TestCase(
                input: Diffable.Diff(
                    units: [
                        .child(kind: .dictionary, [
                            "child": Diffable.Diff(units: [
                                .inserted(.string("I'm inserted")),
                            ])
                        ])
                    ]
                ),
                expected: [
                    "  [",
                    "    + child: \"I'm inserted\"",
                    "  ]"
                ].joined(separator: "\n")
            ),
            #line: TestCase(
                input: Diffable.Diff(
                    units: [
                        .child(kind: .dictionary, [
                            "child": Diffable.Diff(units: [
                                .deleted(.string("I'm deleted")),
                                .inserted(.string("I'm inserted")),
                                .notChanged(.string("I'm not changed")),
                            ]),
                        ])
                    ]
                ),
                expected: [
                    "  [",
                    "    - child: \"I'm deleted\"",
                    "    + child: \"I'm inserted\"",
                    "      child: \"I'm not changed\"",
                    "  ]"
                ].joined(separator: "\n")
            ),
        ]


        testCases.forEach { (line, testCase) in
            let actual = testCase.input.description
            XCTAssertEqual(actual, testCase.expected, line: line)
        }
    }



    static var allTests : [(String, (Diffable_PrettyPrintableTests) -> () throws -> Void)] {
        return [
            ("testPrettyLines", self.testPrettyLines),
        ]
    }
}
import XCTest
@testable import MirrorDiffKit


class DifferentiaUnit_PrettyPrintableTests: XCTestCase {
    private struct TestCase {
        let input: DifferentiaUnit
        let expected: String
    }


    func testPrettyLines() {
        let testCases: [UInt: TestCase] = [
            #line: TestCase(
                input: .notChanged(.string(type: String.self, content: "I'm not changed")),
                expected: "  \"I'm not changed\""
            ),

            #line: TestCase(
                input: .deleted(.string(type: String.self, content: "I'm deleted")),
                expected: "- \"I'm deleted\""
            ),

            #line: TestCase(
                input: .inserted(.string(type: String.self, content: "I'm inserted")),
                expected: "+ \"I'm inserted\""
            ),

            #line: TestCase(
                input: .dictionaryChanged(kind: .dictionary, [
                    "child": [],
                ]),
                expected: "  []"
            ),

            #line: TestCase(
                input: .dictionaryChanged(
                    kind: .anyStruct(type: StructStub.Empty.self),
                    [
                        "child": [],
                    ]
                ),
                expected: "  struct Empty {}"
            ),

            #line: TestCase(
                input: .dictionaryChanged(
                    kind: .anyClass(type: ClassStub.Empty.self),
                    [
                        "child": [],
                    ]
                ),
                expected: "  class Empty {}"
            ),

            #line: TestCase(
                input: .dictionaryChanged(
                    kind: .dictionary,
                    [
                        "child": [
                            .notChanged(.string(type: String.self, content: "I'm not changed")),
                        ],
                    ]
                ),
                expected: [
                    "  [",
                    "      child: \"I'm not changed\"",
                    "  ]"
                ].joined(separator: "\n")
            ),

            #line: TestCase(
                input: .dictionaryChanged(
                    kind: .dictionary,
                    [
                        "child": [
                            .deleted(.string(type: String.self, content: "I'm deleted")),
                        ],
                    ]
                ),
                expected: [
                    "  [",
                    "    - child: \"I'm deleted\"",
                    "  ]"
                ].joined(separator: "\n")
            ),

            #line: TestCase(
                input: .dictionaryChanged(
                    kind: .dictionary,
                    [
                        "child": [
                            .inserted(.string(type: String.self, content: "I'm inserted")),
                        ]
                    ]
                ),
                expected: [
                    "  [",
                    "    + child: \"I'm inserted\"",
                    "  ]"
                ].joined(separator: "\n")
            ),

            #line: TestCase(
                input: .dictionaryChanged(
                    kind: .dictionary,
                    [
                        "changed": [
                            .deleted(.string(type: String.self, content: "I'm deleted")),
                            .inserted(.string(type: String.self, content: "I'm inserted")),
                        ],
                        "notChanged": [
                            .notChanged(.string(type: String.self, content: "I'm not changed")),
                        ],
                    ]
                ),
                expected: [
                    "  [",
                    "    - changed: \"I'm deleted\"",
                    "    + changed: \"I'm inserted\"",
                    "      notChanged: \"I'm not changed\"",
                    "  ]"
                ].joined(separator: "\n")
            ),
            #line: TestCase(
                input: .dictionaryChanged(
                    kind: .dictionary,
                    [
                        "child": [
                            .notChanged(.string(type: String.self, content: "I'm not changed")),
                        ],
                        "grandChild": [
                            .dictionaryChanged(kind: .dictionary, [
                                "deleted": [
                                    .deleted(.string(type: String.self, content: "I'm deleted")),
                                ],
                                "inserted": [
                                    .inserted(.string(type: String.self, content: "I'm inserted")),
                                ],
                                "notChanged": [
                                    .notChanged(.string(type: String.self, content: "I'm not changed")),
                                ],
                            ]),
                        ],
                    ]
                ),
                expected: [
                    "  [",
                    "      child: \"I'm not changed\"",
                    "      grandChild: [",
                    "        - deleted: \"I'm deleted\"",
                    "        + inserted: \"I'm inserted\"",
                    "          notChanged: \"I'm not changed\"",
                    "      ]",
                    "  ]"
                ].joined(separator: "\n")
            ),
        ]


        testCases.forEach { entry in
            let (line, testCase) = entry
            let actual = PrettyPrinter.print(fromLines: testCase.input.prettyLines)
            XCTAssertEqual(actual, testCase.expected, line: line)
        }
    }



    static var allTests : [(String, (DifferentiaUnit_PrettyPrintableTests) -> () throws -> Void)] {
        return [
            ("testPrettyLines", self.testPrettyLines),
        ]
    }
}
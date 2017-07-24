import XCTest
@testable import MirrorDiffKit


class Diffable_PrettyPrintableTests: XCTestCase {
    private struct TestCase {
        let input: Differentia
        let expected: String
    }


    func testPrettyLines() {
        let testCases: [UInt: TestCase] = [
            #line: TestCase(
                input: Differentia(
                    units: []
                ),
                expected: ""
            ),
            #line: TestCase(
                input: Differentia(
                    units: [
                        .notChanged(.string("I'm not changed"))
                    ]
                ),
                expected: "  \"I'm not changed\""
            ),
            #line: TestCase(
                input: Differentia(
                    units: [
                        .deleted(.string("I'm deleted"))
                    ]
                ),
                expected: "- \"I'm deleted\""
            ),
            #line: TestCase(
                input: Differentia(
                    units: [
                        .inserted(.string("I'm inserted"))
                    ]
                ),
                expected: "+ \"I'm inserted\""
            ),
            #line: TestCase(
                input: Differentia(
                    units: [
                        .dictionaryChanged(kind: .dictionary, [
                            "child": Differentia(units: [])
                        ])
                    ]
                ),
                expected: "  []"
            ),
            #line: TestCase(
                input: Differentia(
                    units: [
                        .dictionaryChanged(kind: .anyStruct(type: StructStub.Empty.self), [
                            "child": Differentia(units: [])
                        ])
                    ]
                ),
                expected: "  struct Empty {}"
            ),
            #line: TestCase(
                input: Differentia(
                    units: [
                        .dictionaryChanged(kind: .anyClass(type: ClassStub.Empty.self), [
                            "child": Differentia(units: [])
                        ])
                    ]
                ),
                expected: "  class Empty {}"
            ),
            #line: TestCase(
                input: Differentia(
                    units: [
                        .dictionaryChanged(kind: .dictionary, [
                            "child": Differentia(units: [
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
                input: Differentia(
                    units: [
                        .dictionaryChanged(kind: .dictionary, [
                            "child": Differentia(units: [
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
                input: Differentia(
                    units: [
                        .dictionaryChanged(kind: .dictionary, [
                            "child": Differentia(units: [
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
                input: Differentia(
                    units: [
                        .dictionaryChanged(kind: .dictionary, [
                            "changed": Differentia(units: [
                                .deleted(.string("I'm deleted")),
                                .inserted(.string("I'm inserted")),
                            ]),
                            "notChanged": Differentia(units: [
                                .notChanged(.string("I'm not changed")),
                            ]),
                        ])
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
                input: Differentia(
                    units: [
                        .dictionaryChanged(kind: .dictionary, [
                            "child": Differentia(units: [
                                .notChanged(.string("I'm not changed")),
                            ]),
                            "grandChild": Differentia(units: [
                                .dictionaryChanged(kind: .dictionary, [
                                    "deleted": Differentia(units: [
                                        .deleted(.string("I'm deleted")),
                                    ]),
                                    "inserted": Differentia(units: [
                                        .inserted(.string("I'm inserted")),
                                    ]),
                                    "notChanged": Differentia(units: [
                                        .notChanged(.string("I'm not changed")),
                                    ]),
                                ]),
                            ]),
                        ]),
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
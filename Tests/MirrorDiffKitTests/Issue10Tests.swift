import XCTest
@testable import MirrorDiffKit


class Issue10Tests: XCTestCase {
    struct Example {
        let title: String
        let data: [String]
    }


    func testDiff() {
        let a = Example(
            title: "I'm not changed",
            data: [
                "I'm not changed",
                "I'm not changed",
                "I'm not changed",
                "I'm deleted",
            ]
        )

        let b = Example(
            title: "I'm not changed",
            data: [
                "I'm not changed",
                "I'm not changed",
                "I'm not changed",
                "I'm inserted",
            ]
        )

        XCTAssertEqual(
            diff(between: a, and: b),
            [
                "",
                "  struct Example {",
                "      title: \"I'm not changed\"",
                "      data: [",
                "          \"I'm not changed\"",
                "          \"I'm not changed\"",
                "          \"I'm not changed\"",
                "        - \"I'm deleted\"",
                "        + \"I'm inserted\"",
                "      ]",
                "  }",
                "",
            ].joined(separator: "\n")
        )
    }



    static var allTests: [(String, (Issue10Tests) -> () throws -> Void)] {
        return [
            ("testDiff", self.testDiff),
        ]
    }
}


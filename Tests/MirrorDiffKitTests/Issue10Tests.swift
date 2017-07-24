import XCTest
@testable import MirrorDiffKit


class Issue10Tests: XCTestCase {
    struct Example {
        let data: [String]
        let title: String
    }


    func testDiff() {
        let a = Example(
            data: [
                "I'm not changed",
                "I'm not changed",
                "I'm not changed",
                "I'm deleted",
            ],
            title: "I'm not changed"
        )

        let b = Example(
            data: [
                "I'm not changed",
                "I'm not changed",
                "I'm not changed",
                "I'm inserted",
            ],
            title: "I'm not changed"
        )

        let actual = diff(between: a, and: b)
        let expected = [
            "",
            "  struct Example {",
            "      data: [",
            "          \"I'm not changed\"",
            "          \"I'm not changed\"",
            "          \"I'm not changed\"",
            "        - \"I'm deleted\"",
            "        + \"I'm inserted\"",
            "      ]",
            "      title: \"I'm not changed\"",
            "  }",
            "",
        ].joined(separator: "\n")

        XCTAssertEqual(actual, expected)

        // NOTE: Print verbose info for efficient debugging.
        let wasTestFailed = actual != expected
        if wasTestFailed {
            print("verbose:")
            dump(Diffable.diff(
                between: Diffable.from(any: a),
                and: Diffable.from(any: b)
            ))
        }
    }



    static var allTests: [(String, (Issue10Tests) -> () throws -> Void)] {
        return [
            ("testDiff", self.testDiff),
        ]
    }
}


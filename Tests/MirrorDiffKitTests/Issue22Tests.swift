import XCTest
@testable import MirrorDiffKit


class Issue22Tests: XCTestCase {
    private struct Parent {
        let child: Child?
    }

    private struct Child {}


    func testOptionalStruct() {
        let a = Parent(child: Child())
        let b = Parent(child: nil)

        XCTAssert(a !~ b)

        if a =~ b {
            print("a:")
            dump(a)

            print("b:")
            dump(b)
        }
    }


    static var allTests: [(String, (Issue22Tests) -> () throws -> Void)] {
        return [
            ("testOptionalStruct", self.testOptionalStruct),
        ]
    }
}


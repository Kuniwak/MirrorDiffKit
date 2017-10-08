import XCTest
@testable import MirrorDiffKitTests

XCTMain([
    testCase(DiffableSequenceTests.allTests),
    testCase(DiffableSetTests.allTests),
    testCase(DiffableTests.allTests),
    testCase(DifferentiaUnit_PrettyPrintableTests.allTests),
    testCase(Issue10Tests.allTests),
    testCase(Issue13Tests.allTests),
    testCase(Issue22Tests.allTests),
    testCase(TransformerTests.allTests),
    testCase(MirrorDiffKitDiffTests.allTests),
    testCase(MirrorDiffKitOperatorsTests.allTests),
    testCase(PrettyLineTests.allTests),
    testCase(PrettyLinesTests.allTests),
    testCase(DiffablePrettyPrintableTests.allTests),
    testCase(MirrorDiffKitDrainTests.allTests),
])

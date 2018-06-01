import Foundation

#if os(Linux)
    typealias CGFloatCompatibleWithLinux = CGFloat

    class CGFloat {
        fileprivate let value: Double

        init(_ value: Double) {
            self.value = value
        }
    }

    // SEE: https://github.com/apple/swift/blob/d3cb915abb9af1e8ccfbcfd4515e2b75fc75b5f1/stdlib/public/SDK/CoreGraphics/CGFloat.swift.gyb#L363-L368
    extension CGFloat: CustomReflectable {
        var customMirror: Mirror {
            return Mirror(reflecting: self.value)
        }
    }


    // SEE: https://github.com/apple/swift/blob/d3cb915abb9af1e8ccfbcfd4515e2b75fc75b5f1/stdlib/public/SDK/CoreGraphics/CGFloat.swift.gyb#L370-L376
    extension CGFloat: CustomStringConvertible {
        var description: String {
            return "\(self.value)"
        }
    }


    func createCGFloat(_ value: Double) -> CGFloat {
        return CGFloat(value)
    }
#else
    import CoreGraphics

    typealias CGFloatCompatibleWithLinux = CGFloat

    func createCGFloat(_ value: Double) -> CGFloat {
        return CGFloat(value)
    }
#endif
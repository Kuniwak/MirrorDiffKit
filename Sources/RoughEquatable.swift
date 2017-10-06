import Foundation


public protocol RoughEquatable {
    static func =~ (_ lhs: Self, _ rhs: Self) -> Bool
}


extension RoughEquatable {
    static func !~ (_ lhs: Self, _ rhs: Self) -> Bool {
        return !(lhs =~ rhs)
    }
}
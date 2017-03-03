import Foundation


infix operator =~


public protocol RoughEquatable {
    static func =~ (_ lhs: Self, _ rhs: Self) -> Bool
}
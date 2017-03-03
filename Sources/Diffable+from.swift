import Foundation



extension Diffable {
    public static func from<T: DiffableConvertible>(_ x: T) -> Diffable {
        return x.diffable
    }


    public static func from(any x: Any) -> Diffable {
        return transform(fromAny: x)
    }


    public static func from(mirrorOf x: Any) -> Diffable {
        return transformMirror(of: x)
    }
}

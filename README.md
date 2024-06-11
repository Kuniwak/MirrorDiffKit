![MirrorDiffKit](https://raw.githubusercontent.com/Kuniwak/MirrorDiffKit/master/Documentation/Images/logo.png)
=============

A tool for providing the 2 features for efficient testing:

- Output diff between 2 any types
- Default implementation of Equatable for any types


![](./Documentation/Images/XcodePreview.png)


Usage
-----

### `diff<T>(between: T, and: T)`

```swift
import MirrorDiffKit

// Input 2 structs or classes implements Equatable:
let a = Example(
    key1: "I'm not changed",
    key2: "I'm deleted"
)
let b = Example(
    key1: "I'm not changed",
    key2: "I'm inserted"
)


XCTAssertEqual(a, b, diff(between: a, and: b))

// XCTAssertEqual failed: ("Example(key1: "I\'m not changed", key2: "I\'m deleted")") is not equal to ("Example(key1: "I\'m not changed", key2: "I\'m inserted")") - 
//     struct Example {
//         key1: "I'm not changed"
//       - key2: "I'm deleted"
//       + key2: "I'm inserted"
//     }
```


### `Any =~ Any` and `Any !~ Any`

```swift
import MirrorDiffKit

a = NotEquatable(
    key1: "I'm not changed",
    key2: "I'm deleted"
)
b = NotEquatable(
    key1: "I'm not changed",
    key2: "I'm inserted"
)


XCTAssert(a =~ b, diff(between: a, and: b))

// XCTAssertTrue failed - 
//     struct NotEquatable {
//         key1: "I'm not changed"
//       - key2: "I'm deleted"
//       + key2: "I'm inserted"
//     }
```


Installation
------------

```
.package(url: "https://github.com/Kuniwak/MirrorDiffKit.git")
```


License
-------

[MIT License](./LICENSE)

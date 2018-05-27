![MirrorDiffKit](https://raw.githubusercontent.com/Kuniwak/MirrorDiffKit/master/Documentation/Images/logo.png)
=============

![Swift 4.1 compatible](https://img.shields.io/badge/Swift%20version-4.1-green.svg)
![Swift Package Manager and Carthage and CocoaPods compatible](https://img.shields.io/badge/SPM%20%7C%20Carthage%20%7C%20CocoaPods-compatible-green.svg)
[![v3.0.0](https://img.shields.io/badge/version-3.0.0-blue.svg)](https://github.com/Kuniwak/MirrorDiffKit/releases)
[![MIT license](https://img.shields.io/badge/lisence-MIT-yellow.svg)](https://github.com/Kuniwak/MirrorDiffKit/blob/master/LICENSE)
[![Build Status](https://www.bitrise.io/app/94e8fe199a9a670b/status.svg?token=XaNhf80F5x3pimGVlyPb-w&branch=master)](https://www.bitrise.io/app/94e8fe199a9a670b)


A tool for providing the 2 features for efficient testing:

- Output diff between 2 any types
- Default implementation of Equatable for any types



Usage
-----

### `diff(between: Any, and: Any)`

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
### Swift Package Manager

Add the following line to your `Package.swift`:


```
.Package(url: "https://github.com/Kuniwak/MirrorDiffKit.git")
```



### Carthage

Add the following line to your `Cartfile`:

```
github "Kuniwak/MirrorDiffKit"
```



### CocoaPods

```ruby
pod "MirrorDiffKit"
```

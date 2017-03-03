![MirrorDiffKit](https://raw.githubusercontent.com/Kuniwak/MirrorDiffKit/master/Documentation/Images/logo.png)
=============

![SPM compatible](https://img.shields.io/badge/SPM-compatible-green.svg)
[![v0.0.0](https://img.shields.io/badge/version-0.0.0-blue.svg)](https://github.com/Kuniwak/MirrorDiffKit/releases)
[![MIT license](https://img.shields.io/badge/lisence-MIT-yellow.svg)](https://github.com/Kuniwak/MirrorDiffKit/blob/master/LICENSE)
[![CircleCI](https://circleci.com/gh/Kuniwak/MirrorDiffKit/tree/master.svg?style=shield)](https://circleci.com/gh/Kuniwak/MirrorDiffKit/tree/master)


A tool for providing the 2 features for efficient testing:

- Output diff bewtween 2 any types
- Default implementation of Equatable for any types



Usage
-----

### `diff(between:_, and:_)`

```swift
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


### `RoughEquatable =~ RoughEquatable`

```swift
a = NotEquatable(
    key1: "I'm not changed",
    key2: "I'm deleted"
)
b = NotEquatable(
    key1: "I'm not changed",
    key2: "I'm inserted"
)


XCTAssert(
    Diffable.from(any: a) =~ Diffable.from(any: b),
    diff(between: a, and: b)
)

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

Add the the following line to your `Package.swift`:


```
.Package(url: "https://github.com/Kuniwak/MirrorDiffKit.git")
```

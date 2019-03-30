extension Diffable: PrettyPrintable {
    var prettyLines: [PrettyLine] {
        switch self {
        case .null:
            return [.line("NSNull()")]

        case .none:
            return [.line("nil")]

        case let .string(type: type, content: content):
            if type.actualType == String.self {
                return [.line("\"\(content)\"")]
            }
            return [.line("\(type)(\"\(content)\")")]

        case let .number(type: type, value: value):
            return [.line("\(type)(\(value))")]

        case let .bool(bool):
            return [.line(bool.description)]

        case let .date(date):
            return [.line(String(describing: date))]

        case let .url(url):
            return [.line("\(url.absoluteString)")]

        case let .anyType(type):
            return [.line("\(type).self")]

        case let .tuple(type: _, entries: entries):
            guard !entries.isEmpty else {
                return [.line("()")]
            }

            // NOTE: The expected output format is:
            // (
            //     "single-line"
            //     [
            //         "multiple-lines"
            //         "multiple-lines"
            //     ]
            // )
            //
            // or
            //
            // (
            //     key: "single-line"
            //     key: [
            //         "multiple-lines"
            //         "multiple-lines"
            //     ]
            // )
            let content: [PrettyLine] = entries
                .flatMap { (entry) -> [PrettyLine] in
                    return PrettyLine.addIndentLevel(
                        lines: entry.prettyLines,
                        count: 1
                    )
                }

            let head: PrettyLine = .line("(")
            let tail: PrettyLine = .line(")")

            return [head] + content + [tail]

        case let .collection(type: type, elements: elements):
            guard !elements.isEmpty else {
                return [.line("\(type) []")]
            }

            // NOTE: The expected output format is:
            // T [
            //     "single-line"
            //     T [
            //         "multiple-lines"
            //         "multiple-lines"
            //     ]
            // ]
            let content: [PrettyLine] = elements
                .flatMap { value -> [PrettyLine] in
                return PrettyLine.addIndentLevel(
                    lines: value.prettyLines,
                    count: 1
                )
            }

            let head: PrettyLine = .line("\(type) [")
            let tail: PrettyLine = .line("]")

            return [head] + content + [tail]

        case let .set(type: type, elements: elements):
            guard !elements.isEmpty else {
                return [.line("\(type) []")]
            }

            // NOTE: The expected output format is:
            // Set [
            //     "single-line"
            //     [
            //         "multiple-lines"
            //         "multiple-lines"
            //     ]
            // ]
            let content: [PrettyLine] = elements
                .sorted { String(describing: $0) < String(describing: $1) }
                .flatMap { value -> [PrettyLine] in
                    return PrettyLine.addIndentLevel(
                        lines: value.prettyLines,
                        count: 1
                    )
                }

            let head: PrettyLine = .line("\(type) [")
            let tail: PrettyLine = .line("]")

            return [head] + content + [tail]

        case let .dictionary(type: type, entries: entries):
            guard !entries.isEmpty else {
                return [.line("\(type) [:]")]
            }

            // NOTE: The expected output format is:
            // [
            //      key: "single-line"
            //      key: [
            //          "multiple-lines"
            //          "multiple-lines"
            //      ]
            // ]
            let content: [PrettyLine] = entries
                .map { (entry) -> (key: String, value: Diffable) in
                    return (key: entry.key.description, value: entry.value)
                }
                .sorted { $0.key < $1.key }
                .flatMap { (entry) -> [PrettyLine] in
                    let (key, value) = entry
                    let keyLines: [PrettyLine] = [.line("\(key):")]
                    let valueLines: [PrettyLine] = value.prettyLines

                    return PrettyLine.addIndentLevel(
                        lines: PrettyLine.concatKeyLineAndValueLines(
                            keyLines,
                            and: valueLines,
                            with: " "
                        ),
                        count: 1
                    )
                }

            let head: PrettyLine = .line("\(type) [")
            let tail: PrettyLine = .line("]")

            return [head] + content + [tail]

        case let .anyEnum(type: type, caseName: caseName, associated: associated):
            if associated.isEmpty {
                return [.line("\(type).\(caseName.description)")]
            }

            // NOTE: The expected output format is:
            // MyEnum.myCase(
            //     key: "single-line"
            //     key: [
            //         "multiple-lines"
            //         "multiple-lines"
            //     ]
            // )

            let tuplePart = associated
                .flatMap { (value) -> [PrettyLine] in
                    return PrettyLine.addIndentLevel(
                        lines: value.prettyLines,
                        count: 1
                    )
                }

            let head: PrettyLine = .line("\(type).\(caseName.description)(")
            let tail: PrettyLine = .line(")")

            return [head] + tuplePart + [tail]

        case let .anyStruct(type: type, entries: entries):
            if entries.isEmpty {
                return [.line("struct \(type) {}")]
            }

            // NOTE: The expected output format is:
            // struct MyStruct {
            //     key: "single-line"
            //     key: [
            //         "multiple-lines"
            //         "multiple-lines"
            //     ]
            // }

            let head: PrettyLine = .line("struct \(type) {")
            let tail: PrettyLine = .line("}")

            // XXX: This temporary variable is necessary for Swift 4.0.x.
            //     Type inference could be failed if the temporary variable is nothing.
            let body: [PrettyLine] = childLines(by: entries)

            return [head] + body + [tail]

        case let .anyClass(type: type, entries: entries):
            if entries.isEmpty {
                return [.line("class \(type) {}")]
            }

            // NOTE: The expected output format is:
            // class MyStruct {
            //     key: "single-line"
            //     key: [
            //         "multiple-lines"
            //         "multiple-lines"
            //     ]
            // }

            let head: PrettyLine = .line("class \(type) {")
            let tail: PrettyLine = .line("}")

            // XXX: This temporary variable is necessary for Swift 4.0.x.
            //     Type inference could be failed if the temporary variable is nothing.
            let body: [PrettyLine] = childLines(by: entries)

            return [head] + body + [tail]

        case let .minorCustomReflectable(type: type, content: content):
            switch content {
            case let .empty(description: description):
                return [.line("(unknown) \(type): CustomReflectable { description: \"\(description)\" }")]

            case let .notEmpty(entries: entries):
                // NOTE: The expected output format is:
                // (opaque) MyStruct {
                //     key: "single-line"
                //     key: [
                //         "multiple-lines"
                //         "multiple-lines"
                //     ]
                // }

                let head: PrettyLine = .line("(unknown) \(type): CustomReflectable {")
                let tail: PrettyLine = .line("}")

                // XXX: This temporary variable is necessary for Swift 4.0.x.
                //     Type inference could be failed if the temporary variable is nothing.
                let body: [PrettyLine] = childLines(by: entries)

                return [head] + body + [tail]
            }

        case let .unrecognizable(debugInfo):
            return [.line("unrecognizable<<debugInfo: \(debugInfo)>>")]
        }
    }
}


fileprivate func childLines(by dictionary: [String: Diffable]) -> [PrettyLine] {
    return entries(fromDictionary: dictionary)
        .sorted { $0.key < $1.key }
        .flatMap { (entry) -> [PrettyLine] in
            let (key, value) = entry
            let keyLines: [PrettyLine] = [.line("\(key):")]
            let valueLines: [PrettyLine] = value.prettyLines

            return PrettyLine.addIndentLevel(
                lines: PrettyLine.concatKeyLineAndValueLines(
                    keyLines,
                    and: valueLines,
                    with: " "
                ),
                count: 1
            )
        }
}
extension Diffable: PrettyPrintable {
    var prettyLines: [PrettyLine] {
        switch self {
        case .null:
            return [.line("NSNull()")]

        case .none:
            return [.line("nil")]

        case let .string(string):
            return [.line("\"\(string)\"")]

        case let .number(number):
            return [.line(number.description)]

        case let .bool(bool):
            return [.line(bool.description)]

        case let .date(date):
            return [.line(String(describing: date))]

        case let .url(url):
            return [.line("\(url.absoluteString)")]

        case let .type(type):
            return [.line(String(describing: type))]

        case let .tuple(entries):
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

        case let .array(array):
            guard !array.isEmpty else {
                return [.line("[]")]
            }

            // NOTE: The expected output format is:
            // [
            //     "single-line"
            //     [
            //         "multiple-lines"
            //         "multiple-lines"
            //     ]
            // ]
            let content: [PrettyLine] = array
                .flatMap { value -> [PrettyLine] in
                return PrettyLine.addIndentLevel(
                    lines: value.prettyLines,
                    count: 1
                )
            }

            let head: PrettyLine = .line("[")
            let tail: PrettyLine = .line("]")

            return [head] + content + [tail]

        case let .set(array):
            guard !array.isEmpty else {
                return [.line("Set []")]
            }

            // NOTE: The expected output format is:
            // Set [
            //     "single-line"
            //     [
            //         "multiple-lines"
            //         "multiple-lines"
            //     ]
            // ]
            let content: [PrettyLine] = array
                .sorted { String(describing: $0) < String(describing: $1) }
                .flatMap { value -> [PrettyLine] in
                    return PrettyLine.addIndentLevel(
                        lines: value.prettyLines,
                        count: 1
                    )
                }

            let head: PrettyLine = .line("Set [")
            let tail: PrettyLine = .line("]")

            return [head] + content + [tail]

        case let .dictionary(entries):
            guard !entries.isEmpty else {
                return [.line("[:]")]
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
                    let (key, value) = entry
                    return (key: key.description, value: value)
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

            let head: PrettyLine = .line("[")
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

        case let .anyStruct(type: type, entries: dictionary):
            if dictionary.isEmpty {
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

            let content = entries(fromDictionary: dictionary)
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

            let head: PrettyLine = .line("struct \(type) {")
            let tail: PrettyLine = .line("}")

            return [head] + content + [tail]

        case let .anyClass(type: type, entries: dictionary):
            if dictionary.isEmpty {
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

            let content = entries(fromDictionary: dictionary)
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

            let head: PrettyLine = .line("class \(type) {")
            let tail: PrettyLine = .line("}")

            return [head] + content + [tail]

        case let .generic(type: type, entries: dictionary):
            if dictionary.isEmpty {
                return [.line("generic \(type) {}")]
            }

            // NOTE: The expected output format is:
            // generic T {
            //     key: "single-line"
            //     key: [
            //         "multiple-lines"
            //         "multiple-lines"
            //     ]
            // }

            let content = entries(fromDictionary: dictionary)
                .sorted { $0.key < $1.key }
                .flatMap { entry -> [PrettyLine] in
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

            let head: PrettyLine = .line("generic \(type) {")
            let tail: PrettyLine = .line("}")

            return [head] + content + [tail]

        case let .notSupported(value: x):
            return [.line("notSupported<<value: \(x)>>")]

        case let .unrecognizable(debugInfo):
            return [.line("unrecognizable<<debugInfo: \(debugInfo)>>")]
        }
    }
}
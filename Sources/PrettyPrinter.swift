enum PrettyPrinter {
    static func print(fromLines lines: [PrettyLine]) -> String {
        return lines.map { $0.description }
            .joined(separator: "\n")
    }
}


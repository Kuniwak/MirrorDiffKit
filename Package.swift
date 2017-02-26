import PackageDescription

let package = Package(
    name: "TestDiffKit",
    dependencies: [
		.Package(url: "https://github.com/Kuniwak/Dwifft.git", majorVersion: 0, minor: 6),
    ]
)

import UniformTypeIdentifiers

public nonisolated extension UTType {
  static let starterItem = UTType(exportedAs: "com.example.starter.item", conformingTo: .json)
}

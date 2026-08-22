public protocol ItemServing: Sendable {
  func fetchItems() async throws -> [Item]
}

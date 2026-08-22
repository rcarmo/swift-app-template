public nonisolated protocol ItemServing: Sendable {
  func fetchItems() async throws -> [Item]
}

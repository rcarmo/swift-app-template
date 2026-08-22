public nonisolated struct ItemDeletion: Equatable, Sendable {
  public let item: Item
  public let index: Int

  public init(item: Item, index: Int) {
    self.item = item
    self.index = index
  }
}

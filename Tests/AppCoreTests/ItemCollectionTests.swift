import Foundation
import Testing
@testable import AppCore

struct ItemCollectionTests {
  @Test
  func `normalising preserves service order and replaces duplicate values`() {
    let date = Date(timeIntervalSince1970: 1_000)
    let first = Item(id: "first", title: "Original", summary: "Replace", updatedAt: date)
    let second = Item(id: "second", title: "Second", summary: "Preserve order", updatedAt: date)
    let replacement = Item(id: "first", title: "Replacement", summary: "Latest value", updatedAt: date)

    let normalisedItems = ItemCollection.normalising([first, second, replacement])

    #expect(normalisedItems == [replacement, second])
  }

  @Test
  func `incoming items replace matching identifiers`() {
    let date = Date(timeIntervalSince1970: 1_000)
    let existing = Item(id: "shared", title: "Existing", summary: "Old", updatedAt: date)
    let incoming = Item(id: "shared", title: "Incoming", summary: "New", updatedAt: date)

    let mergedItems = ItemCollection.merging([existing], with: [incoming])

    #expect(mergedItems == [incoming])
  }

  @Test
  func `items use a deterministic order when dates match`() {
    let date = Date(timeIntervalSince1970: 1_000)
    let second = Item(id: "second", title: "Second", summary: "Later ID", updatedAt: date)
    let first = Item(id: "first", title: "First", summary: "Earlier ID", updatedAt: date)

    let mergedItems = ItemCollection.merging([], with: [second, first])

    #expect(mergedItems == [first, second])
  }
}

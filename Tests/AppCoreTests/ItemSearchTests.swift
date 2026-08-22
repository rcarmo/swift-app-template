import Foundation
import Testing
@testable import AppCore

struct ItemSearchTests {
  private let items = [
    Item(title: "Aurora", summary: "Design system"),
    Item(title: "Borealis", summary: "Network client"),
  ]

  @Test
  func `empty query preserves items`() {
    #expect(ItemSearch.filter(items, query: "  ") == items)
  }

  @Test
  func `query matches title using localised search`() {
    #expect(ItemSearch.filter(items, query: "auro").map(\.title) == ["Aurora"])
  }

  @Test
  func `query matches summary`() {
    #expect(ItemSearch.filter(items, query: "network").map(\.title) == ["Borealis"])
  }
}

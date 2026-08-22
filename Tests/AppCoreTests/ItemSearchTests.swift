import Foundation
import Testing
@testable import AppCore

struct ItemSearchTests {
  private let items = [
    Item(title: "Aurora", summary: "Design system"),
    Item(title: "Borealis", summary: "Network client"),
  ]

  @Test
  func emptyQueryPreservesItems() {
    #expect(ItemSearch.filter(items, query: "  ") == items)
  }

  @Test
  func queryMatchesTitleUsingLocalizedSearch() {
    #expect(ItemSearch.filter(items, query: "auro").map(\.title) == ["Aurora"])
  }

  @Test
  func queryMatchesSummary() {
    #expect(ItemSearch.filter(items, query: "network").map(\.title) == ["Borealis"])
  }
}

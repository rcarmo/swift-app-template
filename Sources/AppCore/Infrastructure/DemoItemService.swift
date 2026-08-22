import Foundation

public struct DemoItemService: ItemServing {
  public init() {}

  public func fetchItems() async throws -> [Item] {
    [
      Item(
        id: "plan-first-feature",
        title: "Plan the first feature",
        summary: "Replace this deterministic service with a production dependency.",
        isFavorite: true,
        updatedAt: Date(timeIntervalSince1970: 1_780_000_000)
      ),
      Item(
        id: "design-empty-state",
        title: "Design the empty state",
        summary: "Explain why there is no content and provide a useful next action.",
        updatedAt: Date(timeIntervalSince1970: 1_779_913_600)
      ),
      Item(
        id: "run-accessibility-checks",
        title: "Run accessibility checks",
        summary: "Test Dynamic Type, VoiceOver, keyboard access, contrast, and motion.",
        updatedAt: Date(timeIntervalSince1970: 1_779_827_200)
      ),
    ]
  }
}

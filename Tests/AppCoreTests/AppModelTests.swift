import Foundation
import Testing
@testable import AppCore

@MainActor
struct AppModelTests {
  @Test
  func `load selects the first item`() async {
    let item = Item(title: "Loaded", summary: "From a test service")
    let model = AppModel(itemService: StubItemService(result: .success([item])))

    await model.loadIfNeeded()

    #expect(model.phase == .loaded)
    #expect(model.items == [item])
    #expect(model.selection == item.id)
  }

  @Test
  func `load exposes a user-facing failure`() async {
    let model = AppModel(itemService: StubItemService(items: nil))

    await model.loadIfNeeded()

    #expect(model.phase == .failed("The service is unavailable."))
  }

  @Test
  func `toggle favourite mutates the requested item`() async {
    let item = Item(title: "Favourite", summary: "Toggle this item")
    let model = AppModel(itemService: StubItemService(result: .success([item])))
    await model.loadIfNeeded()

    model.toggleFavorite(for: item.id)

    #expect(model.items.first?.isFavorite == true)
  }

  @Test
  func `import merges items and selects the first import`() {
    let existing = Item(id: "existing", title: "Existing", summary: "Before import")
    let imported = Item(id: "imported", title: "Imported", summary: "From disk")
    let model = AppModel(itemService: StubItemService(items: []), items: [existing], phase: .loaded)

    model.importItems([imported])

    #expect(Set(model.items.map(\.id)) == ["existing", "imported"])
    #expect(model.selection == imported.id)
  }

  @Test
  func `delete selection moves selection to the first remaining item`() {
    let first = Item(id: "first", title: "First", summary: "Keep")
    let second = Item(id: "second", title: "Second", summary: "Delete")
    let model = AppModel(itemService: StubItemService(items: []), items: [first, second], phase: .loaded)
    model.selection = second.id

    model.deleteSelection()

    #expect(model.items == [first])
    #expect(model.selection == first.id)
  }
}

private nonisolated struct StubItemService: ItemServing {
  let items: [Item]?

  init(result: Result<[Item], TestError>) {
    items = try? result.get()
  }

  init(items: [Item]?) {
    self.items = items
  }

  func fetchItems() async throws -> [Item] {
    guard let items else { throw TestError.unavailable }
    return items
  }
}

private nonisolated enum TestError: LocalizedError {
  case unavailable

  var errorDescription: String? {
    "The service is unavailable."
  }
}

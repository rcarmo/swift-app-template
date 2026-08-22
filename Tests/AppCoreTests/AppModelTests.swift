import Foundation
import Testing

@testable import AppCore

@MainActor
struct AppModelTests {
  @Test
  func loadSelectsFirstItem() async {
    let item = Item(title: "Loaded", summary: "From a test service")
    let model = AppModel(itemService: StubItemService(result: .success([item])))

    await model.loadIfNeeded()

    #expect(model.phase == .loaded)
    #expect(model.items == [item])
    #expect(model.selection == item.id)
  }

  @Test
  func loadExposesAUserFacingFailure() async {
    let model = AppModel(itemService: StubItemService(items: nil))

    await model.loadIfNeeded()

    #expect(model.phase == .failed("The service is unavailable."))
  }

  @Test
  func toggleFavoriteMutatesTheRequestedItem() async {
    let item = Item(title: "Favorite", summary: "Toggle this item")
    let model = AppModel(itemService: StubItemService(result: .success([item])))
    await model.loadIfNeeded()

    model.toggleFavorite(for: item.id)

    #expect(model.items.first?.isFavorite == true)
  }
}

private struct StubItemService: ItemServing {
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

private enum TestError: LocalizedError {
  case unavailable

  var errorDescription: String? {
    "The service is unavailable."
  }
}

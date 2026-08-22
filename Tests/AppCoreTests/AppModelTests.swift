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
  func `load hides an unclassified dependency error`() async {
    let model = AppModel(itemService: OpaqueFailureItemService())

    await model.loadIfNeeded()

    #expect(model.phase == .failed("Items couldn’t be loaded. Try again."))
  }

  @Test
  func `cancelling an initial load restores idle state`() async {
    let model = AppModel(itemService: CancelledItemService())

    await model.reload()

    #expect(model.phase == .idle)
    #expect(model.items.isEmpty)
  }

  @Test
  func `cancelling a refresh preserves loaded content`() async {
    let item = Item(id: "existing", title: "Existing", summary: "Preserve this item")
    let model = AppModel(
      itemService: CancelledItemService(),
      items: [item],
      phase: .loaded,
    )

    await model.reload()

    #expect(model.phase == .loaded)
    #expect(model.items == [item])
    #expect(model.selection == item.id)
  }

  @Test
  func `an older reload cannot replace a newer result`() async {
    let service = ControlledItemService()
    let model = AppModel(itemService: service)
    let olderItem = Item(id: "older", title: "Older", summary: "Stale response")
    let newerItem = Item(id: "newer", title: "Newer", summary: "Current response")

    let olderReload = Task { await model.reload() }
    await service.waitForRequestCount(1)
    let newerReload = Task { await model.reload() }
    await service.waitForRequestCount(2)

    await service.succeedRequest(at: 1, with: [newerItem])
    await newerReload.value
    await service.succeedRequest(at: 0, with: [olderItem])
    await olderReload.value

    #expect(model.phase == .loaded)
    #expect(model.items == [newerItem])
    #expect(model.selection == newerItem.id)
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
    let model = AppModel(
      itemService: StubItemService(items: []),
      items: [existing],
      phase: .loaded,
    )

    model.importItems([imported])

    #expect(Set(model.items.map(\.id)) == ["existing", "imported"])
    #expect(model.selection == imported.id)
  }

  @Test
  func `delete selection moves selection to the first remaining item`() {
    let first = Item(id: "first", title: "First", summary: "Keep")
    let second = Item(id: "second", title: "Second", summary: "Delete")
    let model = AppModel(
      itemService: StubItemService(items: []),
      items: [first, second],
      phase: .loaded,
    )
    model.selection = second.id

    model.deleteSelection()

    #expect(model.items == [first])
    #expect(model.selection == first.id)
  }

  @Test
  func `selection moves to the first visible item when filtering hides it`() {
    let first = Item(id: "first", title: "First", summary: "Visible")
    let second = Item(id: "second", title: "Second", summary: "Hidden")
    let model = AppModel(itemService: StubItemService(items: []), items: [first, second], phase: .loaded)
    model.selection = second.id

    model.reconcileSelection(with: [first])

    #expect(model.selection == first.id)
  }

  @Test
  func `empty search results preserve selection for query clearing`() {
    let item = Item(id: "selected", title: "Selected", summary: "Temporarily filtered")
    let model = AppModel(
      itemService: StubItemService(items: []),
      items: [item],
      phase: .loaded,
    )

    model.reconcileSelection(with: [])

    #expect(model.selection == item.id)
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

private nonisolated enum TestError: UserPresentableError {
  case unavailable

  var userMessage: String {
    "The service is unavailable."
  }
}

private nonisolated struct CancelledItemService: ItemServing {
  func fetchItems() async throws -> [Item] {
    throw CancellationError()
  }
}

private nonisolated struct OpaqueFailureItemService: ItemServing {
  func fetchItems() async throws -> [Item] {
    throw CocoaError(.fileReadCorruptFile)
  }
}

private actor ControlledItemService: ItemServing {
  private var requests: [CheckedContinuation<[Item], any Error>] = []
  private var waiters: [(count: Int, continuation: CheckedContinuation<Void, Never>)] = []

  func fetchItems() async throws -> [Item] {
    try await withCheckedThrowingContinuation { continuation in
      requests.append(continuation)
      resumeSatisfiedWaiters()
    }
  }

  func waitForRequestCount(_ count: Int) async {
    guard requests.count < count else { return }
    await withCheckedContinuation { continuation in
      waiters.append((count, continuation))
    }
  }

  func succeedRequest(at index: Int, with items: [Item]) {
    requests[index].resume(returning: items)
  }

  private func resumeSatisfiedWaiters() {
    let satisfiedWaiters = waiters.filter { requests.count >= $0.count }
    waiters.removeAll { requests.count >= $0.count }
    for waiter in satisfiedWaiters {
      waiter.continuation.resume()
    }
  }
}

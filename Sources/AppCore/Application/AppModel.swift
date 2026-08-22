import Foundation
import Observation

@Observable
@MainActor
public final class AppModel {
  public private(set) var items: [Item]
  public private(set) var phase: LoadPhase
  public var selection: Item.ID?

  private let itemService: any ItemServing

  public init(
    itemService: any ItemServing,
    items: [Item] = [],
    phase: LoadPhase = .idle
  ) {
    self.itemService = itemService
    self.items = items
    self.phase = phase
    selection = items.first?.id
  }

  public func loadIfNeeded() async {
    guard phase == .idle else { return }
    await reload()
  }

  public func reload() async {
    phase = .loading

    do {
      let loadedItems = try await itemService.fetchItems()
      items = loadedItems
      if selection.flatMap({ selectedID in loadedItems.first { $0.id == selectedID } }) == nil {
        selection = loadedItems.first?.id
      }
      phase = .loaded
    } catch {
      phase = .failed(error.localizedDescription)
    }
  }

  public func toggleFavorite(for itemID: Item.ID) {
    guard let index = items.firstIndex(where: { $0.id == itemID }) else { return }
    items[index].isFavorite.toggle()
  }
}

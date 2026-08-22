import Foundation
import Observation

@Observable
public final class AppModel {
  public private(set) var items: [Item]
  public private(set) var phase: LoadPhase
  public var selection: Item.ID?

  private let itemService: any ItemServing

  public init(
    itemService: any ItemServing,
    items: [Item] = [],
    phase: LoadPhase = .idle,
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
      replaceItems(with: loadedItems)
      phase = .loaded
    } catch is CancellationError {
      phase = items.isEmpty ? .idle : .loaded
    } catch {
      phase = .failed(error.localizedDescription)
    }
  }

  public func addItem() {
    let item = Item(
      title: "Untitled Item",
      summary: "Replace this placeholder with product-specific creation.",
    )
    items.append(item)
    selection = item.id
    phase = .loaded
  }

  public func importItems(_ importedItems: [Item]) {
    guard !importedItems.isEmpty else { return }

    var itemsByID = Dictionary(uniqueKeysWithValues: items.map { ($0.id, $0) })
    for item in importedItems {
      itemsByID[item.id] = item
    }
    replaceItems(with: itemsByID.values.sorted { $0.updatedAt > $1.updatedAt })
    selection = importedItems.first?.id
    phase = .loaded
  }

  public func deleteSelection() {
    guard let selection else { return }
    items.removeAll { $0.id == selection }
    self.selection = items.first?.id
  }

  public func toggleFavorite(for itemID: Item.ID) {
    guard let index = items.firstIndex(where: { $0.id == itemID }) else { return }
    items[index].isFavorite.toggle()
  }

  private func replaceItems(with loadedItems: [Item]) {
    items = loadedItems
    if selection.flatMap({ selectedID in loadedItems.first { $0.id == selectedID } }) == nil {
      selection = loadedItems.first?.id
    }
  }
}

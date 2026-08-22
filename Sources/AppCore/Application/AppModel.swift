import Foundation
import Observation

@Observable
public final class AppModel {
  public private(set) var items: [Item]
  public private(set) var phase: LoadPhase
  public var selection: Item.ID?

  private let itemService: any ItemServing
  private var reloadGeneration = 0

  public init(
    itemService: any ItemServing,
    items: [Item] = [],
    phase: LoadPhase = .idle,
  ) {
    self.itemService = itemService
    self.items = ItemCollection.normalising(items)
    self.phase = phase
    selection = self.items.first?.id
  }

  public func loadIfNeeded() async {
    guard phase == .idle else { return }
    await reload()
  }

  public func reload() async {
    reloadGeneration += 1
    let generation = reloadGeneration
    phase = .loading

    do {
      let loadedItems = try await itemService.fetchItems()
      guard generation == reloadGeneration else { return }
      replaceItems(with: loadedItems)
      phase = .loaded
    } catch is CancellationError {
      guard generation == reloadGeneration else { return }
      phase = items.isEmpty ? .idle : .loaded
    } catch {
      guard generation == reloadGeneration else { return }
      let message = (error as? any UserPresentableError)?.userMessage
        ?? "Items couldn’t be loaded. Try again."
      phase = .failed(message)
    }
  }

  public func reconcileSelection(with visibleItems: [Item]) {
    guard !visibleItems.isEmpty else { return }
    guard selection.flatMap({ selectedID in
      visibleItems.first { $0.id == selectedID }
    }) == nil else { return }
    selection = visibleItems.first?.id
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

    replaceItems(with: ItemCollection.merging(items, with: importedItems))
    selection = importedItems.first?.id
    phase = .loaded
  }

  @discardableResult
  public func deleteSelection() -> ItemDeletion? {
    guard let selection, let index = items.firstIndex(where: { $0.id == selection }) else {
      return nil
    }

    let deletion = ItemDeletion(item: items[index], index: index)
    items.remove(at: index)
    self.selection = items.indices.contains(index) ? items[index].id : items.last?.id
    return deletion
  }

  public func restore(_ deletion: ItemDeletion) {
    guard !items.contains(where: { $0.id == deletion.item.id }) else {
      selection = deletion.item.id
      return
    }

    items.insert(deletion.item, at: min(deletion.index, items.endIndex))
    selection = deletion.item.id
    phase = .loaded
  }

  public func toggleFavourite(for itemID: Item.ID) {
    guard let index = items.firstIndex(where: { $0.id == itemID }) else { return }
    items[index].isFavourite.toggle()
  }

  private func replaceItems(with loadedItems: [Item]) {
    let normalisedItems = ItemCollection.normalising(loadedItems)
    items = normalisedItems
    if selection.flatMap({ selectedID in normalisedItems.first { $0.id == selectedID } }) == nil {
      selection = normalisedItems.first?.id
    }
  }
}

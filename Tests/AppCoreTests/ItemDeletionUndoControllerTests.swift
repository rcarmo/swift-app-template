import Foundation
import Testing
@testable import AppCore

@MainActor
struct ItemDeletionUndoControllerTests {
  @Test
  func `registered deletion supports undo and redo`() throws {
    let item = Item(id: "item", title: "Item", summary: "Undoable deletion")
    let model = AppModel(
      itemService: UndoItemService(),
      items: [item],
      phase: .loaded,
    )
    let undoManager = UndoManager()
    let controller = ItemDeletionUndoController()
    let deletion = try #require(model.deleteSelection())

    controller.registerDeletion(deletion, in: model, with: undoManager)
    undoManager.undo()

    #expect(model.items == [item])
    #expect(undoManager.canRedo)

    undoManager.redo()

    #expect(model.items.isEmpty)
    #expect(undoManager.canUndo)
  }
}

private nonisolated struct UndoItemService: ItemServing {
  func fetchItems() async throws -> [Item] {
    []
  }
}

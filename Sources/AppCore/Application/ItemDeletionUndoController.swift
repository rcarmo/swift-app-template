import Foundation

final class ItemDeletionUndoController {
  func registerDeletion(
    _ deletion: ItemDeletion,
    in model: AppModel,
    with undoManager: UndoManager,
  ) {
    undoManager.registerUndo(withTarget: self) { [weak model, weak undoManager] controller in
      guard let model, let undoManager else { return }
      controller.restore(deletion, in: model, with: undoManager)
    }
    undoManager.setActionName("Delete Item")
  }

  private func restore(
    _ deletion: ItemDeletion,
    in model: AppModel,
    with undoManager: UndoManager,
  ) {
    model.restore(deletion)
    undoManager.registerUndo(withTarget: self) { [weak model, weak undoManager] controller in
      guard let model, let undoManager else { return }
      controller.delete(deletion.item.id, from: model, with: undoManager)
    }
    undoManager.setActionName("Delete Item")
  }

  private func delete(
    _ itemID: Item.ID,
    from model: AppModel,
    with undoManager: UndoManager,
  ) {
    model.selection = itemID
    guard let deletion = model.deleteSelection() else { return }
    registerDeletion(deletion, in: model, with: undoManager)
  }
}

import AppCore
import SwiftUI

struct StarterCommands: Commands {
  @FocusedValue(\.appActions) private var actions
  @FocusedValue(\.selectedItem) private var selectedItem

  var body: some Commands {
    CommandGroup(after: .newItem) {
      Button("New Item", systemImage: "plus") {
        actions?.addItem()
      }
      .keyboardShortcut("n")
      .disabled(actions == nil)
    }

    CommandGroup(after: .textEditing) {
      Button("Find", systemImage: "magnifyingglass") {
        actions?.focusSearch()
      }
      .keyboardShortcut("f")
      .disabled(actions == nil)
    }

    CommandMenu("Items") {
      Button("Import Items…", systemImage: "square.and.arrow.down") {
        actions?.importItems()
      }
      .keyboardShortcut("o")
      .disabled(actions == nil)

      Button("Export Selected Item…", systemImage: "square.and.arrow.up") {
        actions?.exportSelection()
      }
      .keyboardShortcut("e", modifiers: [.command, .shift])
      .disabled(actions == nil || selectedItem == nil)

      Divider()

      Button("Show Items Table", systemImage: "tablecells") {
        actions?.showItemsTable()
      }
      .keyboardShortcut("t", modifiers: [.command, .option])
      .disabled(actions == nil)
    }
  }
}

import SwiftUI

struct ItemsSidebar: View {
  let items: [Item]
  @Binding var selection: Item.ID?
  let importItems: ([Item]) -> Void
  let deleteItem: (Item.ID) -> Void
  let deleteSelection: () -> Void
  @State private var isDropTargeted = false

  var body: some View {
    List(items, selection: $selection) { item in
      NavigationLink(value: item.id) {
        ItemRow(item: item)
      }
      .tag(item.id)
      .draggable(item)
      .contextMenu {
        Button("Select", systemImage: "checkmark") {
          selection = item.id
        }

        Divider()

        Button("Delete", systemImage: "trash", role: .destructive) {
          deleteItem(item.id)
        }
      }
    }
    .dropDestination(for: Item.self) { importedItems, _ in
      importItems(importedItems)
      return !importedItems.isEmpty
    } isTargeted: { isTargeted in
      isDropTargeted = isTargeted
    }
    .overlay {
      if isDropTargeted {
        RoundedRectangle(cornerRadius: AppTheme.Metrics.cornerRadius)
          .stroke(.tint, lineWidth: 2)
          .padding(AppTheme.Spacing.compact)
          .allowsHitTesting(false)
          .accessibilityHidden(true)
      }
    }
    .navigationTitle("Items")
    .onDeleteCommand(perform: deleteSelection)
    .navigationSplitViewColumnWidth(
      min: AppTheme.Metrics.sidebarMinimum,
      ideal: AppTheme.Metrics.sidebarIdeal,
      max: AppTheme.Metrics.sidebarMaximum,
    )
  }
}

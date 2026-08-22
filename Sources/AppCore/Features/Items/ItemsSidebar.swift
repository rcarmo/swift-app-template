import SwiftUI

struct ItemsSidebar: View {
  let items: [Item]
  @Binding var selection: Item.ID?

  var body: some View {
    List(items, selection: $selection) { item in
      NavigationLink(value: item.id) {
        ItemRow(item: item)
      }
      .tag(item.id)
    }
    .navigationTitle("Items")
    .navigationSplitViewColumnWidth(
      min: AppTheme.Metrics.sidebarMinimum,
      ideal: AppTheme.Metrics.sidebarIdeal,
      max: AppTheme.Metrics.sidebarMaximum
    )
  }
}

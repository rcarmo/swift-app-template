import SwiftUI

struct ItemRow: View {
  let item: Item

  var body: some View {
    HStack(spacing: AppTheme.Spacing.standard) {
      Image(systemName: item.isFavourite ? "star.fill" : "doc.text")
        .foregroundStyle(item.isFavourite ? .yellow : .secondary)
        .accessibilityHidden(true)

      VStack(alignment: .leading, spacing: AppTheme.Spacing.compact / 2) {
        Text(item.title)
          .font(.headline)
        Text(item.summary)
          .font(.subheadline)
          .foregroundStyle(.secondary)
          .lineLimit(2)
      }
    }
    .accessibilityElement(children: .combine)
    .accessibilityLabel(
      item.isFavourite ? "Favourite, \(item.title), \(item.summary)" : "\(item.title), \(item.summary)"
    )
  }
}

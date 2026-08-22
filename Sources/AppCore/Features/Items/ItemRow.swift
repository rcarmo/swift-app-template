import SwiftUI

struct ItemRow: View {
  let item: Item

  var body: some View {
    HStack(spacing: AppTheme.Spacing.standard) {
      Image(systemName: item.isFavorite ? "star.fill" : "doc.text")
        .foregroundStyle(item.isFavorite ? .yellow : .secondary)
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
      item.isFavorite ? "Favorite, \(item.title), \(item.summary)" : "\(item.title), \(item.summary)"
    )
  }
}

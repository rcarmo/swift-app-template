import SwiftUI

struct ItemDetailView: View {
  let item: Item
  let toggleFavorite: () -> Void

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: AppTheme.Spacing.section) {
        Text(item.title)
          .font(.largeTitle)
          .bold()

        Text(item.summary)
          .font(.body)
          .foregroundStyle(.secondary)

        LabeledContent("Last updated") {
          UpdatedAtText(date: item.updatedAt)
        }

        Button(
          item.isFavorite ? "Remove from Favorites" : "Add to Favorites",
          systemImage: item.isFavorite ? "star.slash" : "star",
          action: toggleFavorite,
        )
        .buttonStyle(.borderedProminent)
      }
      .frame(maxWidth: AppTheme.Metrics.readableWidth, alignment: .leading)
      .frame(maxWidth: .infinity, alignment: .center)
      .padding(AppTheme.Spacing.section)
    }
    .navigationTitle(item.title)
  }
}

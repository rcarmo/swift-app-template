#if os(watchOS)
  import SwiftUI

  struct WatchItemDetailView: View {
    @Environment(AppModel.self) private var model
    let item: Item

    var body: some View {
      ScrollView {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.standard) {
          Text(item.summary)
            .foregroundStyle(.secondary)

          Button(
            item.isFavorite ? "Unfavorite" : "Favorite",
            systemImage: item.isFavorite ? "star.slash" : "star"
          ) {
            model.toggleFavorite(for: item.id)
          }
        }
      }
      .navigationTitle(item.title)
    }
  }
#endif

import SwiftUI

struct LoadFailureView: View {
  let message: String
  let retry: () -> Void

  var body: some View {
    ContentUnavailableView {
      Label("Couldn’t Load Items", systemImage: "exclamationmark.triangle")
    } description: {
      Text(message)
    } actions: {
      Button("Try Again", systemImage: "arrow.clockwise", action: retry)
        .buttonStyle(.borderedProminent)
    }
  }
}

import SwiftUI

struct UpdatedAtText: View {
  @AppStorage(AppPreferenceKey.showsRelativeDates) private var showsRelativeDates = true
  let date: Date

  var body: some View {
    if showsRelativeDates {
      Text(date, style: .relative)
    } else {
      Text(date, format: .dateTime.day().month().year())
    }
  }
}

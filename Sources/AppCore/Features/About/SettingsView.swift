import SwiftUI

public struct SettingsView: View {
  @AppStorage("showsRelativeDates") private var showsRelativeDates = true

  public init() {}

  public var body: some View {
    Form {
      Toggle("Show relative dates", isOn: $showsRelativeDates)
    }
    .formStyle(.grouped)
    .padding()
  }
}

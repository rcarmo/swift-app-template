import AppCore
import SwiftUI

@main
struct StarterApp: App {
  @State private var model = AppModel(itemService: DemoItemService())

  var body: some Scene {
    WindowGroup {
      RootContentView()
        .environment(model)
    }

    #if os(macOS)
    Settings {
      SettingsView()
    }
    #endif
  }
}

import AppCore
import SwiftUI

@main
struct StarterApp: App {
  @State private var model = AppModel(itemService: DemoItemService())

  var body: some Scene {
    WindowGroup("Starter", id: "main") {
      RootContentView()
        .environment(model)
    }
    .defaultSize(width: 1000, height: 700)
    .commands {
      StarterCommands()
    }

    Window("Item Inspector", id: "item-inspector") {
      ItemInspectorView()
        .environment(model)
    }
    .defaultSize(width: 420, height: 320)

    Window("Items Table", id: "items-table") {
      ItemsTableView()
        .environment(model)
    }
    .defaultSize(width: 800, height: 500)

    Settings {
      SettingsView()
    }
  }
}

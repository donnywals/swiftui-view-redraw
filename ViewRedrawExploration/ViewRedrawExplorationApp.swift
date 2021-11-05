import SwiftUI

@main
struct ViewRedrawExplorationApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                StateDrivenView()
                    .tabItem {
                        VStack {
                            Image(systemName: "tortoise")
                            Text("State driven")
                        }
                    }
                
                GranularDrivenView()
                    .tabItem {
                        VStack {
                            Image(systemName: "hare")
                            Text("Granular data")
                        }
                    }
            }
        }
    }
}

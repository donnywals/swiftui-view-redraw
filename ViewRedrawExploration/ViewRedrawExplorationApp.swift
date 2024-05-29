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
                
                SimpleListView()
                    .tabItem({
                        VStack {
                            Image(systemName: "hands.sparkles")
                            Text("Simplified data")
                        }
                    })
            }
        }
    }
}

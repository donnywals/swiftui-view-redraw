import SwiftUI
import os.log

let stateLogger = OSLog(subsystem: "com.donnywals.granulardriven", category: "State View")

struct StateDrivenView: View {
    @StateObject var state = StateData.DataSource()
    
    var cellBuilder: (StateData.Item) -> StateDrivenCell = { item in
        os_signpost(.begin, log: stateLogger, name: "cell creation")
        let cell = StateDrivenCell(item: item)
        os_signpost(.end, log: stateLogger, name: "cell creation")
        return cell
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                if case .loaded(let items) = state.state {
                    LazyVStack {
                        ForEach(items) { item in
                            cellBuilder(item)
                        }
                    }
                } else {
                    ProgressView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu(content: {
                        Toggle("Auto toggle", isOn: $state.isAutoggling)
                        
                        Toggle("Update hidden property on toggle", isOn: $state.isMutatingHiddenProperty)
                        
                        Button(action: {
                            state.activateNextItem()
                        }, label: {
                            Text("Activate next item now")
                        })
                        
                        Button(action: {
                            state.reset()
                        }, label: {
                            Text("Reset")
                        })
                    }, label: {
                        Image(systemName: "ellipsis")
                    })
                }
            }
            .navigationTitle(Text("State driven"))
        }
        .onAppear {
            state.loadItems()
        }
    }
}

struct StateDrivenCell: View {
    let item: StateData.Item
    
    // The property below is not part of SwiftUI's "diffing"
//    var randomComputed: Int { Int.random(in: 0..<Int.max) }
    
    // But this one is
//    var randomStored: Int = Int.random(in: 0..<Int.max)
    
    var body: some View {
        let _ = Self._printChanges()
        
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text("identifier:").bold()
                    Text(item.id.uuidString.split(separator: "-").first!)
                }
                Spacer()
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("active state:").bold()
                    Text("is active: \(item.isActive == true ? "✅ yes": "❌ no")")
                }
                Spacer()
            }
            
        }.padding()
    }
}

/*
 By uncommenting this extension we can influence how SwiftUI compares views
 */
//extension StateDrivenCell: Equatable {
//    static func == (lhs: StateDrivenCell, rhs: StateDrivenCell) -> Bool {
//        return lhs.item.id == rhs.item.id && lhs.item.isActive == rhs.item.isActive
//    }
//}

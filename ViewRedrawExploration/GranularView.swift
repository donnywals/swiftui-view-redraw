import SwiftUI
import os.log

let granularLogger = OSLog(subsystem: "com.donnywals.granulardriven", category: "Granular View")

struct GranularDrivenView: View {
    @StateObject var state = GranularData.DataSource()
    
    var cellBuilder: (GranularData.Item) -> GranularDrivenCell = { item in
        os_signpost(.begin, log: granularLogger, name: "cell creation")
        let cell = GranularDrivenCell(item: item)
        os_signpost(.end, log: granularLogger, name: "cell creation")
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
            .navigationTitle(Text("Granular driven"))
        }
        .onAppear {
            state.loadItems()
        }
    }
}

struct GranularDrivenCell: View {
    @ObservedObject var item: GranularData.Item
    
    var body: some View {
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

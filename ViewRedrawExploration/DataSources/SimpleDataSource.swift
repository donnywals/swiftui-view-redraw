import Foundation

class SimpleListItems: ObservableObject {
    @Published var state: SimpleState
    
    private var timer: Timer?
    
    init() {
        let items = (0..<30).map { id in
            return SimpleItem(id: id)
        }
        
        state = .loaded(items)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ _ in
            guard case let .loaded(theItems) = self.state else {
                return
            }
            
            var items = theItems
            
            var i = items[2]
            i.isActive.toggle()
            // i.title = "title: \(UUID().uuidString)"
            items[2] = i
            
            self.state = .loaded(items.map { item in
                var i = item
                i.notShown = UUID()
                return i
            })
        }
    }
}

enum SimpleState {
    case loading
    case loaded([SimpleItem])
}

struct SimpleItem: Identifiable, Equatable {
    let id: Int
    var isActive: Bool
    var aStringValue: String
    var notShown = UUID()
    
    var computed: String {
        return "\(id)" + (isActive ? "yes" : "no")
    }
    
    init(id: Int) {
        self.id = id
        self.isActive = false
        self.aStringValue = "title: \(id)"
    }
    
    static func ==(lhs: SimpleItem, rhs: SimpleItem) -> Bool {
        return lhs.id == rhs.id && lhs.isActive == rhs.isActive
    }
}

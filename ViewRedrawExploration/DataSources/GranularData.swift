import Foundation
enum GranularData {}

extension GranularData {
    class DataSource: ObservableObject {
        @Published var state: State = .loading
        @Published var isAutoggling = false {
            didSet {
                if isAutoggling == true {
                    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                        self?.activateNextItem()
                    }
                } else {
                    timer?.invalidate()
                    timer = nil
                }
            }
        }
        @Published var isMutatingHiddenProperty = false
        
        private var activeIndex: Int?
        private var timer: Timer?
        
        
        func loadItems() {
            self.state = .loaded((0..<10000).map { _ in
                return Item(isActive: false)
            })
        }
        
        func activateNextItem() {
            guard case .loaded(let items) = state else {
                return
            }

            defer {
                if isMutatingHiddenProperty {
                    for item in items {
                        item.nonVisibleProperty = UUID()
                    }
                }
            }
            
            guard let oldIndex = activeIndex, oldIndex + 1 < items.endIndex else {
                activeIndex = 0
                items[activeIndex!].isActive = true
                return
            }

            activeIndex = oldIndex + 1
            
            items[oldIndex].isActive = false
            items[activeIndex!].isActive = true
        }
        
        func reset() {
            guard case .loaded(let items) = state else {
                return
            }
            
            isAutoggling = false
            isMutatingHiddenProperty = false
            
            if let index = activeIndex {
                items[index].isActive = false
            }
            
            activeIndex = nil
        }
    }
}

extension GranularData {
    class Item: Identifiable, ObservableObject {
        @Published var isActive: Bool
        let id = UUID()
        var nonVisibleProperty = UUID()
        
        init(id: UUID = UUID(), isActive: Bool = false, nonVisibleProperty: UUID = UUID()) {
            self.isActive = isActive
        }
    }
}

extension GranularData {
    enum State {
        case loading
        case loaded([Item])
    }
}

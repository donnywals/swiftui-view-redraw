import Foundation
enum StateData {}

extension StateData {
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
            self.state = .loaded((0..<1000).map { _ in
                return Item(isActive: false)
            })
        }
        
        func activateNextItem() {
            guard case .loaded(let items) = state else {
                return
            }

            var itemsCopy = items

            defer {
                if isMutatingHiddenProperty {
                    itemsCopy = itemsCopy.map { item in
                        var copy = item
                        copy.nonVisibleProperty = UUID()
                        return copy
                    }
                }
                
                self.state = .loaded(itemsCopy)
            }
            
            guard let oldIndex = activeIndex, oldIndex + 1 < items.endIndex else {
                activeIndex = 0
                setActiveStateForItem(at: activeIndex!, to: true, in: &itemsCopy)
                return
            }

            activeIndex = oldIndex + 1
            
            setActiveStateForItem(at: oldIndex, to: false, in: &itemsCopy)
            setActiveStateForItem(at: activeIndex!, to: true, in: &itemsCopy)
        }

        func reset() {
            guard case .loaded(let items) = state else {
                return
            }
            
            isAutoggling = false
            isMutatingHiddenProperty = false
            
            if let index = activeIndex {
                var itemsCopy = items
                setActiveStateForItem(at: index, to: false, in: &itemsCopy)
                state = .loaded(itemsCopy)
            }
            
            activeIndex = nil
        }

        private func setActiveStateForItem(at index: Int, to activeState: Bool, in items: inout [Item]) {
            var item = items.remove(at: index)
            item.isActive = activeState
            items.insert(item, at: index)
        }
    }
}

extension StateData {
    struct Item: Identifiable {
        var isActive: Bool
        let id = UUID()
        var nonVisibleProperty = UUID()
        
        init(id: UUID = UUID(), isActive: Bool = false, nonVisibleProperty: UUID = UUID()) {
            self.isActive = isActive
        }
    }
}

extension StateData {
    enum State {
        case loading
        case loaded([Item])
    }
}

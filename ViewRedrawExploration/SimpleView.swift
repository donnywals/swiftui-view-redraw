//
//  SimpleView.swift
//  ViewRedrawExploration
//
//  Created by Donny Wals on 07/11/2021.
//

import SwiftUI

struct SimpleListView: View {
    @StateObject var listItems = SimpleListItems()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    if case let .loaded(items) = listItems.state {
                        ForEach(items) { item in
                            SimpleCellView(item: item)
                        }
                    } else {
                        ProgressView()
                    }
                }
            }
            .navigationTitle(Text("Simple example"))
        }
    }
}

struct SimpleCellView: View {
    let item: SimpleItem
    
    var body: some View {
        VStack {
            HStack {
                Text(item.computed)
                Spacer()
            }
        }.padding()
    }
}

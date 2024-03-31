//
//  RootView.swift
//  BuyHighSellLow
//
//  Created by Jun on 1/4/24.
//

import SwiftUI

struct RootView: View {
  @State
  var selectedTab = 0
  var tabTitles = ["Order Book", "Recent Trades"]
  
  var body: some View {
    NavigationStack {
      VStack(spacing: 13.0) {
        Picker(selection: $selectedTab, label: Text("")) {
          ForEach(tabTitles.indices, id: \.self) { index in
            Text(tabTitles[index]).tag(index)
          }
        }
        .pickerStyle(.segmented).padding(.horizontal, 16.0)
        
        if let view = try? OrderBookView(viewModel: OrderBookViewModel()), selectedTab == 0 {
          view
        } else if selectedTab == 1 {
          Text("recent trades")
        }
      }
      .navigationBarTitleDisplayMode(.inline).navigationTitle("XBT/USD")
    }
  }
}

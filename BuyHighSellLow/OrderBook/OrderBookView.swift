//
//  OrderBookView.swift
//  BuyHighSellLow
//
//  Created by Jun on 31/3/24.
//

import SwiftUI

struct OrderBookView: View {
  var viewModel: OrderBookViewModel
  
  var body: some View {
    VStack(spacing: 5.0) {
      HStack {
        Text("Qty").font(.caption).fontWeight(.medium)
        Spacer()
        Text("Price (USD)").font(.caption).fontWeight(.medium)
        Spacer()
        Text("Qty").font(.caption).fontWeight(.medium)
      }
      .padding(.horizontal, 16.0)
      
      HStack(spacing: 0) {
        List(viewModel.displayingSides.bids) { bid in
          HStack {
            if let displaySize = bid.displaySize {
              Text(displaySize)
                .font(.body)
                .monospaced()
            }
            
            Spacer()
            
            Text(bid.displayPrice)
              .multilineTextAlignment(.trailing)
              .foregroundStyle(Color.buy)
              .font(.body)
              .fontWeight(.semibold)
              .monospaced()
              .padding(.trailing, 5)
          }
          .listRowInsets(EdgeInsets(top: 5, leading: 16.0, bottom: 5, trailing: 0))
          .listRowSeparator(.hidden)
        }
        
        List(viewModel.displayingSides.asks) { ask in
          HStack {
            Text(ask.displayPrice)
              .foregroundStyle(Color.sell)
              .font(.body)
              .fontWeight(.semibold)
              .monospaced()
              .padding(.leading, 5)
            
            Spacer()
            
            if let displaySize = ask.displaySize {
              Text(displaySize)
                .multilineTextAlignment(.trailing)
                .font(.body)
                .monospaced()
            }
          }
          .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 16.0))
          .listRowSeparator(.hidden)
        }
      }
      .environment(\.defaultMinListRowHeight, 0)
      .listStyle(.plain)
    }
    .onAppear {
      viewModel.update(.viewAppeared)
    }
  }
}

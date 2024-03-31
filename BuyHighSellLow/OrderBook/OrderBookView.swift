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
    VStack(spacing: 0) {
      HStack {
        Text("Qty").font(.caption).fontWeight(.medium)
        Spacer()
        Text("Price (USD)").font(.caption).fontWeight(.medium)
        Spacer()
        Text("Qty").font(.caption).fontWeight(.medium)
      }
      .padding(.horizontal, 16.0)
      
      Spacer().frame(height: 5.0)
      Divider()
      
      HStack(spacing: 0) {
        GeometryReader { proxy in
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
                .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 5))
                .background {
                  HStack {
                    Spacer()
                    Color.buy.opacity(0.2)
                      .frame(
                        width: viewModel.calculateAccumatedSizeRatio(
                          size: bid.accumulatedSize,
                          entries: viewModel.displayingSides.bids
                        ) * proxy.size.width / 2
                      )
                  }
                }
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 16.0, bottom: 0, trailing: 0))
            .listRowSeparator(.hidden)
          }
          .animation(.default, value: viewModel.displayingSides.bids)
        }
        
        GeometryReader { proxy in
          List(viewModel.displayingSides.asks) { ask in
            HStack {
              Text(ask.displayPrice)
                .foregroundStyle(Color.sell)
                .font(.body)
                .fontWeight(.semibold)
                .monospaced()
                .padding(EdgeInsets(top: 8, leading: 5, bottom: 8, trailing: 0))
                .background {
                  HStack {
                    Color.sell.opacity(0.2)
                      .frame(
                        width: viewModel.calculateAccumatedSizeRatio(
                          size: ask.accumulatedSize,
                          entries: viewModel.displayingSides.asks
                        ) * proxy.size.width / 2
                      )
                    
                    Spacer()
                  }
                }
              
              Spacer()
              
              if let displaySize = ask.displaySize {
                Text(displaySize)
                  .multilineTextAlignment(.trailing)
                  .font(.body)
                  .monospaced()
              }
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16.0))
            .listRowSeparator(.hidden)
          }
        }
        .animation(.default, value: viewModel.displayingSides.bids)
      }
      .environment(\.defaultMinListRowHeight, 0)
      .listStyle(.plain)
    }
    .onAppear {
      viewModel.update(.viewAppeared)
    }
  }
}

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
      header.padding(.horizontal, 16.0).padding(.bottom, 5.0)
      
      Divider()
      
      Spacer(minLength: 0)
      
      if viewModel.displayingSides.bids.isEmpty, viewModel.displayingSides.asks.isEmpty {
        ProgressView()
        Spacer()
      } else {
        GeometryReader { proxy in
          ScrollView {
            HStack(spacing: 0) {
              buyOrderList(width: proxy.size.width)
                .padding(EdgeInsets(top: 0, leading: 16.0, bottom: 0, trailing: 0))
              
              sellOrderList(width: proxy.size.width)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
            }
          }
        }
      }
    }
    .onAppear {
      viewModel.update(.viewAppeared)
    }.onDisappear {
      viewModel.update(.viewDisappeaered)
    }
  }
  
  private var header: some View {
    HStack {
      Text("Qty").font(.caption).fontWeight(.medium)
      Spacer()
      Text("Price (USD)").font(.caption).fontWeight(.medium)
      Spacer()
      Text("Qty").font(.caption).fontWeight(.medium)
    }
  }
  
  private func buyOrderList(width: CGFloat) -> some View {
    VStack(spacing: 0) {
      ForEach(viewModel.displayingSides.bids) { bid in
        HStack {
          if let displaySize = bid.displaySize {
            Text(displaySize)
              .font(.body)
              .monospaced()
          }
          
          Spacer()
          
          ZStack(alignment: .trailing) {
            Rectangle().fill(Color.buy.opacity(0.2)).frame(
              width: viewModel.calculateAccumatedSizeRatio(
                size: bid.accumulatedSize,
                entries: viewModel.displayingSides.bids
              ) * width / 4
            )
            
            Text(bid.displayPrice)
              .multilineTextAlignment(.trailing)
              .foregroundStyle(Color.buy)
              .font(.body)
              .fontWeight(.semibold)
              .monospaced()
              .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 8))
          }
        }
      }
    }
  }
  
  private func sellOrderList(width: CGFloat) -> some View {
    VStack(spacing: 0) {
      ForEach(viewModel.displayingSides.asks) { ask in
        HStack {
          ZStack(alignment: .leading) {
            Rectangle().fill(Color.sell.opacity(0.2)).frame(
              width: viewModel.calculateAccumatedSizeRatio(
                size: ask.accumulatedSize,
                entries: viewModel.displayingSides.asks
              ) * width / 4
            )
            
            Text(ask.displayPrice)
              .foregroundStyle(Color.sell)
              .font(.body)
              .fontWeight(.semibold)
              .monospaced()
              .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 0))
          }
          
          Spacer()
          
          if let displaySize = ask.displaySize {
            Text(displaySize)
              .multilineTextAlignment(.trailing)
              .font(.body)
              .monospaced()
          }
        }
      }
    }
  }
}

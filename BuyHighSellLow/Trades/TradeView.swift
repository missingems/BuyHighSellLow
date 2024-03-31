//
//  TradeView.swift
//  BuyHighSellLow
//
//  Created by Jun on 1/4/24.
//

import SwiftUI

struct TradeView: View {
  let viewModel: TradeViewModel
  
  @State
  private var listChanged = false
  
  @State
  private var highlightColor = Color.clear
  
  var body: some View {
    VStack(spacing: 0) {
      ZStack {
        HStack {
          Text("Price (USD)")
            .font(.caption)
            .fontWeight(.medium)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
          
          Spacer()
          
          Text("Time")
            .font(.caption)
            .fontWeight(.medium)
            .multilineTextAlignment(.trailing)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        
        Text("Qty")
          .font(.caption)
          .fontWeight(.medium)
          .multilineTextAlignment(.center)
      }
      .padding(.horizontal, 16.0).padding(.bottom, 5.0)
      
      Divider().padding(.leading, 16.0)
      
      List {
        ForEach(viewModel.trades.indices, id: \.self) { index in
          ZStack {
            HStack {
              Text(viewModel.trades[index].displayPrice)
                .font(.body)
                .foregroundStyle(color(for: viewModel.trades[index]))
                .fontWeight(.semibold)
                .monospaced()
                .frame(idealHeight: 36)
                .padding(.trailing, 8.0)
              
              Spacer()
              
              Text(viewModel.trades[index].displaydate?.twentyHoursTimeString() ?? "")
                .font(.body)
                .monospaced()
                .foregroundStyle(color(for: viewModel.trades[index]))
            }
            
            Text(viewModel.trades[index].displaySize ?? "")
              .multilineTextAlignment(.center)
              .font(.body)
              .fontWeight(.semibold)
              .foregroundStyle(color(for: viewModel.trades[index]))
              .monospaced()
              .frame(idealHeight: 36)
              .padding(.trailing, 8.0)
          }
          .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
          .listRowBackground(index == 0 ? highlightColor : .clear)
          .onChange(of: viewModel.trades) { oldValue, newValue in
            if index == 0 {
              highlightColor = color(for: viewModel.trades[index]).opacity(0.2)
              
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                highlightColor = Color.clear
              }
            }
          }
        }
      }
      .listStyle(.plain)
    }
    .onAppear {
      viewModel.update(.viewAppeared)
    }
    .onDisappear {
      viewModel.update(.viewDisappeaered)
    }
  }
  
  private func color(for trade: Trade) -> Color {
    if trade.tickDirection == .plusTick || trade.tickDirection == .zeroPlusTick {
      return Color.buy
    } else {
      return Color.sell
    }
  }
}

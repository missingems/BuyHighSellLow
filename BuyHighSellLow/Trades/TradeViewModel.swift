//
//  TradeViewModel.swift
//  BuyHighSellLow
//
//  Created by Jun on 1/4/24.
//

import Foundation

@Observable
final class TradeViewModel {
  private(set) var trades: [Trade] = []
  private let service: WebSocketService
  
  init() throws {
    service = try WebSocketService(subscription: .recentTrades)
  }
  
  func update(_ action: Action) {
    switch action {
    case .viewAppeared:
      service.connect { [weak self] value in
        self?.didReceiveMessage(value)
      }
      
    case .viewDisappeaered:
      service.disconnect()
    }
  }
  
  private func didReceiveMessage(_ message: String) {
    guard let webSocketMessage = try? Parser<WebSocketMessage<Trade>>().decode(from: message) else {
      return
    }
    
    var trades = self.trades
    
    switch webSocketMessage.action {
    case .insert:
      trades.insert(contentsOf: webSocketMessage.data, at: 0)
      
    case .delete, .update:
      break
      
    case .partial:
      trades = webSocketMessage.data
    }
    
    self.trades = Array(trades.prefix(30))
  }
  
  func calculateAccumatedSizeRatio(size: Double, entries: [OrderBookEntry]) -> Double {
    guard let accumulatedSize = entries.last?.accumulatedSize else {
      return 0
    }
    
    return size / accumulatedSize
  }
}

extension TradeViewModel {
  enum Action {
    case viewAppeared
    case viewDisappeaered
  }
}

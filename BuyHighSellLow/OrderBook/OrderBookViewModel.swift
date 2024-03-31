//
//  OrderBookViewModel.swift
//  BuyHighSellLow
//
//  Created by Jun on 31/3/24.
//

import Foundation

@Observable
final class OrderBookViewModel {
  private(set) var displayingSides: OrderBook.Sides
  private var orderBook: OrderBook?
  private let service: WebSocketService
  
  init() throws {
    displayingSides = OrderBook.Sides()
    service = try WebSocketService(subscription: .orderBook)
    print("init")
  }
  
  func update(_ action: Action) {
    switch action {
    case .viewAppeared:
      print("appea")
      service.connect { [weak self] value in
        self?.didReceiveMessage(value)
      }
      
    case .viewDisappeaered:
      service.disconnect()
    }
  }
  
  private func didReceiveMessage(_ message: String) {
    guard let webSocketMessage = try? Parser<WebSocketMessage<OrderBookEntry>>().decode(from: message) else {
      return
    }
    
    switch webSocketMessage.action {
    case .delete, .insert, .update:
      self.orderBook?.send(newMessage: webSocketMessage)
      self.displayingSides = self.orderBook?.sides ?? OrderBook.Sides()
      
    case .partial:
      self.orderBook = try? OrderBook(webSocketMessage)
      self.displayingSides = self.orderBook?.sides ?? OrderBook.Sides()
      
    }
  }
  
  func calculateAccumatedSizeRatio(size: Double, entries: [OrderBookEntry]) -> Double {
    guard let accumulatedSize = entries.last?.accumulatedSize else {
      return 0
    }
    
    return size / accumulatedSize
  }
}

extension OrderBookViewModel {
  enum Action {
    case viewAppeared
    case viewDisappeaered
  }
}

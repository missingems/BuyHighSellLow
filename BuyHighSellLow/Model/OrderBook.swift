//
//  OrderBook.swift
//  BuyHighSellLow
//
//  Created by Jun on 31/3/24.
//

import Foundation

final class OrderBook {
  struct Sides: Equatable {
    let bids: [OrderBookEntry]
    let asks: [OrderBookEntry]
    
    init(bids: [OrderBookEntry] = [], asks: [OrderBookEntry] = []) {
      self.bids = bids
      self.asks = asks
    }
  }
  
  private(set) var sides = Sides()
  private var entries: [OrderBookEntry] = []
  
  init(_ message: WebSocketMessage<OrderBookEntry>) throws {
    guard message.action == .partial else {
      throw OrderBookError.orderBookInitialiseFromNonPartial
    }
    
    update(with: message)
  }
  
  func send(newMessage: WebSocketMessage<OrderBookEntry>) {
    update(with: newMessage)
  }
  
  private func update(with newMessage: WebSocketMessage<OrderBookEntry>) {
    switch newMessage.action {
    case .delete:
      for data in newMessage.data {
        entries.removeAll(where: { $0.id == data.id })
      }
      
    case .insert:
      entries.append(contentsOf: newMessage.data)
      
    case .partial:
      entries = newMessage.data
      
    case .update:
      for entry in newMessage.data {
        guard let index = entries.firstIndex(where: { $0.id == entry.id }) else {
          return
        }
        
        entries[index] = entry
      }
    }
    
    let bids = Array(entries.filter { $0.side == .buy }.sorted { $0.price > $1.price }.prefix(20))
    let asks = Array(entries.filter { $0.side == .sell }.sorted { $0.price < $1.price }.prefix(20))
    sides = Sides(bids: bids, asks: asks)
  }
}

extension OrderBook {
  enum OrderBookError: Error {
    case orderBookInitialiseFromNonPartial
  }
}

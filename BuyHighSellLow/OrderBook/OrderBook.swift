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
  
  init(_ message: WebSocketMessage<OrderBookEntry>) async throws {
    guard message.action == .partial else {
      throw OrderBookError.orderBookInitialiseFromNonPartial
    }
    
    sides = await update(with: message, existingSides: sides)
  }
  
  func send(newMessage: WebSocketMessage<OrderBookEntry>) async {
    sides = await update(with: newMessage, existingSides: sides)
  }
  
  private func update(
    with newMessage: WebSocketMessage<OrderBookEntry>,
    existingSides: Sides
  ) async -> OrderBook.Sides {
    return await withCheckedContinuation { continuation in
      DispatchQueue.global().async {
        switch newMessage.action {
        case .delete:
          var copiedBids = existingSides.bids
          var copiedAsks = existingSides.asks
          
          for data in newMessage.data {
            copiedBids.removeAll { $0.id == data.id }
            copiedAsks.removeAll { $0.id == data.id }
          }
          
          let newSides = Sides(bids: copiedBids, asks: copiedAsks)
          continuation.resume(returning: newSides)
          
        case .insert:
          var copiedBids = existingSides.bids
          var copiedAsks = existingSides.asks
          
          for data in newMessage.data {
            switch data.side {
            case .buy:
              if let index = copiedAsks.firstIndex(where: { data.price >= $0.price }){
                copiedBids.insert(data, at: index)
              } else {
                copiedBids.append(data)
              }
              
            case .sell:
              if let index = copiedAsks.firstIndex(where: { data.price <= $0.price }) {
                copiedAsks.insert(data, at: index)
              } else {
                copiedAsks.append(data)
              }
            }
          }
          
          let newSides = Sides(bids: copiedBids, asks: copiedAsks)
          continuation.resume(returning: newSides)
          
        case .partial:
          let bids = newMessage.data.filter { $0.side == .buy }.sorted { $0.price > $1.price }
          let asks = newMessage.data.filter { $0.side == .sell }.sorted { $0.price < $1.price }
          let newSides = Sides(bids: bids, asks: asks)
          continuation.resume(returning: newSides)
          
        case .update:
          var copiedBids = existingSides.bids
          var copiedAsks = existingSides.asks
          
          for data in newMessage.data {
            switch data.side {
            case .buy:
              if let index = copiedBids.firstIndex(where: { $0.id == data.id }) {
                copiedBids[index] = data
              }
              
            case .sell:
              if let index = copiedAsks.firstIndex(where: { $0.id == data.id }) {
                copiedAsks[index] = data
              }
            }
          }
          
          let newSides = Sides(bids: copiedBids, asks: copiedAsks)
          continuation.resume(returning: newSides)
        }
      }
    }
  }
}

extension OrderBook {
  enum OrderBookError: Error {
    case orderBookInitialiseFromNonPartial
  }
}

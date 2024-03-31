//
//  OrderBookMessage.swift
//  BuyHighSellLow
//
//  Created by Jun on 31/3/24.
//

struct WebSocketMessage<Model: Decodable & Equatable>: Decodable, Equatable {
  let action: Action
  let data: [Model]
}

extension WebSocketMessage {
  enum Action: String, Decodable, Equatable {
    case delete
    case insert
    case partial
    case update
  }
}

//
//  OrderBook.swift
//  BuyHighSellLow
//
//  Created by Jun on 31/3/24.
//

struct OrderBookEntry: Decodable, Identifiable, Equatable {
  let id: Int
  let price: Double?
  let side: Side
  let size: Int?
  let symbol: String
}

extension OrderBookEntry {
  enum Side: String, Codable, Equatable {
    case sell = "Sell"
    case buy = "Buy"
  }
}

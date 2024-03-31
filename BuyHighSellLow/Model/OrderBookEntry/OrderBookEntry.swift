//
//  OrderBook.swift
//  BuyHighSellLow
//
//  Created by Jun on 31/3/24.
//

struct OrderBookEntry: Decodable, Identifiable, Equatable {
  enum CodingKeys: String, CodingKey {
    case id, price, side, size, symbol
  }
  
  let id: Int
  let price: Double
  let side: Side
  let size: Double?
  let symbol: String
  var accumulatedSize: Double = 0
  
  var displayPrice: String {
    String(format: "%.1f", price)
  }
  
  var displaySize: String? {
    if let size {
      return String(format: "%.4f", size / price)
    } else {
      return nil
    }
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    id = try container.decode(Int.self, forKey: .id)
    price = try container.decodeIfPresent(Double.self, forKey: .price) ?? 0
    side = try container.decode(Side.self, forKey: .side)
    size = try container.decodeIfPresent(Double.self, forKey: .size)
    symbol = try container.decode(String.self, forKey: .symbol)
  }
  
  init(
    id: Int,
    price: Double = 0,
    side: OrderBookEntry.Side,
    size: Double? = nil,
    accumulatedSize: Double = 0,
    symbol: String
  ) {
    self.id = id
    self.price = price
    self.side = side
    self.size = size
    self.accumulatedSize = accumulatedSize
    self.symbol = symbol
  }
}

extension OrderBookEntry {
  enum Side: String, Decodable, Equatable {
    case sell = "Sell"
    case buy = "Buy"
  }
}

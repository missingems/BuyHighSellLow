//
//  Trade.swift
//  BuyHighSellLow
//
//  Created by Jun on 1/4/24.
//

import Foundation

struct Trade: Decodable, Equatable {
  enum CodingKeys: String, CodingKey {
    case timestamp, side, size, price, tickDirection
  }
  
  let timestamp: String
  var displaydate: Date?
  let side: Side?
  let size: Double?
  let price: Double?
  let tickDirection: TickDirection?
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    timestamp = try container.decode(String.self, forKey: .timestamp)
    side = try container.decode(Side.self, forKey: .side)
    size = try container.decode(Double.self, forKey: .size)
    price = try container.decode(Double.self, forKey: .price)
    tickDirection = try container.decode(TickDirection.self, forKey: .tickDirection)
    
    let formatter = ISO8601DateFormatter()
    
    if let timestampDate = formatter.date(from: timestamp) {
      displaydate = timestampDate
    }
  }
  
  init(
    timestamp: String,
    side: Trade.Side? = nil,
    size: Double? = nil,
    price: Double? = nil,
    tickDirection: Trade.TickDirection? = nil
  ) {
    self.timestamp = timestamp
    self.side = side
    self.size = size
    self.price = price
    self.tickDirection = tickDirection
   
    let formatter = ISO8601DateFormatter()
    
    if let timestampDate = formatter.date(from: timestamp) {
      displaydate = timestampDate
    }
  }
}

extension Trade {
  enum Side: String, Decodable, Equatable {
    case sell = "Sell"
    case buy = "Buy"
  }
}

extension Trade {
  enum TickDirection: String, Decodable, Equatable {
    case plusTick = "PlusTick"
    case zeroPlusTick = "ZeroPlusTick"
    case minusTick = "MinusTick"
    case zeroMinusTick = "ZeroMinusTick"
  }
}

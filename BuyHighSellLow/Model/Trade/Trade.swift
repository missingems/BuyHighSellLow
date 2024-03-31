//
//  Trade.swift
//  BuyHighSellLow
//
//  Created by Jun on 1/4/24.
//

import Foundation

struct Trade: Decodable, Equatable, Identifiable {
  enum CodingKeys: String, CodingKey {
    case timestamp, side, size, price, tickDirection, trdMatchID
  }
  
  let id: String?
  let timestamp: String
  var displaydate: Date?
  let side: Side?
  let size: Double?
  let price: Double
  let tickDirection: TickDirection?
  
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
    id = try? container.decodeIfPresent(String.self, forKey: .trdMatchID) ?? UUID().uuidString
    timestamp = try container.decode(String.self, forKey: .timestamp)
    side = try? container.decodeIfPresent(Side.self, forKey: .side)
    size = try? container.decodeIfPresent(Double.self, forKey: .size)
    price = (try? container.decodeIfPresent(Double.self, forKey: .price)) ?? 0
    tickDirection = try? container.decodeIfPresent(TickDirection.self, forKey: .tickDirection)
    
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    
    if let date = dateFormatter.date(from: timestamp) {
      displaydate = date
    }
  }
  
  init(
    id: String,
    timestamp: String,
    side: Trade.Side? = nil,
    size: Double? = nil,
    price: Double = 0,
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
    
    self.id = id
  }
  
  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.id == rhs.id
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

extension Date {
  func twentyHoursTimeString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm:ss"
    return dateFormatter.string(from: self)
  }
}

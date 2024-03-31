//
//  TradeTests.swift
//  BuyHighSellLowTests
//
//  Created by Jun on 1/4/24.
//

import XCTest
@testable import BuyHighSellLow

final class TradeTests: XCTestCase {
  func test_decode() throws {
    let jsonData = try JSONLoader().jsonData(fileName: "trade")
    let entry = try Parser<Trade>().decode(from: jsonData)
    
    let expected = Trade(
      timestamp: "2024-03-31T19:01:27.936Z",
      side: .sell,
      size: 10000,
      price: 72600,
      tickDirection: .minusTick
    )
    
    XCTAssertEqual(entry, expected)
  }
}

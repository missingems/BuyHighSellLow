//
//  OrderBookEntryTests.swift
//  BuyHighSellLowTests
//
//  Created by Jun on 31/3/24.
//

import XCTest
@testable import BuyHighSellLow

final class OrderBookEntryTests: XCTestCase {
  func test_decode_sell() throws {
    let jsonData = try JSONLoader().jsonData(fileName: "orderBookEntrySell")
    let entry = try Parser<OrderBookEntry>().decode(from: jsonData)
    let expected = OrderBookEntry(
      id: 26468923449,
      price: 70623.5,
      side: .sell,
      size: 8400,
      symbol: "XBTUSD"
    )
    
    XCTAssertEqual(entry, expected)
  }
  
  func test_decode_buy() throws {
    let jsonData = try JSONLoader().jsonData(fileName: "orderBookEntryBuy")
    let entry = try Parser<OrderBookEntry>().decode(from: jsonData)
    let expected = OrderBookEntry(
      id: 26468923449,
      price: 70623.5,
      side: .buy,
      size: 8400,
      symbol: "XBTUSD"
    )
    
    XCTAssertEqual(entry, expected)
  }
}

//
//  OrderBookTests.swift
//  BuyHighSellLowTests
//
//  Created by Jun on 31/3/24.
//

import XCTest
@testable import BuyHighSellLow

final class OrderBookTests: XCTestCase {
  func test_partial_sides() async throws {
    let orderBook = try await OrderBook(
      .init(
        action: .partial,
        data: [
          .init(id: 100, price: 100, side: .buy, size: 100, symbol: "TEST"),
          .init(id: 100, price: 100, side: .sell, size: 100, symbol: "TEST")
        ]
      )
    )
        
    XCTAssertEqual(
      try XCTUnwrap(orderBook.sides),
      .init(
        bids: [
          .init(id: 100, price: 100, side: .buy, size: 100, symbol: "TEST"),
        ],
        asks: [
          .init(id: 100, price: 100, side: .sell, size: 100, symbol: "TEST")
        ]
      )
    )
  }
  
  func test_update_sides() async throws {
    let orderBook = try await OrderBook(
      .init(
        action: .partial,
        data: [
          .init(id: 100, price: 100, side: .buy, size: 100, symbol: "TEST"),
          .init(id: 99, price: 100, side: .sell, size: 100, symbol: "TEST")
        ]
      )
    )
    
    await orderBook.send(
      newMessage: .init(
        action: .update,
        data: [
          .init(id: 100, price: 100, side: .buy, size: 100, symbol: "TEST"),
          .init(id: 99, price: 80, side: .sell, size: 100, symbol: "TEST")
        ]
      )
    )
    
    XCTAssertEqual(
      try XCTUnwrap(orderBook.sides),
      .init(
        bids: [
          .init(id: 100, price: 100, side: .buy, size: 100, symbol: "TEST"),
        ],
        asks: [
          .init(id: 99, price: 80, side: .sell, size: 100, symbol: "TEST")
        ]
      )
    )
  }
  
  func test_insert_buy_highPrice_sides() async throws {
    let orderBook = try await OrderBook(
      .init(
        action: .partial,
        data: [
          .init(id: 100, price: 90, side: .buy, size: 100, symbol: "TEST"),
          .init(id: 99, price: 100, side: .sell, size: 100, symbol: "TEST")
        ]
      )
    )
    
    await orderBook.send(
      newMessage: .init(
        action: .insert,
        data: [
          .init(id: 110, price: 100, side: .buy, size: 100, symbol: "TEST"),
        ]
      )
    )
    
    XCTAssertEqual(
      try XCTUnwrap(orderBook.sides),
      .init(
        bids: [
          .init(id: 110, price: 100, side: .buy, size: 100, symbol: "TEST"),
          .init(id: 100, price: 90, side: .buy, size: 100, symbol: "TEST"),
        ],
        asks: [
          .init(id: 99, price: 100, side: .sell, size: 100, symbol: "TEST")
        ]
      )
    )
  }
  
  func test_insert_buy_lowerPrice_sides() async throws {
    let orderBook = try await OrderBook(
      .init(
        action: .partial,
        data: [
          .init(id: 100, price: 100, side: .buy, size: 100, symbol: "TEST"),
          .init(id: 99, price: 100, side: .sell, size: 100, symbol: "TEST")
        ]
      )
    )
    
    await orderBook.send(
      newMessage: .init(
        action: .insert,
        data: [
          .init(id: 110, price: 90, side: .buy, size: 100, symbol: "TEST"),
        ]
      )
    )
    
    XCTAssertEqual(
      try XCTUnwrap(orderBook.sides),
      .init(
        bids: [
          .init(id: 100, price: 100, side: .buy, size: 100, symbol: "TEST"),
          .init(id: 110, price: 90, side: .buy, size: 100, symbol: "TEST"),
        ],
        asks: [
          .init(id: 99, price: 100, side: .sell, size: 100, symbol: "TEST")
        ]
      )
    )
  }
  
  func test_insert_sell_higherPrice_sides() async throws {
    let orderBook = try await OrderBook(
      .init(
        action: .partial,
        data: [
          .init(id: 100, price: 100, side: .buy, size: 100, symbol: "TEST"),
          .init(id: 99, price: 100, side: .sell, size: 100, symbol: "TEST")
        ]
      )
    )
    
    await orderBook.send(
      newMessage: .init(
        action: .insert,
        data: [
          .init(id: 110, price: 200, side: .sell, size: 100, symbol: "TEST"),
        ]
      )
    )
    
    XCTAssertEqual(
      try XCTUnwrap(orderBook.sides),
      .init(
        bids: [
          .init(id: 100, price: 100, side: .buy, size: 100, symbol: "TEST"),
        ],
        asks: [
          .init(id: 99, price: 100, side: .sell, size: 100, symbol: "TEST"),
          .init(id: 110, price: 200, side: .sell, size: 100, symbol: "TEST"),
        ]
      )
    )
  }
  
  func test_insert_sell_lowerPrice_sides() async throws {
    let orderBook = try await OrderBook(
      .init(
        action: .partial,
        data: [
          .init(id: 100, price: 100, side: .buy, size: 100, symbol: "TEST"),
          .init(id: 99, price: 100, side: .sell, size: 100, symbol: "TEST")
        ]
      )
    )
    
    await orderBook.send(
      newMessage: .init(
        action: .insert,
        data: [
          .init(id: 110, price: 90, side: .sell, size: 100, symbol: "TEST"),
        ]
      )
    )
    
    XCTAssertEqual(
      try XCTUnwrap(orderBook.sides),
      .init(
        bids: [
          .init(id: 100, price: 100, side: .buy, size: 100, symbol: "TEST"),
        ],
        asks: [
          .init(id: 110, price: 90, side: .sell, size: 100, symbol: "TEST"),
          .init(id: 99, price: 100, side: .sell, size: 100, symbol: "TEST"),
        ]
      )
    )
  }
  
  func test_delete_sides() async throws {
    let orderBook = try await OrderBook(
      .init(
        action: .partial,
        data: [
          .init(id: 100, price: 100, side: .buy, size: 100, symbol: "TEST"),
          .init(id: 99, price: 100, side: .sell, size: 100, symbol: "TEST")
        ]
      )
    )
    
    await orderBook.send(
      newMessage: .init(
        action: .delete,
        data: [
          .init(id: 100, price: 100, side: .buy, size: 100, symbol: "TEST"),
          .init(id: 99, price: 80, side: .sell, size: 100, symbol: "TEST")
        ]
      )
    )
    
    XCTAssertEqual(try XCTUnwrap(orderBook.sides), .init(bids: [], asks: []))
  }
}

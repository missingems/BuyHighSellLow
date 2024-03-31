//
//  WebSocketMessageTests.swift
//  BuyHighSellLowTests
//
//  Created by Jun on 31/3/24.
//

import XCTest
@testable import BuyHighSellLow

final class WebSocketMessageTests: XCTestCase {
  func test_decode_withData() throws {
    let jsonData = try JSONLoader().jsonData(fileName: "orderBookMessageWithData")
    let message = try Parser<WebSocketMessage<OrderBookEntry>>().decode(from: jsonData)
    
    let expectedBookEntry = OrderBookEntry(
      id: 26468923449,
      price: 70623.5,
      side: .buy,
      size: 8400,
      symbol: "XBTUSD"
    )
    
    let expectedMessage = WebSocketMessage<OrderBookEntry>(
      action: .partial,
      data: [expectedBookEntry]
    )
    
    XCTAssertEqual(message, expectedMessage)
  }
  
  func test_decode_allActionTyes() throws {
    let jsonData = try JSONLoader().jsonData(fileName: "orderBookMessage")
    let messages = try Parser<[WebSocketMessage<OrderBookEntry>]>().decode(from: jsonData)
    
    let expectedMessages = [
      WebSocketMessage<OrderBookEntry>(
        action: .partial,
        data: []
      ),
      WebSocketMessage<OrderBookEntry>(
        action: .update,
        data: []
      ),
      WebSocketMessage<OrderBookEntry>(
        action: .insert,
        data: []
      ),
      WebSocketMessage<OrderBookEntry>(
        action: .delete,
        data: []
      )
    ]
    
    XCTAssertEqual(messages, expectedMessages)
  }
}

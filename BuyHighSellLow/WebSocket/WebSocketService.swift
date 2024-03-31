//
//  WebSocketService.swift
//  BuyHighSellLow
//
//  Created by Jun on 31/3/24.
//

import Foundation
import Starscream

final class WebSocketService: WebSocketDelegate {
  private let socket: WebSocket
  private let subscription: Subscription
  private var updateHandler: (String) -> Void
  
  init(subscription: Subscription, _ update: @escaping (String) -> Void) throws {
    guard let url = URL(string: "wss://www.bitmex.com/realtime") else {
      throw WebSocketServiceError.invalidURL
    }
    
    self.subscription = subscription
    updateHandler = update
    socket = WebSocket(request: URLRequest(url: url))
    socket.delegate = self
    socket.connect()
  }
  
  func didReceive(
    event: WebSocketEvent,
    client: any WebSocketClient
  ) {
    switch event {
    case .connected:
      socket.write(string: subscription.subscriptionMessage)
      
    case let .text(value):
      updateHandler(value)
      
    case .binary, .disconnected, .ping, .pong, .viabilityChanged, .reconnectSuggested, .cancelled, .peerClosed, .error:
      break
    }
  }
}

extension WebSocketService {
  enum WebSocketServiceError: Error {
    case invalidURL
  }
}

extension WebSocketService {
  enum Subscription {
    case orderBook
    
    var subscriptionMessage: String {
      switch self {
      case .orderBook:
        return "{\"op\": \"subscribe\", \"args\": [\"orderBookL2_25:XBTUSD\"]}"
      }
    }
  }
}

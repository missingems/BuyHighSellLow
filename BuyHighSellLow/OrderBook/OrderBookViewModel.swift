//
//  OrderBookViewModel.swift
//  BuyHighSellLow
//
//  Created by Jun on 31/3/24.
//

import Foundation
import Starscream

@Observable
final class OrderBookViewModel {
  var sides: OrderBook.Sides
  
  init() {
    sides = OrderBook.Sides()
  }
  
  func update(_ action: Action) {
    switch action {
    case .viewAppeared:
      break
      
    case .viewDisappeaered:
      break
    }
  }
}

extension OrderBookViewModel {
  enum Action {
    case viewAppeared
    case viewDisappeaered
  }
}

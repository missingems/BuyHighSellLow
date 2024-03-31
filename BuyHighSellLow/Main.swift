//
//  BuyHighSellLowApp.swift
//  BuyHighSellLow
//
//  Created by Jun on 31/3/24.
//

import SwiftUI

@main
struct Main: App {
  private var content: OrderBookView?
  private var errorView: Text?
  
  init() {
    do {
      let rootViewModel = try OrderBookViewModel()
      content = OrderBookView(viewModel: rootViewModel)
    } catch {
      errorView = Text("\(error.localizedDescription)")
    }
  }
  
  var body: some Scene {
    WindowGroup {
      if let content {
        content
      }
      
      if let errorView {
        errorView
      }
    }
  }
}


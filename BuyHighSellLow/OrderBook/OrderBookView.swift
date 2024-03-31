//
//  OrderBookView.swift
//  BuyHighSellLow
//
//  Created by Jun on 31/3/24.
//

import SwiftUI

struct OrderBookView: View {
  var viewModel: OrderBookViewModel
  
  var body: some View {
    List(viewModel.displayingSides.bids) { bids in
      Text("\(bids.price)")
    }
    .onAppear {
      viewModel.update(.viewAppeared)
    }
  }
}

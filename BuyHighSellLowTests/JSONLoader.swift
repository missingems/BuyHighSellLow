//
//  JSONLoader.swift
//  BuyHighSellLowTests
//
//  Created by Jun on 31/3/24.
//

import Foundation

struct JSONLoader {
  func jsonData(fileName: String) throws -> Data {
    guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
      throw JSONLoaderError.jsonNotFound
    }
    
    return try Data(contentsOf: url)
  }
}

extension JSONLoader {
  enum JSONLoaderError: Error {
    case jsonNotFound
  }
}

//
//  Parser.swift
//  BuyHighSellLow
//
//  Created by Jun on 31/3/24.
//

import Foundation

struct Parser<Model: Decodable> {
  func decode(from data: Data) throws -> Model {
    let decoder = JSONDecoder()
    
    do {
      let models = try decoder.decode(Model.self, from: data)
      return models
    } catch {
      throw error
    }
  }
  
  func decode(from jsonString: String) throws -> Model {
    let jsonData = Data(jsonString.utf8)
    let decoder = JSONDecoder()
    
    do {
      let message = try decoder.decode(Model.self, from: jsonData)
      return message
    } catch {
      throw error
    }
  }
}

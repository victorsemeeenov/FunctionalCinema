//
//  CodableList.swift
//  FunctionalCinema
//
//  Created by Victor on 21.03.2020.
//  Copyright © 2020 Victor. All rights reserved.
//

import Foundation

class CodableList<Value: CustomCodable>: List<Value>, CustomCodable {
  required init(from decodableType: DecodableType) throws {
    switch decodableType {
    case .list(let list):
      super.init(list.compactMap { element -> Value? in
        if let hashTable = element as? HashTable<String> {
          return try Value(from: .hashTable(hashTable))
        } else if let list = element as? List<Any> {
          return try Value(from: .list(list))
        } else {
          throw CoderError.cantDecode
        }
      })
    default:
      throw CoderError.cantDecode
    }
  }
  
  override init(_ list: List<Value>) {
    super.init(list)
  }
  
  override init(_ list: [Value]) {
    super.init(list)
  }
  
  func encode() -> DecodableType {
    return .list(self.map({ element -> Any in
      return element as Any
    }))
  }
}

//
//  Director.swift
//  FunctionalCinema
//
//  Created by Victor on 21.03.2020.
//  Copyright © 2020 Victor. All rights reserved.
//

import Foundation

private struct Keys {
  static var id: String {
    return "id"
  }
  static var name: String {
    return "name"
  }
}

struct Director: StorageEntity {
  let id: String
  let name: String
  
  init(from decodableType: DecodableType) throws {
    switch decodableType {
    case .hashTable(let hashTable):
      guard let id = hashTable.value(for: Keys.id) as? String,
        let name = hashTable.value(for: Keys.name) as? String else {
          throw CoderError.cantDecode
      }
      self.id = id
      self.name = name
    default:
      throw CoderError.cantDecode
    }
  }
  
  func encode() -> DecodableType {
    return .hashTable(HashTable<String>(capacity: 2)
      .set(value: id, for: Keys.id)
      .set(value: name, for: Keys.name))
  }
}

// MARK: - Equatable

extension Director: Equatable {
  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.id == rhs.id
  }
}

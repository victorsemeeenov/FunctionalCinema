//
//  Film.swift
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
  static var rating: String {
    return "rating"
  }
  static var directorID: String {
    return "directorID"
  }
  static var genreID: String {
    return "genreID"
  }
}

struct Film: StorageEntity {
  let id: String
  let name: String
  let rating: Float
  let directorID: String
  let genreID: String
  
  init(from decodableType: DecodableType) throws {
    switch decodableType {
    case .hashTable(let hashTable):
      guard let id = hashTable.value(for: Keys.id) as? String,
        let name = hashTable.value(for: Keys.name) as? String,
        let rating = hashTable.value(for: Keys.rating) as? Float,
        let directorID = hashTable.value(for: Keys.directorID) as? String,
        let genreID = hashTable.value(for: Keys.genreID) as? String else {
          throw CoderError.cantDecode
      }
      self.id = id
      self.name = name
      self.rating = rating
      self.directorID = directorID
      self.genreID = genreID
    default:
      throw CoderError.cantDecode
    }
  }
  
  func encode() -> DecodableType {
    return .hashTable(HashTable<String>(capacity: 5).set(value: id, for: Keys.id)
      .set(value: name, for: Keys.name)
      .set(value: rating, for: Keys.rating)
      .set(value: directorID, for: Keys.directorID)
      .set(value: genreID, for: Keys.genreID))
  }
}

// MARK: - Equatable

extension Film: Equatable {
  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.id == rhs.id
  }
}

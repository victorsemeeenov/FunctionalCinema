//
//  Seance.swift
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
  static var filmID: String {
    return "filmID"
  }
  static var price: String {
    return "price"
  }
  static var freeSeetsCount: String {
    return "freeSeetsCount"
  }
  static var day: String {
    return "day"
  }
  static var time: String {
    return "time"
  }
}

struct Seance: StorageEntity  {
  let id: String
  let filmID: String
  let price: Float
  let freeSeetsCount: Int
  let day: Day
  let time: Time
  
  
  init(from decodableType: DecodableType) throws {
    switch decodableType {
    case .hashTable(let hashTable):
      guard let id = hashTable.value(for: Keys.id) as? String,
        let filmID = hashTable.value(for: Keys.filmID) as? String,
        let price = hashTable.value(for: Keys.price) as? Float,
        let freeSeetsCount = hashTable.value(for: Keys.freeSeetsCount) as? Int,
        let timeString = hashTable.value(for: Keys.time) as? String,
        let timeData = timeString.data(using: .utf8),
        let time: Time = try? CustomCoder().decode(data: timeData),
        let dayRawValue = hashTable.value(for: Keys.day) as? Int,
        let day = Day(rawValue: dayRawValue) else {
          throw CoderError.cantDecode
      }
      self.id = id
      self.filmID = filmID
      self.price = price
      self.freeSeetsCount = freeSeetsCount
      self.time = time
      self.day = day
    default:
      throw CoderError.cantDecode
    }
  }
  
  func encode() -> DecodableType {
    return .hashTable(HashTable<String>(capacity: 4)
      .set(value: id, for: Keys.id)
      .set(value: filmID, for: Keys.filmID)
      .set(value: price, for: Keys.price))
      
  }
}

// MARK: - Equatable

extension Seance: Equatable {
  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.id == rhs.id
  }
}


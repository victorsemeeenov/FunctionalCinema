//
//  Time.swift
//  FunctionalCinema
//
//  Created by Victor on 22.03.2020.
//  Copyright © 2020 Victor. All rights reserved.
//

import Foundation

private var minHours: Int {
  return 8
}

private var maxHours: Int {
  return 24
}

private var minMinutes: Int {
  return 0
}

private var maxMinutes: Int {
  return 60
}

infix operator +

private struct Keys {
  static var hours: String {
    return "hours"
  }
  static var minutes: String {
    return "minutes"
  }
}

struct Time: CustomCodable {
  var hours: Int
  var minutes: Int
  
  init(from decodableType: DecodableType) throws {
    switch decodableType {
    case .hashTable(let hashtable):
      guard let hours = hashtable.value(for: Keys.hours) as? Int,
        let minutes = hashtable.value(for: Keys.minutes) as? Int else {
          throw CoderError.cantDecode
      }
      self.hours = hours
      self.minutes = minutes
    default:
      throw CoderError.cantDecode
    }
  }
  
  init(hours: Int, minutes: Int) throws {
    if minutes < minMinutes {
      throw TimeError.minutesLowerThanMin
    } else if minutes > maxMinutes {
      throw TimeError.minutesHigherThanMax
    } else if hours < minHours {
      throw TimeError.hoursLowerThanMin
    } else if hours > maxHours {
      throw TimeError.hoursHigherThanMax
    }
    self.hours = hours
    self.minutes = minutes
  }
  
  func encode() throws -> DecodableType {
    return .hashTable(HashTable<String>(capacity: 2)
      .set(value: hours,
           for: Keys.hours)
      .set(value: minutes,
           for: Keys.minutes))
  }
  
  private func addHours(_ hours: Int) throws -> Time {
    return try Time(hours: self.hours + hours, minutes: minutes)
  }
  
  private func addMinutes(_ minutes: Int) throws -> Time {
    return try Time(hours: hours + ((self.minutes + minutes) / maxMinutes),
                    minutes: (self.minutes + minutes) % maxMinutes)
  }
  
  static func +(lhs: Time, rhs: Time) throws -> Time {
    return try lhs.addHours(rhs.hours).addMinutes(rhs.minutes)
  }
}

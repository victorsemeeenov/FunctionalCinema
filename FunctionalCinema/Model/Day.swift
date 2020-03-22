//
//  Day.swift
//  FunctionalCinema
//
//  Created by Victor on 22.03.2020.
//  Copyright © 2020 Victor. All rights reserved.
//

import Foundation

enum Day: Int, Comparable {
  case monday
  case tuesday
  case wednesday
  case thursday
  case friday
  case saturday
  case sunday
  
  var string: String {
    switch self {
    case .monday:
      return "Понедельник"
    case .tuesday:
      return "Вторник"
    case .wednesday:
      return "Среда"
    case .thursday:
      return "Четверг"
    case .friday:
      return "Пятница"
    case .saturday:
      return "Суббота"
    case .sunday:
      return "Воскресенье"
    }
  }
  
  static func < (lhs: Day, rhs: Day) -> Bool {
    return lhs.rawValue < rhs.rawValue
  }
}

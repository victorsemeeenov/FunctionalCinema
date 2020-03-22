//
//  TimeError.swift
//  FunctionalCinema
//
//  Created by Victor on 22.03.2020.
//  Copyright © 2020 Victor. All rights reserved.
//

import Foundation

enum TimeError: Error {
  case minutesHigherThanMax
  case minutesLowerThanMin
  case hoursHigherThanMax
  case hoursLowerThanMin
}

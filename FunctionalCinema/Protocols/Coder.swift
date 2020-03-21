//
//  Coder.swift
//  FunctionalCinema
//
//  Created by Victor on 21.03.2020.
//  Copyright © 2020 Victor. All rights reserved.
//

import Foundation

protocol Coder {
  func decode<T: CustomCodable>(data: Data) throws -> T
  func encode<T: CustomCodable>(_ object: T) throws -> Data
}

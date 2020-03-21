//
//  StorageEntity.swift
//  FunctionalCinema
//
//  Created by Victor on 22.03.2020.
//  Copyright © 2020 Victor. All rights reserved.
//

import Foundation

protocol StorageEntity: CustomCodable, Equatable {
  var id: String { get }
}

extension StorageEntity {
  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.id == rhs.id
  }
}

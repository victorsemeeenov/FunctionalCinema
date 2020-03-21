//
//  DecodableType.swift
//  FunctionalCinema
//
//  Created by Victor on 21.03.2020.
//  Copyright © 2020 Victor. All rights reserved.
//

import Foundation

enum DecodableType {
  case list(List<Any>)
  case hashTable(HashTable<String>)
  
  var description: String {
    switch self {
    case .list(let list):
      return list.description
    case .hashTable(let hashTable):
      return hashTable.description
    }
  }
}

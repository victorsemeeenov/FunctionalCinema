//
//  CustomCodable.swift
//  FunctionalCinema
//
//  Created by Victor on 21.03.2020.
//  Copyright © 2020 Victor. All rights reserved.
//

import Foundation

protocol CustomCodable: CustomStringConvertible {
  init(from decodableType: DecodableType) throws
  func encode() throws -> DecodableType
}

// MARK: - Encode

//extension CustomCodable {
//  func encode() -> DecodableType {
//    return .hashTable(encode(with: List(Mirror(reflecting: self).children.map { $0 }),
//                             hashTable: HashTable<String>(capacity: 10)))
//  }
//  
//  private func encode(with children: List<Mirror.Child>,
//                      hashTable: HashTable<String>) -> HashTable<String> {
//    if children.isEmpty {
//      return hashTable
//    } else {
//      if let label = children.car()?.label {
//        return encode(with: children.cdr() ?? List([]),
//                      hashTable: hashTable.set(value: String(describing: children.car()?.value),
//                      for: label))
//      } else {
//        return encode(with: children.cdr() ?? List([]),
//                      hashTable: hashTable)
//      }
//    }
//  }
//}

// MARK: - String description

extension CustomCodable {
  var description: String {
    do {
      switch try self.encode() {
      case .hashTable(let hashTable):
        return hashTable.description
      case .list(let list):
        return list.description
      }
    } catch {
      return "nil"
    }
  }
}

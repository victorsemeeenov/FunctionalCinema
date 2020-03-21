//
//  CustomCoder.swift
//  FunctionalCinema
//
//  Created by Victor on 21.03.2020.
//  Copyright © 2020 Victor. All rights reserved.
//

import Foundation

struct CustomCoder: Coder {
  func decode<T>(data: Data) throws -> T where T : CustomCodable {
    if let string = String(data: data, encoding: .utf8),
      let decodedString = decode(string) {
      return try T(from: decodedString)
    } else {
      throw CoderError.cantDecode
    }
  }
  
  func encode<T>(_ object: T) throws -> Data where T : CustomCodable {
    if let encoded = try object.encode().description.data(using: .utf8) {
      return encoded
    } else {
      throw CoderError.cantEncode
    }
  }
  
  private func decode(_ string: String) -> DecodableType? {
    if List<Character>(string: string).car() == "[" {
      return .hashTable(decodeDict(from: string))
    } else if List<Character>(string: string).car() == "(" {
      return .list(decodeList(from: string))
    } else {
      return .none
    }
  }
  
  private func decodeList(from string: String) -> List<Any> {
    return string
      .without(strings: List("(", ")"))
      .split(by: "[", endSeparator: "]")
      .combine { list -> List<Any> in
        return list.reduce(List<Any>([]), { (accList, elementString) -> List<Any> in
          print(elementString)
          switch decode(elementString.trimmingCharacters(in: .whitespacesAndNewlines)) {
          case .hashTable(let hashTable):
            print("hashtable: \(hashTable)")
            return accList.append(value: hashTable)
          case .list(let decodedList):
            return accList.append(value: decodedList)
          case .none:
            return accList.append(value: elementString)
          }
        })
    }
  }
  
  private func decodeDict(from string: String) -> HashTable<String> {
    return string
    .without(strings: List("[", "]"))
    .split(by: ",")
    .combine { list -> HashTable<String> in
      return list.reduce(HashTable<String>(capacity: list.count), { (hashTable, keyValueString) -> HashTable<String> in
        guard let (key, value) = decode(keyValue: keyValueString) else {
          return hashTable
        }
        switch decode(value) {
        case .hashTable(let hashTable):
          return hashTable.set(value: hashTable, for: key)
        case .list(let list):
          return hashTable.set(value: list, for: key)
        case .none:
          return hashTable.set(value: value, for: key)
        }
      })
    }
  }
  
  private func decode(keyValue: String) -> (key: String, value: String)? {
    return decode(keyValueList: keyValue.split(by: ":"))
  }
  
  private func decode(keyValueList: List<String>) -> (key: String, value: String)? {
    guard let key = keyValueList.car()?
      .trimmingCharacters(in: .whitespacesAndNewlines),
      let value = keyValueList.cdr()?.car()?
        .trimmingCharacters(in: .whitespacesAndNewlines) else {
            return nil
    }
    return (key, value)
  }
}

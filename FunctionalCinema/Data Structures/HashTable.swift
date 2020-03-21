//
//  HashTable.swift
//  FunctionalCinema
//
//  Created by Victor on 21.03.2020.
//  Copyright © 2020 Victor. All rights reserved.
//

import Foundation

struct HashTable<Key: Hashable>: DataStructure {
  enum Types {
    case int(Int?)
    case string(String?)
    case float(Float?)
    case double(Double?)
  }
  
  var description: String {
    return "[ " + (buckets.reduce("", { (acc, elements) -> String in
      return description(from: elements).joined(", ")
    })) + " ]"
  }
  
  private func description(from elements: List<Element>) -> List<String> {
    return elements.map { (key, value) -> String in
      return key is String ? "\"\(key)\": \(value)" : "\(key): \(value)"
    }
  }
  
  private typealias Element = (key: Key, value: Any)
  private typealias Bucket = List<Element>
  private let buckets: List<Bucket>

  private let count: Int
  public var isEmpty: Bool {
    return count == 0
  }

  init(capacity: Int){
    buckets = .init(repeating: .init([]), count: capacity)
    self.count = 0
  }
  
  private init(count: Int,
               buckets: List<Bucket>) {
    self.buckets = buckets
    self.count = count
  }
  
  private func index(for key: Key) -> Int {
    return abs(key.hashValue) % buckets.count
  }
  
  func value(for key: Key) -> Any? {
    return buckets[index(for: key)]?
      .firstWhere { $0.key == key }?
      .value
  }
  
  func keyValues() -> List<(key: Key, value: Any)> {
    guard let keyValue = buckets.car()?.car() else {
      return .init([])
    }
    guard let bucketsCdr = buckets.cdr() else {
      if let cdr = buckets.car()?.cdr() {
        return .init(head: keyValue,
                     tail: HashTable(count: count - 1,
                                     buckets: buckets.replace(where: { _ in true },
                      with: cdr)).keyValues())
      } else {
        return .init(head: keyValue)
      }
    }
    if let cdr = buckets.car()?.cdr() {
      return .init(head: keyValue,
                   tail: HashTable(count: count - 1,
                                   buckets: buckets.replace(where: { _ in true },
                                                            with: cdr)).keyValues())
    } else {
      return .init(head: buckets.car()?.car(),
                   tail: HashTable(count: count - 1,
                                   buckets: bucketsCdr).keyValues())
    }
  }
  
  func set(value: Any, for key: Key) -> HashTable {
    if let value = value as? String {
      return privateSet(value: value, for: key)
    } else if let value = value as? Int {
      return privateSet(value: value, for: key)
    } else if let value = value as? HashTable {
      return privateSet(value: value, for: key)
    } else if let value = value as? Float {
      return privateSet(value: value, for: key)
    } else if let value = value as? Double {
      return privateSet(value: value, for: key)
    } else {
      return privateSet(value: value, for: key)
    }
  }
  
  private func privateSet(value: Any, for key: Key) -> HashTable {
    guard let _ = buckets[index(for: key)]?
      .firstWhere({ bucket in
        return bucket.key == key
      }) else {
        return HashTable(count: count + 1,
                         buckets: buckets
                          .enumerated()
                          .map { (idx, bucket) -> Bucket in
                            if idx == index(for: key) {
                              return bucket.append(value: (key: key, value: value))
                            } else {
                              return bucket
                            }
                          })
    }
    return HashTable(count: count,
                     buckets: buckets.map { bucket -> Bucket in
                      return bucket.replace(where: { (k, v) -> Bool in
                        return k == key
                      }, with: (key: key, value: value))
                     })
  }
  
  func merge(with hashTable: HashTable) -> HashTable {
    return privateMerge(with: hashTable.keyValues())
  }

  private func privateMerge(with keyValuesList: List<(key: Key, value: Any)>) -> HashTable {
    guard let (key, value) = keyValuesList.car() else {
      return self
    }
    if let cdr = keyValuesList.cdr() {
      return set(value: value, for: key).privateMerge(with: cdr)
    } else {
      return set(value: value, for: key)
    }
  }
}

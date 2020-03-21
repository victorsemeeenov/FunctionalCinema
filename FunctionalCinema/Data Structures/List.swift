//
//  List.swift
//  FunctionalCinema
//
//  Created by Victor on 21.03.2020.
//  Copyright © 2020 Victor. All rights reserved.
//

import Foundation

class List<Value>: DataStructure {
  private let head: Value?
  private let tail: List?
  let count: Int
  
  init(head: Value? = nil, tail: List? = nil) {
    self.head = head
    self.tail = tail?.isEmpty ?? true ? nil : tail
    self.count = tail?.count ?? 0 + 1
  }
  
  convenience init(_ list: Value...) {
    self.init(list)
  }
  
  init(_ list: [Value]) {
    self.head = list.first
    self.tail = list.dropFirst().isEmpty ? nil : List(Array(list.dropFirst()))
    self.count = list.count
  }
  
  init(_ list: List) {
    self.head = list.head
    self.tail = list.tail
    self.count = list.count
  }
  
  init(repeating value: Value, count: Int) {
    if count == 1 {
      self.head = value
      self.tail = nil
      self.count = 1
    } else {
      self.head = value
      self.tail = List(repeating: value, count: count - 1)
      self.count = tail?.count ?? 0 + 1
    }
  }
  
  static func empty() -> List {
    return List(head: nil)
  }
  
  var description: String {
    return "(" + (reduce("") { (acc, node) -> String in
      return acc + " " + stringRepresent(node)
      }) + " )"
  }
  
  func stringRepresent(_ value: Value) -> String {
    return "\(value)"
  }
  
  var isEmpty: Bool {
    return head == nil
  }
  
  func append(value: Value) -> List {
    guard let head = head else { return List(value) }
    guard let tail = tail else {
      return List(head: head, tail: List(value))
    }
    return List(head: head, tail: tail.append(value: value))
  }
  
  func append(contentsOf list: List) -> List {
    if let listHead = list.car() {
      return append(value: listHead).append(contentsOf: list.cdr() ?? List([]))
    } else {
      return self
    }
  }
  
  func car() -> Value? {
    return head
  }
  
  func cdr() -> List? {
    return tail
  }
  
  public subscript(index: Int) -> Value? {
    get {
      return element(at: index)
    }
  }
  
  private func element(at index: Int) -> Value? {
    if index == 0 {
      return head
    } else {
      return tail?.element(at: index - 1)
    }
  }
  
  func remove(at index: Int) -> List<Value> {
    if index == 0 {
      if let tail = tail {
        return tail
      } else {
        return List([])
      }
    }
    if index == 1 {
      return List(head: head, tail: tail?.tail)
    } else {
      return List(head: head, tail: tail?.remove(at: index - 1))
    }
  }
  
  func replace(at index: Int, with value: Value) -> List<Value> {
    if index == 0,
       let _ = head {
      return List(head: value, tail: tail)
    }
    guard let tail = tail else {
      return List(head: head)
    }
    if index == 1 {
      return List(head: head,
                  tail: List(head: value, tail: tail.tail))
    } else {
      return tail.replace(at: index - 1, with: value)
    }
  }
  
  func replace(where predicate: (Value) -> Bool, with value: Value) -> List {
    guard let head = head else { return List([]) }
    if predicate(head) {
      return List(head: value, tail: tail?.replace(where: predicate, with: value))
    } else {
      return List(head: head, tail: tail?.replace(where: predicate, with: value))
    }
  }
  
  private func nextElement() -> Value? {
    return tail?.head
  }
}

// MARK: - List operations
extension List {
  func map<NewType>(_ transform: (Value) -> NewType) -> List<NewType> {
    guard let head = head else { return List<NewType>([]) }
    return .init(head: transform(head), tail: tail?.map(transform))
  }
  
  func compactMap<NewType>(_ transform: (Value) throws -> NewType?) -> List<NewType> {
    guard let head = head else { return List<NewType>([]) }
    guard let tail = tail else {
      do {
        if let newValue = try transform(head) {
          return List<NewType>(head: newValue)
        } else {
          return List<NewType>([])
        }
      } catch {
        return List<NewType>([])
      }
    }
    do {
      guard let newValue = try transform(head) else {
        return tail.compactMap(transform)
      }
      return List<NewType>(head: newValue, tail: tail.compactMap(transform))
    } catch {
      return tail.compactMap(transform)
    }
  }
  
  func filter(_ predicate: (Value) -> Bool) -> List {
    guard let head = head else { return List<Value>([]) }
    guard let tail = tail else { return predicate(head) ? List(head) : List([])}
    return predicate(head) ?
      List(head: head, tail: tail.filter(predicate)) :
      tail.filter(predicate)
  }
  
  func reduce<NewType>(_ initialValue: NewType,
                       _ combine: ((NewType, Value) -> NewType)) -> NewType {
    guard let head = head else { return initialValue }
    guard let tail = tail else { return combine(initialValue, head) }
    return tail.reduce(combine(initialValue, head),
                  combine)
  }
  
  func firstWhere(_ predicate: ((Value) -> Bool)) -> Value? {
    guard let head = head else { return nil}
    return predicate(head) ? head : tail?.firstWhere(predicate)
  }
  
  func combine<NewType>(_ combine: (List) -> NewType) -> NewType {
    return combine(self)
  }
  
  func enumerated() -> List<(Int, Value)> {
    return privateEnumerated()
  }
  
  func removeAll(where predicate: (Value) -> Bool) -> List {
    guard let head = head else { return List([])}
    return predicate(head) ?
      (tail ?? List([])).removeAll(where: predicate) :
      listWithout(predicate: predicate)
  }
  
  func removeFirst(where predicate: (Value) -> Bool) -> List {
    guard let head = head else { return List([])}
    return predicate(head) ?
      tail ?? List([]) :
      listWithoutFirst(predicate: predicate)
  }
  
  func removeLast(where predicate: (Value) -> Bool) -> List {
    return reversed().removeFirst(where: predicate).reversed()
  }
  
  func reversed() -> List {
    guard let _ = head else {
      return List([])
    }
    return privateReversed()
  }
  
  private func privateReversed(newList: List = .init([])) -> List {
    guard let head = head else {
      return newList
    }
    guard let tail = tail else {
      return List(head: head, tail: newList)
    }
    return tail.privateReversed(newList: List(head: head, tail: newList))
  }
  
  private func listWithout(predicate: (Value) -> (Bool)) -> List<Value> {
    guard let nextElement = nextElement() else { return List(head: head) }
    return predicate(nextElement) ?
      List(head: head, tail: tail?.tail?.listWithout(predicate: predicate)) :
      List(head: head, tail: tail?.listWithout(predicate: predicate))
  }
  
  private func listWithoutFirst(predicate: (Value) -> Bool) -> List<Value> {
    guard let nextElement = nextElement() else { return List(head: head) }
    return predicate(nextElement) ?
      List(head: head, tail: tail?.tail):
      List(head: head, tail: tail?.listWithoutFirst(predicate: predicate))
  }
  
  private func privateEnumerated(index: Int = 0) -> List<(Int, Value)> {
    guard let head = head else { return .init([])}
    return index == count - 1 ?
      List<(Int, Value)>(head: (index, head)) :
      List<(Int, Value)>(head: (index, head), tail: tail?.privateEnumerated())
  }
}

// MARK: - List equatable

extension List where Value: Equatable {
  func remove(value: Value) -> List<Value> {
    return value == head ? tail ?? List([]) : listWithoutValue(value: value)
  }
  
  func contains(value: Value) -> Bool {
    return head == value ? true : tail?.contains(value: value) ?? false
  }
  
  func removeIfContains(values: List<Value>) -> List {
    guard let head = head else {
      return List([])
    }
    return values.contains(value: head) ?
      List(head: tail?.head, tail: tail?.tail?.removeIfContains(values: values)) :
      List(head: head, tail: tail?.removeIfContains(values: values))
  }
  
  func removeIfContains(value: Value) -> List {
    guard let head = head else {
      return List([])
    }
    return head == value ?
      List(head: tail?.head, tail: tail?.tail?.removeIfContains(value: value)) :
      List(head: head, tail: tail?.removeIfContains(value: value))
  }
  
  private func listWithoutValue(value: Value) -> List<Value> {
    guard let nextElement = nextElement() else { return List(head: head) }
    return value == nextElement ?
      List(head: head, tail: tail?.tail?.listWithoutValue(value: value)) :
      List(head: head, tail: tail?.listWithoutValue(value: value))
  }
}

// MARK: - Char list
extension List where Value == Character {
  convenience init<S: Sequence>(string: S) where S.Element == Character {
    self.init(Array(string))
  }
  
  func string(untilString str: String) -> (firstPart: List<Character>,
                                           endPart: List<Character>) {
    if str == car()?.description {
      return (List([]), tail ?? List([]))
    } else {
      let res = tail?.string(untilString: str)
      return (List(head: head, tail: res?.firstPart),
              res?.endPart ?? List([]))
    }
  }
  
  var string: String {
    return "\(car() ?? Character(""))\(tail?.string ?? "")"
  }
}

// MARK: - List string operation

extension List where Value == String {
  func joined(_ separator: String) -> String {
    return reduce("") { (acc, element) -> String in
      return acc.isEmpty ? element : "\(acc)\(separator)" + element
    }
  }
}

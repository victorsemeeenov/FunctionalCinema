//
//  String+Extensions.swift
//  FunctionalCinema
//
//  Created by Victor on 21.03.2020.
//  Copyright © 2020 Victor. All rights reserved.
//

import Foundation

extension String {
  func split(by separator: String) -> List<String> {
    return List(self.components(separatedBy: separator))
  }
  
  func split(by separator: String, or otherSeparator: String) -> List<String> {
    if self.contains(separator) {
      return split(by: separator)
    } else {
      return split(by: otherSeparator)
    }
  }
  
  func split(by beginSeparator: String, endSeparator: String) -> List<String> {
    if List<Character>(string: self).car()?.description == beginSeparator {
      return privateSplit(List<Character>(string: self).string(untilString: endSeparator),
                       beginSeparator: beginSeparator,
                       endSeparator: endSeparator)
    } else {
      return List(self)
    }
  }
  
  private func privateSplit(_ tuple: (List<Character>, List<Character>),
                            beginSeparator: String,
                            endSeparator: String) -> List<String> {
    return List(head: tuple.0.string,
                tail: tuple.1.string.split(by: beginSeparator,
                                           endSeparator: endSeparator))
  }
  
  func without(strings: List<Character>) -> String {
    return List<Character>(string: self).removeAll(where: strings.contains).string
  }
}

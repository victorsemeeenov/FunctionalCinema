//
//  StorageService.swift
//  FunctionalCinema
//
//  Created by Victor on 21.03.2020.
//  Copyright © 2020 Victor. All rights reserved.
//

import Foundation

protocol StorageProtocol {
  static func save<T: StorageEntity>(objects: CodableList<T>,
                                     completion: ((Result<Void, Error>) -> Void))
  static func save<T: StorageEntity>(object: T,
                                     completion: ((Result<Void, Error>) -> Void))
  static func fetch<T: StorageEntity>(completion: ((Result<CodableList<T>, Error>) -> Void))
  static func remove<T: StorageEntity>(object: T,
                                       completion: ((Result<Void, Error>) -> Void))
  static func remove<T: StorageEntity>(objects: CodableList<T>,
                                       completion: ((Result<Void, Error>) -> Void))
}

struct StorageService: StorageProtocol {
  static func save<T>(objects: CodableList<T>,
                      completion: ((Result<Void, Error>) -> Void)) where T : StorageEntity {
    completion(read(T.self).flatMap { list -> Result<Void, Error> in
      return write(CodableList(list.removeIfContains(values: objects)
        .append(contentsOf: objects)))
    })
  }
  
  static func save<T>(object: T,
                      completion: ((Result<Void, Error>) -> Void)) where T : StorageEntity {
    completion(read(T.self).flatMap { list -> Result<Void, Error> in
      return write(CodableList(list.removeIfContains(value: object)
        .append(value: object)))
    })
  }
  
  static func fetch<T>(completion: ((Result<CodableList<T>, Error>) -> Void)) where T : StorageEntity {
    completion(read(T.self))
  }
  
  static func remove<T>(object: T,
                        completion: ((Result<Void, Error>) -> Void)) where T : StorageEntity {
    completion(read(T.self).flatMap { list -> Result<Void, Error> in
      return write(CodableList(list.removeIfContains(value: object)))
    })
  }
  
  static func remove<T>(objects: CodableList<T>,
                        completion: ((Result<Void, Error>) -> Void)) where T : StorageEntity {
    completion(read(T.self).flatMap { list -> Result<Void, Error> in
      return write(CodableList(list.removeIfContains(values: objects)))
    })
  }
  
  
  
  static private func write<T: CustomCodable>(_ objects: CodableList<T>) -> Result<Void, Error> {
    do {
      return .success(try objects.encode()
        .description
        .write(to: URL(fileURLWithPath: String(describing: T.self)),
               atomically: true,
               encoding: .utf8))
    } catch {
      return .failure(error)
    }
  }
  
  static private func read<T: CustomCodable>(_ type: T.Type) -> Result<CodableList<T>, Error> {
    do {
      guard let data = String(describing: type)
        .data(using: .utf8) else {
          throw StorageError.cantFetch
      }
      return .success(try CustomCoder().decode(data: data))
    } catch {
      return .failure(error)
    }
  }
}

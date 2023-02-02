//
//  CoreDataHelpers.swift
//  SuperFeed
//
//  Created by yossa on 1/2/2566 BE.
//

import CoreData

extension NSPersistentContainer {

  internal enum LoadingError: Error {
    case modelNotFound
    case failedToLoadPersistenStores(Error)
  }

  internal static func load(modelName name: String, url: URL, in bundle: Bundle) throws -> NSPersistentContainer {
    guard let model = NSManagedObjectModel.with(name: name, in: bundle) else {
      throw LoadingError.modelNotFound
    }

    let description = NSPersistentStoreDescription(url: url)
    let container = NSPersistentContainer(name: name, managedObjectModel: model)
    container.persistentStoreDescriptions = [description]

    var loadError: Error?
    container.loadPersistentStores {
      loadError = $1
    }
    try loadError.map { throw LoadingError.failedToLoadPersistenStores($0) }

    return container
  }
}

extension NSManagedObjectModel {
  fileprivate static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
    bundle
      .url(forResource: name, withExtension: "momd")
      .flatMap { NSManagedObjectModel(contentsOf: $0) }
  }
}

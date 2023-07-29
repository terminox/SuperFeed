//
//  CoreDataHelpers.swift
//  SuperFeed
//
//  Created by yossa on 1/2/2566 BE.
//

import CoreData

extension NSPersistentContainer {

  internal static func load(name: String, model: NSManagedObjectModel, url: URL) throws -> NSPersistentContainer {
    let description = NSPersistentStoreDescription(url: url)
    let container = NSPersistentContainer(name: name, managedObjectModel: model)
    container.persistentStoreDescriptions = [description]

    var loadError: Error?
    container.loadPersistentStores {
      loadError = $1
    }
    try loadError.map { throw $0 }

    return container
  }
}

extension NSManagedObjectModel {
  static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
    bundle
      .url(forResource: name, withExtension: "momd")
      .flatMap { NSManagedObjectModel(contentsOf: $0) }
  }
}

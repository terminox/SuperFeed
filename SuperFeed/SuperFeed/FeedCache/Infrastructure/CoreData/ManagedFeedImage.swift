//
//  ManagedFeedImage.swift
//  SuperFeed
//
//  Created by yossa on 1/2/2566 BE.
//

import CoreData

@objc(ManagedFeedImage)
internal class ManagedFeedImage: NSManagedObject {
  @NSManaged internal var id: UUID
  @NSManaged internal var imageDescription: String?
  @NSManaged internal var location: String?
  @NSManaged internal var url: URL
  @NSManaged internal var data: Data?
  @NSManaged internal var cache: ManagedCache
}

extension ManagedFeedImage {
  
  internal static func first(with url: URL, in context: NSManagedObjectContext) throws -> ManagedFeedImage? {
    let request = NSFetchRequest<ManagedFeedImage>(entityName: entity().name!)
    request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ManagedFeedImage.url), url])
    request.returnsObjectsAsFaults = false
    request.fetchLimit = 1
    return try context.fetch(request).first
  }

  internal static func images(from localFeed: [LocalFeedImage], in context: NSManagedObjectContext) -> NSOrderedSet {
    NSOrderedSet(array: localFeed.map { local in
      let managed = ManagedFeedImage(context: context)
      managed.id = local.id
      managed.imageDescription = local.description
      managed.location = local.location
      managed.url = local.url
      return managed
    })
  }

  internal var local: LocalFeedImage {
    LocalFeedImage(id: id, description: imageDescription, location: location, url: url)
  }
}

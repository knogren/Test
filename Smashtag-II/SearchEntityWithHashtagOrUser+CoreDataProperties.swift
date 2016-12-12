//
//  SearchEntityWithHashtagOrUser+CoreDataProperties.swift
//  Smashtag-II
//
//  Created by Michael Shogren-Knaak on 12/12/16.
//  Copyright © 2016 Bacta.net. All rights reserved.
//

import Foundation
import CoreData

extension SearchEntityWithHashtagOrUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchEntityWithHashtagOrUser> {
        return NSFetchRequest<SearchEntityWithHashtagOrUser>(entityName: "SearchEntityWithHashtagOrUser");
    }

    @NSManaged public var mention: String?
    @NSManaged public var mentionType: String?
    @NSManaged public var numberOfMentions: Int16
    @NSManaged public var searchTerm: String?
    @NSManaged public var ids: NSSet?

}

// MARK: Generated accessors for ids
extension SearchEntityWithHashtagOrUser {

    @objc(addIdsObject:)
    @NSManaged public func addToIds(_ value: Id)

    @objc(removeIdsObject:)
    @NSManaged public func removeFromIds(_ value: Id)

    @objc(addIds:)
    @NSManaged public func addToIds(_ values: NSSet)

    @objc(removeIds:)
    @NSManaged public func removeFromIds(_ values: NSSet)

}

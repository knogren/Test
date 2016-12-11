//
//  SearchEntityWithHashtagOrUser+CoreDataProperties.swift
//  Smashtag-II
//
//  Created by Michael Shogren-Knaak on 12/10/16.
//  Copyright © 2016 Bacta.net. All rights reserved.
//

import Foundation
import CoreData

extension SearchEntityWithHashtagOrUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchEntityWithHashtagOrUser> {
        return NSFetchRequest<SearchEntityWithHashtagOrUser>(entityName: "SearchEntityWithHashtagOrUser");
    }

    @NSManaged public var hashtagMention: String?
    @NSManaged public var infoType: String?
    @NSManaged public var numberMentions: Int16
    @NSManaged public var searchTerm: String?
    @NSManaged public var userMention: String?
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

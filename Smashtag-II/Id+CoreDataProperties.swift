//
//  Id+CoreDataProperties.swift
//  Smashtag-II
//
//  Created by Michael Shogren-Knaak on 12/12/16.
//  Copyright © 2016 Bacta.net. All rights reserved.
//

import Foundation
import CoreData

extension Id {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Id> {
        return NSFetchRequest<Id>(entityName: "Id");
    }

    @NSManaged public var idNumber: String?
    @NSManaged public var tweetSearch: NSSet?

}

// MARK: Generated accessors for tweetSearch
extension Id {

    @objc(addTweetSearchObject:)
    @NSManaged public func addToTweetSearch(_ value: SearchEntityWithHashtagOrUser)

    @objc(removeTweetSearchObject:)
    @NSManaged public func removeFromTweetSearch(_ value: SearchEntityWithHashtagOrUser)

    @objc(addTweetSearch:)
    @NSManaged public func addToTweetSearch(_ values: NSSet)

    @objc(removeTweetSearch:)
    @NSManaged public func removeFromTweetSearch(_ values: NSSet)

}

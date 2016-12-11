//
//  SearchEntityWithHashtagOrUser+CoreDataClass.swift
//  Smashtag-II
//
//  Created by Michael Shogren-Knaak on 12/10/16.
//  Copyright © 2016 Bacta.net. All rights reserved.
//

import Foundation
import CoreData
import Twitter

public class SearchEntityWithHashtagOrUser: NSManagedObject {
    
    class func addMentionsToDatabase(fromSearch searchText: String?, ofType mentionType: String, from mentionArray: [Mention], in tweet: Twitter.Tweet, withContext context: NSManagedObjectContext?) {
        // if tweet has at least one of this mentionType, and database doesn't already have any
        // searchEntityWithMention entry with this id and mentionType, create an entry for each mention
        if !mentionArray.isEmpty {
            let request: NSFetchRequest<SearchEntityWithHashtagOrUser> = NSFetchRequest(entityName: "SearchEntityWithHashtagOrUser")
            request.predicate = NSPredicate(format: "ids contains %@", tweet.id)
        }
    }


}

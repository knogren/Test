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
        if (!mentionArray.isEmpty && !(tweetAlreadyEntered(with: mentionType, andIdFrom: tweet, inContext: context))) {
            if let newIdEntity = NSEntityDescription.insertNewObject(forEntityName: "Id", into: context!) as? Id {
                newIdEntity.idNumber = tweet.id
                for mention in mentionArray {
                    let request: NSFetchRequest<SearchEntityWithHashtagOrUser> = SearchEntityWithHashtagOrUser.fetchRequest()
                    request.predicate = NSPredicate(format: "searchTerm[c] = %@ && mentionType = %@ && mention[c] = %@", searchText!, mentionType, mention.keyword )
                    do {
                        if let matchingSearchEntries = try context?.fetch(request) {
                            if !matchingSearchEntries.isEmpty {
                                for matchingSearchEntry in matchingSearchEntries {
                                    matchingSearchEntry.numberOfMentions += 1
                                    matchingSearchEntry.addToIds(newIdEntity)
                                }
                            } else {
                                if let newSearchEntry = NSEntityDescription.insertNewObject(forEntityName: "SearchEntityWithHashtagOrUser", into: context!) as? SearchEntityWithHashtagOrUser {
                                    newSearchEntry.searchTerm = searchText!
                                    newSearchEntry.mentionType = mentionType
                                    newSearchEntry.mention = mention.keyword
                                    newSearchEntry.numberOfMentions = 1
                                    newSearchEntry.addToIds(newIdEntity)
                                }
                            }
                        }
                    } catch let error {
                            print("fetch request failed with error: \(error)")
                    }
                }
            }
        }
    }
    
    fileprivate class func tweetAlreadyEntered(with mentionType: String, andIdFrom tweet: Twitter.Tweet, inContext context: NSManagedObjectContext?) -> Bool {
        let request: NSFetchRequest<SearchEntityWithHashtagOrUser> = SearchEntityWithHashtagOrUser.fetchRequest()
        request.predicate = NSPredicate(format: "ids.idNumber contains %@ && mentionType = %@", tweet.id, mentionType)
        if let existingEntriesCount = try? context?.count(for: request) {
            if existingEntriesCount! > 0 {
            return true
            }
        }
        return false
    }
}



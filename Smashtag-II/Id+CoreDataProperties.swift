//
//  Id+CoreDataProperties.swift
//  Smashtag-II
//
//  Created by Michael Shogren-Knaak on 12/11/16.
//  Copyright © 2016 Bacta.net. All rights reserved.
//

import Foundation
import CoreData

extension Id {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Id> {
        return NSFetchRequest<Id>(entityName: "Id");
    }

    @NSManaged public var idNumber: String?
    @NSManaged public var tweetSearch: SearchEntityWithHashtagOrUser?

}

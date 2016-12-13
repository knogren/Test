//
//  HistoryInfoTableViewController.swift
//  Smashtag-II
//
//  Created by Michael Shogren-Knaak on 12/10/16.
//  Copyright © 2016 Bacta.net. All rights reserved.
//

import UIKit
import CoreData

class HistoryInfoTableViewController: CoreDataTableViewController {
    
    var searchText: String? { didSet { updateUI() } }
    var managedObjectContext: NSManagedObjectContext?
        = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext { didSet { updateUI() } }

    fileprivate func updateUI() {
        if let context = managedObjectContext, ((searchText?.characters.count)! > 0) {

            context.performAndWait {
                let request: NSFetchRequest<SearchEntityWithHashtagOrUser> = SearchEntityWithHashtagOrUser.fetchRequest()
                request.predicate = NSPredicate(format: "searchTerm = %@ && numberOfMentions > 1", self.searchText!)
                let mentionTypeSortDescriptor = NSSortDescriptor(
                    key: "mentionType",
                    ascending: true )
                let numberMentionsSortDescriptor = NSSortDescriptor(
                    key: "numberOfMentions",
                    ascending: false )
                let mentionSortDescriptor = NSSortDescriptor(
                    key: "mention",
                    ascending: true,
                    selector: #selector(NSString.localizedStandardCompare(_:)) )
                request.sortDescriptors = [mentionTypeSortDescriptor, numberMentionsSortDescriptor, mentionSortDescriptor]
                self.fetchedResultsController = NSFetchedResultsController<SearchEntityWithHashtagOrUser>(
                    fetchRequest: request,
                    managedObjectContext: context,
                    sectionNameKeyPath: "mentionType",
                    cacheName: nil)
            }
        } else {
            fetchedResultsController = nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryInfoCell", for: indexPath)
        if let searchEntity = fetchedResultsController?.object(at: indexPath) {
            var mention: String?
            var mentionCount: Int16?
            searchEntity.managedObjectContext?.performAndWait {
                mention = searchEntity.mention
                mentionCount = searchEntity.numberOfMentions
            }
            cell.textLabel?.text = mention!
            cell.detailTextLabel?.text = "\(mentionCount!) Mentions"
        }
        return cell
    }
}


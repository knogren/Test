//
//  TweetTableViewController.swift
//  Smashtag-II
//
//  Created by Michael Shogren-Knaak on 11/25/16.
//  Copyright © 2016 Bacta.net. All rights reserved.
//

import UIKit
import Twitter
import CoreData

var searchHistory = TwitterSearchHistory()

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
    var managedObjectContext: NSManagedObjectContext?
        = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    var tweets = [Array<Twitter.Tweet>]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var lastTwitterRequest = Twitter.Request
    
    var searchText: String? {
        didSet {
            tweets.removeAll()
            searchForTweets()
            if let query = searchText {
                searchHistory.saveSearchTerm(term: query)
            }
            title = searchText
        }
    }
    
    func searchForTweets() {
        if let query = searchText , query != "" {
            let searchRequest = Request(search: query, count: 5)
            let lastTwitterRequest = searchRequest
            searchRequest.fetchTweets { [weak weakSelf = self] newTweets in
                DispatchQueue.main.async {
                    if lastTwitterRequest == searchRequest && !newTweets.isEmpty {
                        weakSelf?.tweets.insert(newTweets, at: 0)
                        weakSelf?.addToDatabase(tweets: newTweets)
                    }
                }
            }
        }
    }
    
    fileprivate func addToDatabase(tweets tweetsToAdd: [Twitter.Tweet]) {
        managedObjectContext?.performAndWait { [weak weakSelf = self] in
            for tweet in tweetsToAdd {
                SearchEntityWithHashtagOrUser.addMentionsToDatabase(
                    fromSearch: weakSelf?.searchText,
                    ofType: "Hashtag Mention",
                    from: tweet.hashtags,
                    in: tweet,
                    withContext: weakSelf?.managedObjectContext )
                SearchEntityWithHashtagOrUser.addMentionsToDatabase(
                    fromSearch: weakSelf?.searchText,
                    ofType: "User Mention",
                    from: tweet.userMentions,
                    in: tweet,
                    withContext: weakSelf?.managedObjectContext)
            }
            do {
                try weakSelf?.managedObjectContext?.save()
            } catch let error {
                print("could not save due to \(error)")
            }
        }
//        runDatabaseTest()
     }
    
/*    func runDatabaseTest() {
        let request: NSFetchRequest<SearchEntityWithHashtagOrUser> = SearchEntityWithHashtagOrUser.fetchRequest()
        request.predicate = NSPredicate(format: "searchTerm = %@", "nfl")
        if let matchingSearchEntries = try? managedObjectContext?.fetch(request) {
            for entry in matchingSearchEntries! {
                print("SearchTerm = \(entry.searchTerm)")
                print("MentionType = \(entry.mentionType)")
                print("Mention = \(entry.mention)")
                print("Mention Count = \(entry.numberOfMentions)")
            }
        }
        if let totalEntriesCount = try? managedObjectContext?.count(for: request) {
            print("TOTAL ENTRIES: \(totalEntriesCount!)")
        }
    }
 */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    struct Storyboard {
        static let TweetCellIdentifier = "TweetCell"
        static let TweetCellSeque = "ShowTweetDetails"
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.TweetCellIdentifier, for: indexPath)
        let tweet = tweets[indexPath.section][indexPath.row]
        
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }
        
        return cell
    }
    
    @IBOutlet weak var TwitterSearchField: UITextField! {
        didSet {
            TwitterSearchField.delegate = self
            TwitterSearchField.text = searchText
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchText = textField.text
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.TweetCellSeque {
            if let detailVC = (segue.destination as? UITableViewController) as? DetailsTableViewController{
                if let selectedCell = sender as? TweetTableViewCell {
                    detailVC.tweet = selectedCell.tweet
                    detailVC.title = selectedCell.tweet?.user.name
                }
            }
        }
    }
}

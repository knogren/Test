//
//  TweetTableViewController.swift
//  Smashtag-II
//
//  Created by Michael Shogren-Knaak on 11/25/16.
//  Copyright © 2016 Bacta.net. All rights reserved.
//

import UIKit
import Twitter

var searchHistory = TwitterSearchHistory()

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
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
            let searchRequest = Request(search: query + " -filter:retweets", count: 100)
            let lastTwitterRequest = searchRequest
            searchRequest.fetchTweets { [weak weakSelf = self] newTweets in
                DispatchQueue.main.async {
                    if lastTwitterRequest == searchRequest && !newTweets.isEmpty {
                        weakSelf?.tweets.insert(newTweets, at: 0)
                    }
                }
            }
        }
    }
    
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

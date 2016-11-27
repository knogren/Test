//
//  DetailsTableViewController.swift
//  Smashtag
//
//  Created by Michael Shogren-Knaak on 11/21/16.
//  Copyright © 2016 Bacta.net. All rights reserved.
//

import UIKit
import Twitter

class DetailsTableViewController: UITableViewController {
        
    var tweet: Twitter.Tweet? {
        didSet {
            tweetComponents = storeTweetComponents()
        }
    }
    
    enum TweetComponent {
        case Pic(MediaItem)
        case Hashtag(Mention)
        case URL(Mention)
        case UserMention(Mention)
    }
    
    var tweetComponents = [[TweetComponent]]() {
        didSet {
            tableView.reloadData()
        }
    }

    private var temp2DTweetComponentArray = [[TweetComponent]]()
    
    private func storeTweetComponents() -> [[TweetComponent]] {
        if let tweetToParse = tweet {
            storeTweetComponentArray(tweetToParse.media, withTweetComponentNamed: "Pic")
            storeTweetComponentArray(tweetToParse.hashtags, withTweetComponentNamed: "Hashtag")
            storeTweetComponentArray(tweetToParse.urls, withTweetComponentNamed: "URL")
            storeTweetComponentArray(tweetToParse.userMentions, withTweetComponentNamed: "UserMention")
        }
        return temp2DTweetComponentArray
    }
    
    func storeTweetComponentArray<T>(_ tweetItemArray: [T], withTweetComponentNamed componentName: String){
        if !tweetItemArray.isEmpty {
            var arrayOfComponents = [TweetComponent]()
            for member in tweetItemArray {
                switch componentName {
                case "Pic": arrayOfComponents.append(TweetComponent.Pic(member as! MediaItem))
                case "Hashtag": arrayOfComponents.append(TweetComponent.Hashtag(member as! Mention))
                case "URL": arrayOfComponents.append(TweetComponent.URL(member as! Mention))
                case "UserMention": arrayOfComponents.append(TweetComponent.UserMention(member as! Mention))
                default: print("Didn't specify a correct TweetComponent type")
                }
            }
            temp2DTweetComponentArray.append(arrayOfComponents)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweetComponents.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return tweetComponents[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = tweetComponents[indexPath.section][indexPath.row]
        switch data {
        case .Pic(let media):
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath)
            if let imageCell = cell as? ImageTableViewCell {
                imageCell.mediaItem = media
            }
            return cell
        case .Hashtag(let mention),
             .URL(let mention),
             .UserMention(let mention):
            let cell = tableView.dequeueReusableCell(withIdentifier: "MentionCell", for: indexPath)
            cell.textLabel?.text = mention.keyword
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let data = tweetComponents[section][0]
        switch data {
        case .Pic : return "Images"
        case .Hashtag: return "Hashtags"
        case .URL: return "Links"
        case .UserMention: return "Users"
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = tweetComponents[indexPath.section][indexPath.row]
        switch data {
        case .Pic(let media):
            let screenWidth = UIScreen.main.bounds.size.width
            let imageHeight = screenWidth/CGFloat(media.aspectRatio)
            return imageHeight
        case .Hashtag, .URL, .UserMention:
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = tweetComponents[indexPath.section][indexPath.row]
        switch data {
        case .Pic:
            performSegue(withIdentifier: "ShowImage", sender: tableView.cellForRow(at: indexPath))
        case .Hashtag, .UserMention:
            performSegue(withIdentifier: "ShowTweets", sender: tableView.cellForRow(at: indexPath))
        case  .URL(let urlMention):
            let url = URL(string: urlMention.keyword)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowImage" {
            if let cell = sender as? ImageTableViewCell {
                 if let cellImage = cell.linkedTweetImage?.image {
                    if let imageVC = segue.destination as? ImageViewController {
                        imageVC.image = cellImage
                    }
                }
            }
        }
        if segue.identifier == "ShowTweets" {
            if let cell = sender as? UITableViewCell {
                if let searchText = cell.textLabel?.text {
                    if let tweetTableVC = segue.destination as? TweetTableViewController {
                        tweetTableVC.searchText = searchText
                    }
                }
            }
        }
    }

}

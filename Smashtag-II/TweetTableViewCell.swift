//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Michael Shogren-Knaak on 11/19/16.
//  Copyright © 2016 Bacta.net. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tweeter: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var createdDate: UILabel!
    
    var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }
    
    fileprivate func updateUI() {
        tweeter?.text = nil
        tweetText?.text = nil
        profileImage?.image = nil
        createdDate?.text = nil
        
        if let tweet = self.tweet {
            tweetText?.text = tweet.text
            if tweetText?.text != nil {
                for _ in tweet.media {
                   tweetText.text! += " 📷"
                }
            }
            colorMentionsInTweetText()
        }
        
        tweeter?.text = tweet?.user.screenName
        
        //probably should have some stuff for breaking memory cycles
        //and to account for requested image could change by next request?
        if let profileImageURL = tweet?.user.profileImageURL {
            DispatchQueue.global(qos: .userInitiated).async {
                let imageData = try! Data(contentsOf: profileImageURL)
                DispatchQueue.main.async {
                    self.profileImage?.image = UIImage(data: imageData)
                }
            }
        }
        
        let formatter = DateFormatter()
        if Date().timeIntervalSince((tweet?.created)!) > 24*60*60 {
            formatter.dateStyle = DateFormatter.Style.short
        } else {
            formatter.timeStyle = DateFormatter.Style.short
        }
        createdDate?.text = formatter.string(from: (tweet?.created)!)
    }
    
    fileprivate func colorMentionsInTweetText() {
        if let attributedTextOfTweet = tweetText?.attributedText {
            let coloredTweetText = NSMutableAttributedString(attributedString: attributedTextOfTweet)
            colorMentionOfType((tweet?.hashtags)!, in: coloredTweetText, asColor: UIColor.red)
            colorMentionOfType((tweet?.urls)!, in: coloredTweetText, asColor: UIColor.blue)
            colorMentionOfType((tweet?.userMentions)!, in: coloredTweetText, asColor: UIColor.purple)
            tweetText?.attributedText = coloredTweetText
        }
    }
    
    fileprivate func colorMentionOfType(_ mentionType: [Mention], in text: NSMutableAttributedString, asColor color: UIColor) {
        if !mentionType.isEmpty {
            for mention in mentionType {
                text.addAttribute(NSForegroundColorAttributeName, value: color, range: mention.nsrange)
            }
        }
    }
}

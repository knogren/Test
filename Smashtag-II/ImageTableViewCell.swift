//
//  ImageTableViewCell.swift
//  Smashtag
//
//  Created by Michael Shogren-Knaak on 11/24/16.
//  Copyright © 2016 Bacta.net. All rights reserved.
//

import UIKit
import Twitter

class ImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var linkedTweetImage: UIImageView!

    var mediaItem: MediaItem? {
        didSet {
            updateUI()
        }
    }
    
    fileprivate func updateUI() {
        linkedTweetImage?.image = nil

        if let linkedImageURL = mediaItem?.url {
            DispatchQueue.global(qos: .userInitiated).async {
                let imageData = try! Data(contentsOf: linkedImageURL)
                DispatchQueue.main.async {
                    self.linkedTweetImage?.image = UIImage(data: imageData)
                }
            }
        }
    }
    
}

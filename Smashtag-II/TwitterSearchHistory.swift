//
//  TwitterSearchHistory.swift
//  Smashtag-II
//
//  Created by Michael Shogren-Knaak on 11/28/16.
//  Copyright © 2016 Bacta.net. All rights reserved.
//

import UIKit

class TwitterSearchHistory {
    
    fileprivate let defaults = UserDefaults.standard
    
    init() {
        if defaults.array(forKey: "Smashtag") == nil {
            defaults.set([String](), forKey: "Smashtag")
        }
    }
    
    func getSearchTermsArray() -> [String] {
        if let searchTermsArray = defaults.array(forKey: "Smashtag") as? [String] {
            return searchTermsArray
        } else {
            return [String]()
        }
    }
    
    func saveSearchTerm(term: String){
        if var searchTermsArray = defaults.array(forKey: "Smashtag") as? [String] {
            if searchTermsArray.count > 100 {
                searchTermsArray.removeLast()
            }
            searchTermsArray.insert(term, at: 0)
            defaults.set(searchTermsArray, forKey: "Smashtag")
            defaults.synchronize()
        }
    }
}

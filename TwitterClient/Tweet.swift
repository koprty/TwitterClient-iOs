//
//  Tweet.swift
//  TwitterClient
//
//  Created by Lise Ho on 2/28/16.
//  Copyright © 2016 lise_ho. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var text: NSString?
    var timestamp: NSString?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var profileURL: NSString?
    var screenname : NSString?
    var tweetid : NSString
    
    init(dictionary: NSDictionary){
        
        text = dictionary["text"] as? String
        screenname = dictionary["user"]!["screen_name"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
       
        tweetid = String(dictionary["id"])
        profileURL = dictionary["user"]!["profile_image_url_https"] as? String
        
        let timestampString = dictionary["created_at"] as? String
        
        
        if let timestampString = timestampString{
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            var timestamp2 = NSDate()
            timestamp2 = formatter.dateFromString (timestampString)!
            timestamp = timestampString
            print (timestamp)
            print (timestampString)
            
        }
    }
  
    class func tweetsWithArray(dictionaries:[NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
   
        for dictionary in dictionaries {
            print (dictionary)
            let tweet = Tweet(dictionary:dictionary)
            tweets.append(tweet)
        }
        return tweets
    
    }
    
}

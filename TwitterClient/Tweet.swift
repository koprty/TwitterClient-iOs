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
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var profileURL: NSString?
    var screenname : NSString?
    var tweetid : NSString
    
    init(dictionary: NSDictionary){
        text = dictionary["text"] as? String
        screenname = dictionary["screen_name"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        tweetid = (dictionary["id"] as? String)!
        profileURL = dictionary["profile_image_url"] as? String
        print (dictionary)
        print (screenname)
        let timestampString = dictionary["created_at"] as? String
        
        
        if let timestampString = timestampString{
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString (timestampString)
            
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

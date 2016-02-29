//
//  TweetCell.swift
//  TwitterClient
//
//  Created by Lise Ho on 2/29/16.
//  Copyright © 2016 lise_ho. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var timestamp: UILabel!
    
    @IBOutlet weak var profilepic: UIImageView!
    @IBOutlet weak var tweettext: UILabel!

    @IBOutlet weak var retweetcount: UILabel!
    
    @IBOutlet weak var favoritecount: UILabel!
    
    var tweetid : NSString!
    override func awakeFromNib() {
        super.awakeFromNib()
        //tweetid:""
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func Retweeting(sender: AnyObject) {
        //retweetcount
        let defaults = NSUserDefaults.standardUserDefaults()
        let userData = defaults.objectForKey("currentUserData") as? NSData
        
        if let userData = userData {
            let dictionary = try!
                NSJSONSerialization.JSONObjectWithData(userData,options:[]) as! NSDictionary
            
            let currentUser = User(dictionary: dictionary)
            // Throwing odd errors.. for now loop through it 
          
            retweetcount.text = String(Int(retweetcount.text!)! + 1)
        //TwitterAPIClient.sharedInstance.updateRetweet((currentUser.id as? String)!)
    }
    }
    
    
    @IBAction func Favoriting(sender: AnyObject) {
        //favoritecount
        
        //retweetcount
        let defaults = NSUserDefaults.standardUserDefaults()
        let userData = defaults.objectForKey("currentUserData") as? NSData
        
        if let userData = userData {
            let dictionary = try!
                NSJSONSerialization.JSONObjectWithData(userData,options:[]) as! NSDictionary
            
            let currentUser = User(dictionary: dictionary)
            
            favoritecount.text = String(Int(favoritecount.text!)! + 1)
            
             //retweetcount.text = String(Int(retweetcount.text) + 1)
            //TwitterAPIClient.sharedInstance.updateFavorites((currentUser.id as? String)!)
        
        
        }
    
    }
}
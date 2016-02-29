//
//  User.swift
//  TwitterClient
//
//  Created by Lise Ho on 2/28/16.
//  Copyright © 2016 lise_ho. All rights reserved.
//

import UIKit

class User: NSObject {
    var name:NSString?
    var screenname: NSString?
    var profileUrl: NSURL?
    var tag : NSString?
    
    
    init(dictionary:NSDictionary){
        
        
        name = dictionary["name"] as? String
        screenname = dictionary["profile_image_url_https"] as? String
        
        //deserialization -> pulling out specific data from dictionary
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString{
            profileUrl = NSURL(string:profileUrlString)
        }
        tag = dictionary["description"] as? String
        
        
        
    }
}

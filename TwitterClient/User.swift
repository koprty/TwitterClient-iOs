//
//  User.swift
//  TwitterClient
//
//  Created by Lise Ho on 2/28/16.
//  Copyright © 2016 lise_ho. All rights reserved.
//

import UIKit

class User: NSObject {
    static let userDidLogoutNotification = "UserLoggedOut"
    var name:NSString!
    var screenname: NSString!
    var profileUrl: NSURL?
    var tag : NSString!
    var id : NSString!
    var dictionary: NSDictionary!
    
    init(dictionary:NSDictionary){
        
        self.dictionary = dictionary
        name = dictionary["name"] as! String
        screenname = dictionary["screen_name"] as! String
        
        //deserialization -> pulling out specific data from dictionary
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString{
            profileUrl = NSURL(string:profileUrlString)
        }else{
            profileUrl = nil
        }
        tag = dictionary["description"] as! String
        id = String(dictionary["id"]) as! String
    }
    static var _currentUser:User?
    
    class var currentUser: User? {
        
        get{
        
            if _currentUser == nil{
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey("currentUserData") as? NSData
        
                if let userData = userData {
                    let dictionary = try!
                    NSJSONSerialization.JSONObjectWithData(userData,options:[]) as! NSDictionary
        
                _currentUser = User(dictionary: dictionary)
        
                }
            }
            return _currentUser
        }
        set(user){
            _currentUser = user
             let defaults = NSUserDefaults.standardUserDefaults()
           
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                    
            defaults.setObject(data, forKey:"currentUserData")
            }else{
                defaults.setObject(nil, forKey:"currentUserData")
            }
            
            defaults.synchronize()
            
        }
        
    }
}

//
//  TwitterAPIClient.swift
//  TwitterClient
//
//  Created by Lise Ho on 2/28/16.
//  Copyright © 2016 lise_ho. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterAPIClient: BDBOAuth1SessionManager {
    
    
    static var sharedInstance =  TwitterAPIClient(baseURL: NSURL(string:"https://api.twitter.com")!, consumerKey: "s5qQt15ZNHrEhWgEmALKsVPGi", consumerSecret: "IkKGv8veWz6klZSkeKvFR8q9Dm9wUoUXcgmt6V4nr8gX8G6CAI")
    
    
    
    
    
    func homeTimeline( success: ([Tweet])-> (), failure:NSError -> () ){
    
        GET("1.1/statuses/home_timeline.json",parameters: nil,progress: nil,success: {(task:NSURLSessionDataTask, response:AnyObject?)-> Void in
            let tweetdictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(tweetdictionaries)
            
            success(tweets)
           
            },failure:{(task:NSURLSessionDataTask?,error:NSError )-> Void in
                failure(error)
        })

    }
    
    func currentAccount(){
        
        
        GET("1.1/account/verify_credentials.json", parameters: nil, progress:nil, success: {(task:NSURLSessionDataTask, response:AnyObject?) -> Void in
            //print ("account:\(response)")
            let userDict = response as! NSDictionary
            
            let user = User(dictionary:userDict)
            
            print("user: \(user.name)")
            
            },failure:{(task:NSURLSessionDataTask?, error:NSError) -> Void in
                print ("error : \(error.localizedDescription)")
        })

        
    }
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
 
    func login(success: () -> (), failure: (NSError) -> () ){
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string:"twitterclient://oauth"), scope: nil, success: { (requestToken:BDBOAuth1Credential!) -> Void in
            print("Got a token")
            
            let url = NSURL (string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            
            }) {(error: NSError!) -> Void in
                
                self.loginFailure!(error)
                print ("error : \(error.localizedDescription)")
        }
        

    }
    
    func handleOpenUrl(url:NSURL){
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken:BDBOAuth1Credential!) -> Void in
            
            print("Got a ACCESS token")
            self.loginSuccess?()
        
            }) {(error:NSError!) -> Void in
                print ("error : \(error.localizedDescription)")
                
                self.loginFailure?(error)
        }
    }
}

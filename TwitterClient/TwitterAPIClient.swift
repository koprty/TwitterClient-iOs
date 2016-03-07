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
    
    
    static var sharedInstance =  TwitterAPIClient(baseURL: NSURL(string:"https://api.twitter.com")!, consumerKey: "SXqFBvQ0ibQxJLzANwYYF1jcN", consumerSecret: "7Dz4eSTJumYpYnPWdgKitBN60OTFgREsp6OdiNY6C3ihT1OS2l")
    
    
    
    
    
    func homeTimeline( success: ([Tweet])-> (), failure:NSError -> () ){
    
        GET("1.1/statuses/home_timeline.json",parameters: nil,progress: nil,success: {(task:NSURLSessionDataTask, response:AnyObject?)-> Void in
            let tweetdictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(tweetdictionaries)
            
            success(tweets)
           
            },failure:{(task:NSURLSessionDataTask?,error:NSError )-> Void in
                print (error.localizedDescription)
                failure(error)
        })

    }
        
    func getProfile (screenname:String, success: NSDictionary-> (), failure:NSError -> () ){
    
        let params = ["screen_name": screenname]
        
        GET("1.1/users/show.json",parameters: params,progress: nil,success: {(task:NSURLSessionDataTask, response:AnyObject?)-> Void in
        let tweetdictionaries = response as! NSDictionary
            
            success(tweetdictionaries)
            
        },failure:{(task:NSURLSessionDataTask?,error:NSError )-> Void in
            print (error.localizedDescription)
           failure(error)
    
    });
        //print (tweetdictionaries)

    }
    
    func currentAccount(success: (User) -> (), failure:(NSError)-> ()){
    
        
        GET("1.1/account/verify_credentials.json", parameters: nil, progress:nil, success: {(task:NSURLSessionDataTask, response:AnyObject?) -> Void in
            //print ("account:\(response)")
            let userDict = response as! NSDictionary
            
            let user = User(dictionary:userDict)
            success(user)
            },failure:{(task:NSURLSessionDataTask?, error:NSError) -> Void in
               failure(error)
        })

        
    }
    
    func updateRetweet (userid:String){
        //var param = ["id": userid]
      
        POST("https://api.twitter.com/1.1/statuses/retweet/"+String(userid)+".json", parameters: nil, progress:nil, success: {(task:NSURLSessionDataTask, response:AnyObject?) -> Void in
            //print ("account:\(response)")

           
            },failure:{(task:NSURLSessionDataTask?, error:NSError) -> Void in
                print ("error : \(error.localizedDescription)")
        })
        
    }
    
    func updateFavorites(userid:String){
        let param = ["id":userid]
        POST("/1.1/favorites/create.json?", parameters: param, progress:nil, success: {(task:NSURLSessionDataTask, response:AnyObject?) -> Void in
            //print ("account:\(response)")
            
            
            
            },failure:{(task:NSURLSessionDataTask?, error:NSError) -> Void in
                print ("error : \(error.localizedDescription)")
        })

    }
    
    func newTweet (status:String){
        //"https://api.twitter.com/1.1/statuses/update.json?status=Maybe%20he%27ll%20finally%20find%20his%20keys.%20%23peterfalk"
        var status = ""
        let param = []
        var newStatusRequest = "1.1/statuses/update.json?" + status
        POST(newStatusRequest , parameters:  param, progress: nil, success: {(task:NSURLSessionDataTask, response:AnyObject? ) -> Void in
            
        }, failure: {(task:NSURLSessionDataTask?, error: NSError) -> Void in
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
            
            
            
            //print("Got a ACCESS token")
            
            self.currentAccount({(user:User) -> () in
                User.currentUser = user
                self.loginSuccess?()
                }, failure: { (error:NSError) -> () in
                    self.loginFailure? (error)
                })
            }) {(error:NSError!) -> Void in
                print ("error : \(error.localizedDescription)")
                
                self.loginFailure?(error)
        }
    }
    
    func logout (){
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification,object:nil)
    }
}

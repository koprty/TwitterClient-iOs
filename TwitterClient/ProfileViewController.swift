//
//  ProfileViewController.swift
//  TwitterClient
//
//  Created by Lise Ho on 3/6/16.
//  Copyright © 2016 lise_ho. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    //var profileID : String
    //https://api.twitter.com/1.1/users/show.json?screen_name=
    let twitterClient = TwitterAPIClient.sharedInstance
    var profileID : String!
    
    override func viewDidLoad() {
        /*        super.viewDidLoad()
        
        TwitterAPIClient.sharedInstance.getProfile(profileID, success: {(profile:NSDictionary)->( ) in
            
            self.myprofile = profile
            
            }, failure:{(error:NSError) -> () in
                print ("Error: \(error.localizedDescription)")
                
        })
        print (profile)
*/
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
   

    */

}

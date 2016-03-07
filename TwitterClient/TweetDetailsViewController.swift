//
//  TweetDetailsViewController.swift
//  TwitterClient
//
//  Created by Lise Ho on 3/6/16.
//  Copyright © 2016 lise_ho. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {

    @IBOutlet weak var image_tweet: UIImageView!
    @IBOutlet weak var user_tweet: UILabel!
    @IBOutlet weak var timestamp_tweet: UILabel!
    @IBOutlet weak var description_tweet: UILabel!
    @IBOutlet weak var retweet_tweet: UIButton!
    @IBOutlet weak var fav_tweet: UIButton!
    @IBOutlet weak var retweet_count: UILabel!
    @IBOutlet weak var fav_count: UILabel!
    var tweet : Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // update tweet info
        user_tweet.text = tweet!.screenname as? String
        timestamp_tweet.text = tweet!.timestamp as? String
        description_tweet.text = tweet!.text as? String
        retweet_count.text = String(tweet?.retweetCount)
        fav_count.text = String(tweet?.favoritesCount)
        
        
        let image_url =  NSURL(string:tweet!.profileURL as! String)
        let photoRequest = NSURLRequest(URL: image_url!)
        image_tweet.setImageWithURLRequest(photoRequest, placeholderImage:nil,
            success:{(photoRequest, photoResponse, image) -> Void in
                
                self.image_tweet.image = image
                
            }, failure: { (photoRequest, imageResponse, error) -> Void in
                // do something for the failure condition
        })

        
        // set tap Gesture on image_tweet
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("profileTapped:"))
        image_tweet.userInteractionEnabled = true
        image_tweet.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view.
    }
    
    
    func profileTapped(recognizer:UITapGestureRecognizer){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let secondViewController = storyBoard.instantiateViewControllerWithIdentifier("ProfileView") as! ProfileViewController
        secondViewController.profileID = tweet.
        self.presentViewController(secondViewController, animated:true, completion:nil)
    
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

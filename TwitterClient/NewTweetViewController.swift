//
//  NewTweetViewController.swift
//  TwitterClient
//
//  Created by Lise Ho on 3/6/16.
//  Copyright © 2016 lise_ho. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController, UITextViewDelegate{
    
    
    @IBOutlet weak var new_profile: UIImageView!
    @IBOutlet weak var new_Tweet_text: UITextView!
    @IBOutlet weak var new_screenname: UILabel!
    @IBOutlet weak var tweet_text_count: UILabel!
    @IBOutlet weak var compose_button: UIButton!
    var maxLength = 150
    override func viewDidLoad() {
        super.viewDidLoad()
        var user = User._currentUser
         self.compose_button.titleLabel!.adjustsFontSizeToFitWidth  = true
        new_screenname.text = String(user!.screenname)
        let image_url =  user!.profileUrl
            let photoRequest = NSURLRequest(URL: image_url!)
            
            new_profile.setImageWithURLRequest(photoRequest, placeholderImage:nil,
                success:{(photoRequest, photoResponse, image) -> Void in
                    
                   self.new_profile.image = image
                    
                }, failure: { (photoRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
            })

        
        // set delegate to get textview's actions
        self.new_Tweet_text.selectable = true
        self.new_Tweet_text.layer.borderWidth = 2
        //self.new_Tweet_text.layer.backgroundColor = UIColor.grayColor() as? CGColor
        self.new_Tweet_text.layer.cornerRadius = 10
        self.new_Tweet_text.delegate = self
        
        
        self.compose_button.layer.borderWidth = 1
        self.compose_button.layer.cornerRadius = 3
        
        self.tweet_text_count.text = String(new_Tweet_text.text.characters.count)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("profileTapped:"))
        new_profile.userInteractionEnabled = true
        new_profile.addGestureRecognizer(tapGestureRecognizer)
        
    }
    @IBAction func ComposeTweet(sender: AnyObject) {
        // send contents of text and publish tweet
        
        if (new_Tweet_text.text.characters.count > 0){
                // send request
            new_Tweet_text.resignFirstResponder()
            var new_tweet = new_Tweet_text.text as String
            TwitterAPIClient.sharedInstance.newTweet (new_tweet, success: {(response:NSDictionary)->( ) in
                var resp = response
                if (!(resp["text"] is NSNull)){
                    self.compose_button.titleLabel!.numberOfLines = 1
                    self.compose_button.titleLabel!.text = "YES! YOU HAVE TWEETED!"
                    self.compose_button.titleLabel!.adjustsFontSizeToFitWidth  = true
                    
                }else{
                    self.compose_button.titleLabel!.numberOfLines = 1
                    self.compose_button.titleLabel!.text = "Your Tweet was not be published."
                    self.compose_button.titleLabel!.adjustsFontSizeToFitWidth  = true
                }
                
                
                }, failure: { (error ) -> Void in
                    print (error)
                    // do something for the failure condition
                    self.compose_button.titleLabel!.numberOfLines = 1
                    self.compose_button.titleLabel!.text = "Your Tweet was not be published."
                    self.compose_button.titleLabel!.adjustsFontSizeToFitWidth  = true
            })

            
            
            
            
        }
    
    
    }

    func textViewDidChange(textView: UITextView) { //Handle the text changes here
    
        if (textView.text!.characters.count > maxLength) {
            textView.deleteBackward()
        }
        self.tweet_text_count.text = String(maxLength-textView.text!.characters.count)
        
        
        
    }
       
    
    func profileTapped(recognizer:UITapGestureRecognizer){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let secondViewController = storyBoard.instantiateViewControllerWithIdentifier("TimelineProfileView") as! TweetsViewController
        secondViewController.profileID = String(User._currentUser!.screenname!)
        print (User._currentUser!.screenname!)
        print(":LLLLLLLL:")
        let navigationController = UINavigationController(rootViewController:secondViewController)
        
        self.presentViewController(navigationController, animated: true, completion: nil)
      
        
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

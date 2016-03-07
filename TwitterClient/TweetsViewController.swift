//
//  TweetsViewController.swift
//  TwitterClient
//
//  Created by Lise Ho on 2/28/16.
//  Copyright © 2016 lise_ho. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var mytweetcount: UILabel!
    @IBOutlet weak var myfollowingcount: UILabel!
    @IBOutlet weak var myfollowercount: UILabel!
    @IBOutlet weak var myprofilename: UILabel!
    @IBOutlet weak var myscreenname: UILabel!
    @IBOutlet weak var headerimage: UIImageView!
    @IBOutlet weak var profiepic: UIImageView!
    var tweets : [Tweet]!
    var dataloaded = false
    var profileID:String! = ""
    var myprofile : NSDictionary! = [:]
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
                //self.navigationController?.navigationBar.hidden = false
        
        
        // load API
        TwitterAPIClient.sharedInstance.homeTimeline( {(tweets:[Tweet]) -> () in
            
            self.tweets = tweets
            //for tweet in tweets{
                //print (tweet.text)
            //}
            self.dataloaded = true
            self.tableView.reloadData()
            }, failure: { (error:NSError) -> () in
                print ("Error: \(error.localizedDescription)")
                self.dataloaded = false
        })
        print (profileID)
        if (profileID!.characters.count <= 0){
            profileID = User.currentUser!.screenname as String
        }
        print (User.currentUser!.screenname)
        
        TwitterAPIClient.sharedInstance.getProfile(profileID!, success: {(profile:NSDictionary)->( ) in
        
            self.myprofile = profile
            print (profile)
            
            
            self.myfollowercount.text = "Followers: " + String(self.myprofile["followers_count"]!)
            self.myfollowingcount.text = "Following: " + String(self.myprofile["friends_count"]!)
            self.mytweetcount.text = "Tweets: " + String(self.myprofile["statuses_count"]!)
            self.myscreenname.text = String(self.myprofile["screen_name"]!)
            self.myprofilename.text = String(self.myprofile["description"]!)
        
            
             let image_url =  NSURL(string:self.myprofile["profile_image_url_https"] as! String)
             let photoRequest = NSURLRequest(URL: image_url!)
            
            self.profiepic.setImageWithURLRequest(photoRequest, placeholderImage:nil,
                success:{(photoRequest, photoResponse, image) -> Void in
                    
                    self.profiepic.image = image
                    
                }, failure: { (photoRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
            })
                
        
            
            let image_url2 =  NSURL(string:self.myprofile["profile_banner_url"] as!String)
            let photoRequest2 = NSURLRequest(URL: image_url2!)
            
            self.headerimage.setImageWithURLRequest(photoRequest2, placeholderImage:nil,
                success:{(photoRequest, photoResponse, image) -> Void in
                    
                    self.headerimage.image = image
                    
                }, failure: { (photoRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
            })
   
  }, failure:{(error:NSError) -> () in
                print ("Error: \(error.localizedDescription)")
                
        })
         
        print (self.myprofile)
        
        
        
        print("HELLO WORLD")
        // Do any additional setup after loading the view.
        // LOAD ALL ATTRIBUTES WHEN NSDICTIONARY IS RECEIVED
/*
        myfollowercount.text = myprofile["followers_count"] as? String
        myfollowingcount.text = myprofile["following"] as? String
        mytweetcount.text = myprofile["statuses_count"] as? String
        myscreenname.text = myprofile["screen_name"] as? String
        myprofilename.text = myprofile["description"] as? String
        print (myprofile["profile_image_url_https"])
        //set profile pict
        var image_url =  NSURL(string:myprofile["profile_image_url_https"] as! String)
        var photoRequest = NSURLRequest(URL: image_url!)
        
        profiepic.setImageWithURLRequest(photoRequest, placeholderImage:nil,
            success:{(photoRequest, photoResponse, image) -> Void in
                
                self.profiepic.image = image
                
            }, failure: { (photoRequest, imageResponse, error) -> Void in
                // do something for the failure condition
        })

        image_url =  NSURL(string:(myprofile["profile_background_image_url_https"] as? String)!)
        photoRequest = NSURLRequest(URL: image_url!)
        
        headerimage.setImageWithURLRequest(photoRequest, placeholderImage:nil,
            success:{(photoRequest, photoResponse, image) -> Void in
                
                self.headerimage.image = image
                
            }, failure: { (photoRequest, imageResponse, error) -> Void in
                // do something for the failure condition
        })
*/
        //profiepic = myprofile["profile_image_url_https"] as! String
        //sheaderimage = myprofile["profile_backgroune_image_url"] as! String
        tableView.dataSource = self
        tableView.delegate = self
        
        
        
    }

    // TABLE VIEW
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("com.TweetCell", forIndexPath: indexPath) as! TweetCell
        if self.dataloaded {
            //print (tweets.count)
            let tweet = tweets[indexPath.row]
            //print (tweet.profileURL)
            
            cell.tweetid = tweet.tweetid
            cell.username.text = tweet.screenname as? String
            cell.timestamp.text = tweet.timestamp as? String
            cell.retweetcount.text = String(tweet.retweetCount)
            cell.favoritecount.text = String(tweet.favoritesCount)
            cell.tweettext.text = tweet.text as? String
            
            //set profile pict
            let image_url =  NSURL(string:tweet.profileURL as! String)
            let photoRequest = NSURLRequest(URL: image_url!)
            
            cell.profilepic.setImageWithURLRequest(photoRequest, placeholderImage:nil,
                success:{(photoRequest, photoResponse, image) -> Void in
                    
                    cell.profilepic.image = image
                    
                }, failure: { (photoRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
            })

        }else{
            print ("not loaded")
        }
        
        
        //let tweet = tweets[indexPath.row]
        //print (tweet)
        
    
        return cell
        
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataloaded{
            return tweets.count
        }else{
            loadData()
            //return tweets.count
        }
       
        return 0//return self.photos.count
    }

    func loadData(){
        TwitterAPIClient.sharedInstance.homeTimeline({(tweets:[Tweet]) -> () in
            
            self.tweets = tweets
            }, failure: { (error:NSError) -> () in
                print ("Error: \(error.localizedDescription)")
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onLogoutButton(sender: AnyObject) {
        TwitterAPIClient.sharedInstance.logout()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (sender is UIBarButtonItem){
            let elementViewController = segue.destinationViewController as! NewTweetViewController
            
            
        }else{
        let cell = sender as! TweetCell
        let indexPath = tableView.indexPathForCell(cell)
        let tweetie = tweets[indexPath!.row]
        // assign segue's destination View Controller
        // class is uppercase
        let elementViewController = segue.destinationViewController as! TweetDetailsViewController
                print ("prepareForSegue has been called")
        
        elementViewController.tweet = tweetie
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        }
    }


}

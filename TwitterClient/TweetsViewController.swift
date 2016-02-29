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

    var tweets : [Tweet]!
    var dataloaded = false
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
                //self.navigationController?.navigationBar.hidden = false
        
        
        // load API
        TwitterAPIClient.sharedInstance.homeTimeline({(tweets:[Tweet]) -> () in
            
            self.tweets = tweets
            for tweet in tweets{
                print (tweet.text)
            }
            self.dataloaded = true
            self.tableView.reloadData()
            }, failure: { (error:NSError) -> () in
                print ("Error: \(error.localizedDescription)")
                self.dataloaded = false
        })
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self

        
    }

    // TABLE VIEW
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("com.TweetCell", forIndexPath: indexPath) as! TweetCell
        if self.dataloaded {
            print (tweets.count)
            let tweet = tweets[indexPath.row]
            print (tweet.profileURL)
            cell.tweetid = tweet.tweetid
            cell.username.text = tweet.screenname as? String
            cell.timestamp.text = String(tweet.timestamp)
            cell.retweetcount.text = String(tweet.retweetCount)
            cell.favoritecount.text = String(tweet.favoritesCount)

            
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
            print (tweets.count)
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
            for tweet in tweets{
                print (tweet.text)
            }
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

}

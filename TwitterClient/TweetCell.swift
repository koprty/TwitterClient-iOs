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

}

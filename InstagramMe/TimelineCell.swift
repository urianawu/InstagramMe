//
//  TimelineCell.swift
//  InstagramMe
//
//  Created by you wu on 3/4/16.
//  Copyright © 2016 You Wu. All rights reserved.
//

import UIKit
import Parse

class TimelineCell: UITableViewCell {

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var profileTopView: UIImageView!
    
    var imageFile: PFFile?
    var post: Post! {
        didSet {
            imageFile = post.imageFile
            imageFile!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if error ==  nil {
                    if let imageData = imageData {
                        self.photoView.image = UIImage(data: imageData)
                    }
                }
            }
            postLabel.text = post.author!+": "+post.caption!
            if let file = post.authorProfileFile {
            file.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if error ==  nil {
                    if let imageData = imageData {
                        self.profileView.image = UIImage(data: imageData)
                        self.profileTopView.image = UIImage(data: imageData)
                    }
                }
            }
            }

            timeLabel.text = NSDate().offsetFrom(post.createdAt!) + " ago"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
}



//
//  ProfileViewController.swift
//  InstagramMe
//
//  Created by you wu on 3/4/16.
//  Copyright © 2016 You Wu. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postsLabel: UILabel!
    
    var coverFile: PFFile?
    var profileFile: PFFile?
    var username: String?
    var updateAt: String?
    
    var user:PFUser? {
        didSet{
            self.profileFile = user?.valueForKey("profile") as? PFFile
            self.coverFile = user?.valueForKey("cover") as? PFFile
            username = user?.username
            updateAt = "Last update "+NSDate().offsetFrom((user?.updatedAt)!) + " ago"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let file = coverFile {
            file.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if error ==  nil {
                    if let imageData = imageData {
                        self.backgroundView.image = UIImage(data: imageData)
                    }
                }
            }
        }
        if let pfile = profileFile  {
            pfile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if error ==  nil {
                    if let imageData = imageData {
                        self.profileView.image = UIImage(data: imageData)
                    }
                }
            }
        }
        
        usernameLabel.text = username
        postsLabel.text = updateAt
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


//
//  TimelineHeaderView.swift
//  InstagramMe
//
//  Created by you wu on 3/3/16.
//  Copyright © 2016 You Wu. All rights reserved.
//

import UIKit
import Parse

class TimelineHeaderView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var profileView: UIImageView!
    
    var user: PFUser! {
        didSet {
            if let imageFile = user.objectForKey("cover") as? PFFile {

            imageFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if error ==  nil {
                    if let imageData = imageData {
                        self.backgroundView.image = UIImage(data: imageData)
                    }
                }
            }
            }
            if let profileFile = user.objectForKey("profile") as? PFFile {
                print("setting?")

            profileFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if error ==  nil {
                    if let imageData = imageData {
                        self.profileView.image = UIImage(data: imageData)
                    }
                }
            }
            }

        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "TimelineHeaderView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    
}

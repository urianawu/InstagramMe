//
//  TimelineViewController.swift
//  InstagramMe
//
//  Created by you wu on 3/3/16.
//  Copyright © 2016 You Wu. All rights reserved.
//

import UIKit
import PathMenu
import Parse
import MBProgressHUD

class TimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var tableView: UITableView!

    var refreshControl: UIRefreshControl!

    var profileTapped = false
    let kHeaderHeight = CGFloat(150)
    var headerInfo = TimelineHeaderView()

    var posts = [Post]()
    var query: PFQuery!
    
    var loadingMoreView:InfiniteScrollActivityView?
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //data from parse
        // construct PFQuery
        query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if let postObjects = posts {
                // do something with the data fetched
                self.posts = Post.postsWithArray(postObjects)
                self.tableView.reloadData()
                MBProgressHUD.hideHUDForView(self.view, animated: true)

            } else {
                // handle error
            }
        }
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)

        
        
        //table view
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension

        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        tableView.addSubview(loadingMoreView!)

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.bounds = CGRectMake(-view.bounds.size.width/2 + 32,
            280,
            refreshControl.bounds.size.width,
            refreshControl.bounds.size.height);


        //set up header view
        let tableHeaderView = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kHeaderHeight));
        
        headerInfo = TimelineHeaderView(frame: CGRect(x: 0, y: 0, width: CGRectGetWidth(self.view.frame), height: kHeaderHeight))
        headerInfo.user = PFUser.currentUser()
        let coverTapRecognizer = UITapGestureRecognizer(target: self, action: Selector("profileImageTapped:"))
        let profileTapRecognizer = UITapGestureRecognizer(target: self, action: Selector("profileImageTapped:"))
        headerInfo.profileView.addGestureRecognizer(profileTapRecognizer)
        headerInfo.backgroundView.addGestureRecognizer(coverTapRecognizer)
        
        tableHeaderView.addSubview(headerInfo)
        self.tableView.tableHeaderView = tableHeaderView
        
        tableView.insertSubview(refreshControl, aboveSubview: headerInfo)

        //setup path like sharing button
        let menuItemImage = UIImage(named: "bg-menuitem")!
        let menuItemHighlitedImage = UIImage(named: "bg-menuitem-highlighted")!
        
        let logoutImage = UIImage(named: "icon-logout")!
        let cameraImage = UIImage(named: "icon-camera")!
        let quoteImage = UIImage(named: "icon-quote")!
        let starMenuItem1 = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: logoutImage)
        
        let starMenuItem2 = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: cameraImage)
        
        let starMenuItem3 = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: quoteImage)
        
        let items = [starMenuItem1, starMenuItem2, starMenuItem3]
        
        let startItem = PathMenuItem(image: UIImage(named: "bg-addbutton")!,
            highlightedImage: UIImage(named: "bg-addbutton-highlighted"),
            contentImage: UIImage(named: "icon-plus"),
            highlightedContentImage: UIImage(named: "icon-plus-highlighted"))
        
        let menu = PathMenu(frame: view.bounds, startItem: startItem, items: items)
        menu.delegate = self
        menu.startPoint = CGPointMake(self.view.frame.size.width - 40, self.view.frame.size.height - 30.0)
        menu.menuWholeAngle = CGFloat(M_PI/2) - CGFloat(M_PI/8)
        menu.rotateAngle = -CGFloat(M_PI_2) + CGFloat(M_PI/5) * 1/2
        menu.timeOffset = 0.0
        menu.farRadius = 110.0
        menu.nearRadius = 90.0
        menu.endRadius = 100.0
        menu.animationDuration = 0.5
        view.addSubview(menu)

        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadPosts() {
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if let postObjects = posts {
                // do something with the data fetched
                self.posts = Post.postsWithArray(postObjects)
                self.tableView.reloadData()
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.refreshControl.endRefreshing()

            } else {
                // handle error
            }
        }
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)


    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        reloadPosts()
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let yPos: CGFloat = -scrollView.contentOffset.y
        
        if (yPos > 0) {
            var imgRect: CGRect = headerInfo.frame
            imgRect.origin.y = scrollView.contentOffset.y
            imgRect.size.height = kHeaderHeight+yPos
            headerInfo.frame = imgRect
            refreshControl.alpha = (yPos-150)/50.0
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCell", forIndexPath: indexPath) as! TimelineCell
        cell.selectionStyle = .None
        cell.post = posts[indexPath.row]
        let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("imageTapped:"))
        let topTapRecognizer = UITapGestureRecognizer(target: self, action: Selector("imageTapped:"))

        //Add the recognizer to your view.
        cell.profileView.addGestureRecognizer(tapRecognizer)
        cell.profileTopView.addGestureRecognizer(topTapRecognizer)
        return cell
    }
    
    @IBAction func onFinishCompose(segue: UIStoryboardSegue) {
        if let vc = segue.sourceViewController as? ComposeViewController{
            var photo = UIImage()
            if let postPhoto: UIImage = vc.resizedPhoto {
                photo = postPhoto
            }else {
                let image = getImageWithColor(UIColor(hue: CGFloat(Float(arc4random()) / Float(UINT32_MAX)), saturation: 0.3, brightness: 0.8, alpha: 1), size: CGSize(width: 400, height: 400))
                photo = textToImage(vc.captionView.text, inImage: image, atPoint: CGPoint(x: 80, y: 80))
                print(photo)
            }
            Post.postUserImage(photo, withCaption: vc.captionView.text, withCompletion: { (succeed: Bool, error: NSError?) -> Void in
                self.reloadPosts()
            })
        }
        
    }

    @IBAction func onCloseProfile(segue: UIStoryboardSegue) {
        
    }
    
    func imageTapped(sender: AnyObject){
        
        let point = sender.locationInView(tableView)
        if let indexPath = tableView.indexPathForRowAtPoint(point) {
            let post = posts[indexPath.row]
            self.performSegueWithIdentifier("toProfileSegue", sender: post)
        }
        
    }
    
    func profileImageTapped(sender: AnyObject) {
        if sender.view == headerInfo.profileView {
            profileTapped = true
        }else {
            profileTapped = false
        }
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }

    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            // Get the image captured by the UIImagePickerController
            let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            // Do something with the images (based on your use case)
            let pickedImage = Post.resize(originalImage, newSize: CGSize(width: 400, height: 400))
            let imageFile = Post.getPFFileFromImage(pickedImage)
            
            if profileTapped {
                print("changing profile")
                PFUser.currentUser()?.setObject(imageFile!, forKey: "profile")
                headerInfo.profileView.image = pickedImage
            }else {
                print("changing cover")
                PFUser.currentUser()?.setObject(imageFile!, forKey: "cover")
                headerInfo.backgroundView.image = pickedImage

            }
            PFUser.currentUser()?.saveInBackground()
            self.reloadPosts()
            
            // Dismiss UIImagePickerController to go back to your original view controller
            dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let profileVC = segue.destinationViewController as? ProfileViewController {
            profileVC.user = (sender as! Post).user
        }
        
    }

    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func textToImage(drawText: NSString, inImage: UIImage, atPoint:CGPoint)->UIImage{
        
        // Setup the font specific variables
        let textColor: UIColor = UIColor.whiteColor()
        let textFont: UIFont = UIFont(name: "HelveticaNeue-UltraLight", size: 50)!
        
        //Setup the image context using the passed image.
        UIGraphicsBeginImageContext(inImage.size)
        
        let textStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        textStyle.alignment = NSTextAlignment.Center
        
        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            NSParagraphStyleAttributeName: textStyle
        ]
        
        //Put the image into a rectangle as large as the original image.
        inImage.drawInRect(CGRectMake(0, 0, inImage.size.width, inImage.size.height))
        
        // Creating a point within the space that is as bit as the image.
        let rect: CGRect = CGRectMake(atPoint.x, atPoint.y, inImage.size.width-2*atPoint.x, inImage.size.height-2*atPoint.y)
        
        //Now Draw the text into an image.
        drawText.drawInRect(rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //And pass it back up to the caller.
        return newImage
        
    }
}

extension TimelineViewController: PathMenuDelegate {
    func pathMenu(menu: PathMenu, didSelectIndex idx: Int) {
        if idx == 0 {
            PFUser.logOut()
            NSNotificationCenter.defaultCenter().postNotificationName("userDidLogoutNotification", object: nil)
        }else if idx == 1 {
            self.performSegueWithIdentifier("toImagePickerSegue", sender: self)
        }else if idx == 2 {
            //add quotes
            self.performSegueWithIdentifier("toQuoteSegue", sender: self)
        }
        
    }
    
    func pathMenuWillAnimateOpen(menu: PathMenu) {
        
    }
    
    func pathMenuWillAnimateClose(menu: PathMenu) {
        
        
    }
    
    func pathMenuDidFinishAnimationOpen(menu: PathMenu) {
    }
    
    func pathMenuDidFinishAnimationClose(menu: PathMenu) {
    }
}

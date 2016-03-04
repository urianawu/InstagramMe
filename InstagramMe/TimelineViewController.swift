//
//  TimelineViewController.swift
//  InstagramMe
//
//  Created by you wu on 3/3/16.
//  Copyright © 2016 You Wu. All rights reserved.
//

import UIKit
import PathMenu

class TimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var blurMaskView: UIVisualEffectView!

    let kHeaderHeight = CGFloat(150)
    var headerInfo = TimelineHeaderView()
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension

        //set up header view
        let tableHeaderView = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kHeaderHeight));
        
        headerInfo = TimelineHeaderView(frame: CGRect(x: 0, y: 0, width: CGRectGetWidth(self.view.frame), height: kHeaderHeight))
        
        tableHeaderView.addSubview(headerInfo)
        self.tableView.tableHeaderView = tableHeaderView
        
        //setup path like sharing button
        let menuItemImage = UIImage(named: "bg-menuitem")!
        let menuItemHighlitedImage = UIImage(named: "bg-menuitem-highlighted")!
        
        let starImage = UIImage(named: "icon-star")!
        
        let starMenuItem1 = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: starImage)
        
        let starMenuItem2 = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: starImage)
        
        let starMenuItem3 = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: starImage)
        
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

        //add image picker
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let yPos: CGFloat = -scrollView.contentOffset.y
        
        if (yPos > 0) {
            var imgRect: CGRect = headerInfo.frame
            imgRect.origin.y = scrollView.contentOffset.y
            imgRect.size.height = kHeaderHeight+yPos
            headerInfo.frame = imgRect
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCell", forIndexPath: indexPath)
        cell.selectionStyle = .None

        return cell
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            // Get the image captured by the UIImagePickerController
            let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            
            // Do something with the images (based on your use case)
            
            Post.postUserImage(originalImage, withCaption: "test caption", withCompletion: nil)
            
            // Dismiss UIImagePickerController to go back to your original view controller
            dismissViewControllerAnimated(true, completion: nil)
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

extension TimelineViewController: PathMenuDelegate {
    func pathMenu(menu: PathMenu, didSelectIndex idx: Int) {
        self.presentViewController(imagePicker, animated: true, completion: nil)
        print("Select the index : \(idx)")
    }
    
    func pathMenuWillAnimateOpen(menu: PathMenu) {
        UIView.animateWithDuration(0.35) {
            self.blurMaskView.alpha = 0.5
        }
    }
    
    func pathMenuWillAnimateClose(menu: PathMenu) {
        
        UIView.animateWithDuration(0.35) {
            self.blurMaskView.alpha = 0
        }
    }
    
    func pathMenuDidFinishAnimationOpen(menu: PathMenu) {
    }
    
    func pathMenuDidFinishAnimationClose(menu: PathMenu) {
    }
}

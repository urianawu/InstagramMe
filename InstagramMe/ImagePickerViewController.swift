//
//  ImagePickerViewController.swift
//  InstagramMe
//
//  Created by you wu on 3/4/16.
//  Copyright © 2016 You Wu. All rights reserved.
//

import UIKit

class ImagePickerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        //add image picker
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            // Get the image captured by the UIImagePickerController
            let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            //let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            
            
            dismissViewControllerAnimated(false, completion: nil)
            self.performSegueWithIdentifier("toCaptionSegue", sender: originalImage)
            
            
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let compose = segue.destinationViewController as? ComposeViewController {
            compose.photo = sender as! UIImage
        }
    }
    

}

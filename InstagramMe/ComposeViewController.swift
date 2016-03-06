//
//  ComposeViewController.swift
//  InstagramMe
//
//  Created by you wu on 3/4/16.
//  Copyright © 2016 You Wu. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {

    var photo: UIImage!
    var resizedPhoto: UIImage!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var captionView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if photo != nil {
            resizedPhoto = Post.resize(photo, newSize: CGSize(width: 400, height: 400))
        }
        photoView.image = resizedPhoto
        captionView.delegate = self
        captionView.text = "What's on your mind?"
        captionView.textColor = UIColor.lightGrayColor()
        captionView.selectedTextRange = captionView.textRangeFromPosition(captionView.beginningOfDocument, toPosition: captionView.beginningOfDocument)
        
        captionView.becomeFirstResponder()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:NSString = textView.text
        let updatedText = currentText.stringByReplacingCharactersInRange(range, withString:text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            textView.text = "Caption your photo"
            textView.textColor = UIColor.lightGrayColor()
            
            textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            
            return false
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if textView.textColor == UIColor.lightGrayColor() && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
        
        return true
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGrayColor() {
                textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            }
        }
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

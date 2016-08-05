//
//  ReportVC.swift
//  Friendlies
//
//  Created by Gordon Seto on 2016-08-05.
//  Copyright © 2016 gordonseto. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ReportVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    var userUid: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        textView.delegate = self
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let maxtext: Int = 200
        //If the text is larger than the maxtext, the return is false
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return textView.text.characters.count + (text.characters.count - range.length) <= maxtext
    }
    
    @IBAction func onBackButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSubmitPressed(sender: AnyObject) {
        
        guard let userUid = userUid else { return }
        
        let firebase = FIRDatabase.database().reference()
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .MediumStyle
        
        let dateString = formatter.stringFromDate(date)
        
        submitButton.enabled = false
        textView.userInteractionEnabled = false
        if let uid = NSUserDefaults.standardUserDefaults().objectForKey("USER_UID") as? String {
            if let message = textView.text as? String {
                let report: [String: AnyObject] = ["reported_by": uid, "time": dateString, "message": message]
                firebase.child("reports").child(userUid).childByAutoId().setValue(report)
                submitButton.setTitle("Report submitted!", forState: .Normal)
            }
        }
    }
}

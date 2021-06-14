//
//  ContactUsVC.swift
//  Eventor
//
//  Created by Saleh on 05/08/1440 AH.
//  Copyright © 1440 Eventor. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ContactUsVC: UIViewController, UITextViewDelegate {
    var ref: DatabaseReference!
    
    @IBOutlet weak var message: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        HindeKeyboardViewTouched()
        message.layer.cornerRadius = 15
        textFieldsMaxLength()
        
        ref = Database.database().reference().child("ContactUs")
    }
    
    func textFieldsMaxLength() {
        message.delegate = self
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        switch textView {
        case message:
            let maxLength = 250
            let currentString: NSString = textView.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: text) as NSString
            return newString.length <= maxLength
        default:
            return false
        }
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        if (message.text == "") {
            messageEmptyAllert(title: "The message should not be empty!", message: "")
        } else {
            guard let key = ref.child("ContactUs").childByAutoId().key else { return }
            let userMessage = ["UID": currnetUser.UID,
                               "messageDateTime": Date().description(with: .current),
                               "body": self.message.text] as NSDictionary
            let childUpdates = ["\(key)": userMessage]
            ref.updateChildValues(childUpdates)
            
            messageRecievedAllert(title: "Thanks for your time", message: "We got your message")
        }
    }
    
    func messageEmptyAllert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func messageRecievedAllert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

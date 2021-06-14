////
////  keyboardExtention.swift
////  LCApp
////
////  Created by YAZEED NASSER on 19/01/2019.
////  Copyright © 2019 . All rights reserved.
////
//
//import Foundation
//import UIKit
//
////to dismiss keyboard when tuoch anywhree in the screen
//extension UIViewController {
//    func HindeKeyboardViewTouched(){
//        //handel dissmising keyboard
//        let Tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.DismissKeyboard))
//        Tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(Tap)
//    }
//
//    @objc func DismissKeyboard(){
//        view.endEditing(true)
//    }
//}
//
////note: write this  code --V in (viewdidload)
////           HindeKeyboardViewTouched()
//
////###############################################
//
//extension UIViewController{
//
//    func moveViewUpWhenTxtTouched(){
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0 {
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.view.frame.origin.y != 0 {
//            self.view.frame.origin.y = 0
//        }
//    }
//
//}
//
//
//

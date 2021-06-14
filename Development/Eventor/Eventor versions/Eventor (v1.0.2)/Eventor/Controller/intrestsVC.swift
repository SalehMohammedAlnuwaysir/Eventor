//
//  intrestsVC.swift
//  Eventor
//
//  Created by YAZEED NASSER on 29/03/2019.
//  Copyright © 2019 Eventor. All rights reserved.
//

import UIKit

class intrestsVC: UIViewController {

    let selectedColor:UIColor = UIColor(named: "orangRed3")!
    let unSelectedColr:UIColor = UIColor.lightGray
    
    var ArrayOfIntrests:[String]!
    var callerVC:UIViewController!
    
    @IBOutlet weak var saveBBtn:UIButtonX!

    @IBOutlet weak var ABt:UIButtonX!
    @IBOutlet weak var BBt:UIButtonX!
    @IBOutlet weak var CBt:UIButtonX!
    @IBOutlet weak var DBt:UIButtonX!
    @IBOutlet weak var EBt:UIButtonX!
    @IBOutlet weak var FBt:UIButtonX!
    @IBOutlet weak var GBt:UIButtonX!
    @IBOutlet weak var HBt:UIButtonX!

    override func viewDidLoad() {
        super.viewDidLoad()
        HindeKeyboardViewTouched()
        
        updateIntrestsView()
    }

    @IBAction func ABtnPressed(_ sender:UIButtonX){
        self.selectIntrestBtn(Btn:sender)
    }
    
    @IBAction func SaveBtnPressed(_ sender:Any){
        handelIntrestsSaveBtn()
        passDateToCaller(data: ArrayOfIntrests)
        self.dismiss(animated: true, completion: nil)
    }
  
    func selectIntrestBtn(Btn:UIButtonX){
        UIView.animate(withDuration: 0.3, animations: {
            if Btn.backgroundColor == self.selectedColor {
                Btn.backgroundColor = self.unSelectedColr
                Btn.transform = .identity
            } else {
                Btn.backgroundColor = self.selectedColor
                Btn.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            }
        })
    }
    
    func updateIntrestsView() {
        ABt.backgroundColor = unSelectedColr
        BBt.backgroundColor = unSelectedColr
        CBt.backgroundColor = unSelectedColr
        DBt.backgroundColor = unSelectedColr
        EBt.backgroundColor = unSelectedColr
        FBt.backgroundColor = unSelectedColr
        GBt.backgroundColor = unSelectedColr
        HBt.backgroundColor = unSelectedColr
        
        for i in ArrayOfIntrests{
            switch i {
            case "Science": selectIntrestBtn(Btn:ABt)
            break;
            case "Computer": selectIntrestBtn(Btn:BBt)
            break;
            case "Comedy": selectIntrestBtn(Btn:CBt)
            break;
            case "Sports": selectIntrestBtn(Btn:DBt)
            break;
            case "Books": selectIntrestBtn(Btn:EBt)
            break;
            case "Food": selectIntrestBtn(Btn:FBt)
            break;
            case "Art": selectIntrestBtn(Btn:GBt)
            break;
            case "Other": selectIntrestBtn(Btn:HBt)
            break;
            default:
                break;
            }
        }
        print("Selected----------------------")
        print(ArrayOfIntrests)
    }
    
    func handelIntrestsSaveBtn(){
        ArrayOfIntrests = []
        if ABt.backgroundColor == selectedColor{
            ArrayOfIntrests.append((ABt.titleLabel?.text)!)
        }
        if BBt.backgroundColor == selectedColor{
            ArrayOfIntrests.append((BBt.titleLabel?.text)!)
        }
        if CBt.backgroundColor == selectedColor{
            ArrayOfIntrests.append((CBt.titleLabel?.text)!)
        }
        if DBt.backgroundColor == selectedColor{
            ArrayOfIntrests.append((DBt.titleLabel?.text)!)
        }
        if EBt.backgroundColor == selectedColor{
            ArrayOfIntrests.append((EBt.titleLabel?.text)!)
        }
        if FBt.backgroundColor == selectedColor{
            ArrayOfIntrests.append((FBt.titleLabel?.text)!)
        }
        if GBt.backgroundColor == selectedColor{
            ArrayOfIntrests.append((GBt.titleLabel?.text)!)
        }
        if HBt.backgroundColor == selectedColor{
            ArrayOfIntrests.append((HBt.titleLabel?.text)!)
        }
        
    }
    
    func passDateToCaller(data:[String]){
        if callerVC.title  == "CreateEventVC"{
            (callerVC as! CreateEventVC).intrestsArr = ArrayOfIntrests
        }else if callerVC.title  == "ProfileVC"{
            (callerVC as! ProfileVC).intrestsArr = ArrayOfIntrests
        }
    }
}

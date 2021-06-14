//
//  rateVolVC.swift
//  Eventor
//
//  Created by YAZEED NASSER on 05/04/2019.
//  Copyright © 2019 Eventor. All rights reserved.
//

import UIKit

class rateVolVC: UIViewController {
    var callerVC:ViewEventVC!
    var VolObbj:normalUser!
    var EveObbj:Event!
    
    @IBOutlet weak var nameLbl:UILabel!
    @IBOutlet weak var closeBtn:UIButton!
    @IBOutlet weak var submitBtn:UIButton!
    
    var numOfStarsPressed:Int = 0
    @IBOutlet weak var star1Btn:UIButton!
    @IBOutlet weak var star2Btn:UIButton!
    @IBOutlet weak var star3Btn:UIButton!
    @IBOutlet weak var star4Btn:UIButton!
    @IBOutlet weak var star5Btn:UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        HindeKeyboardViewTouched()
        ubdateView()
        // Do any additional setup after loading the view.
    }
    func ubdateView(){
        //prepare
        let unpressedColor = UIColor.white
        
        star1Btn.tintColor = unpressedColor
        star2Btn.tintColor = unpressedColor
        star3Btn.tintColor = unpressedColor
        star4Btn.tintColor = unpressedColor
        star5Btn.tintColor = unpressedColor
        
        if let volObbj = self.VolObbj,
            let name = volObbj.name {
            nameLbl.text = "Name: \(name)"
        }

    }
    
    @IBAction func starBtnPressed(_ sender:UIButton){
        ubdateView()
        
        let pressedColor = UIColor(named: "orangRed1")
        self.numOfStarsPressed = sender.tag
        
        switch numOfStarsPressed {
            
        case 5: print("5 stars")
        star5Btn.tintColor = pressedColor
        star4Btn.tintColor = pressedColor
        star3Btn.tintColor = pressedColor
        star2Btn.tintColor = pressedColor
        star1Btn.tintColor = pressedColor
        break;
            
        case 4: print("4 stars")
        star4Btn.tintColor = pressedColor
        star3Btn.tintColor = pressedColor
        star2Btn.tintColor = pressedColor
        star1Btn.tintColor = pressedColor
        break;
            
        case 3: print("3 stars")
        star3Btn.tintColor = pressedColor
        star2Btn.tintColor = pressedColor
        star1Btn.tintColor = pressedColor
        break;
            
        case 2: print("2 stars")
        star2Btn.tintColor = pressedColor
        star1Btn.tintColor = pressedColor
        break;
            
        case 1: print("1 star")
        star1Btn.tintColor = pressedColor
        break;
            
        default:
            break;
        }
    }
    
    @IBAction func closeBtnPressed(_ sender:Any){
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitBtnPressed(_ sender:Any){
        if numOfStarsPressed != 0{
            let theRate:Double = Double(numOfStarsPressed) * 20.0
            if let uid = VolObbj.UID,
                let EID = self.EveObbj.EID{
                FBDBHandler.FBDBHandlerObj.rateAcceptedVol(EID:EID,UID: uid, Rate: theRate)
                doAfterFinsh()
                ProgressHUD.showSuccess("Success")
                closeBtnPressed(self)
            }
        } else {
            notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "Rate can Not be 0!", color: .red)
        }
    }
    
    func doAfterFinsh(){
        if let vc = callerVC{
            vc.volunteersTableView.reloadData()
        }
    }
}

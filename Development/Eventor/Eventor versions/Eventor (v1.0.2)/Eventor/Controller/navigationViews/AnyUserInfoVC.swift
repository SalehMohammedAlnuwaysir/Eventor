//
//  AnyUserInfoVC.swift
//  Eventor
//
//  Created by YAZEED NASSER on 30/03/2019.
//  Copyright © 2019 Eventor. All rights reserved.
//

import UIKit

class AnyUserInfoVC: UIViewController {
    
    var UserObj:userGeneral!
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    //volunteer stars
    @IBOutlet weak var theWholeStarsAndLblView: UIViewX!
    @IBOutlet weak var theWholeStarsView: UIView!
    @IBOutlet weak var starsLbl: UILabel!
    @IBOutlet weak var starNo1: UIImageView!
    @IBOutlet weak var starNo2: UIImageView!
    @IBOutlet weak var starNo3: UIImageView!
    @IBOutlet weak var starNo4: UIImageView!
    @IBOutlet weak var starNo5: UIImageView!
    
    @IBOutlet weak var ExpereancLbl:UILabel!
    @IBOutlet weak var ExpereancDescLbl:UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateView()
    }
   
    func updateView(){
    //prepare
        ExpereancLbl.isHidden = true
        ExpereancDescLbl.isHidden = true
        theWholeStarsView.isHidden = true
        nameLbl.text = ""
        profileImgView.image = UIImage(named: "Profile-photo")
        
        if UserObj != nil {
            if UserObj.uType == userGeneral.getNUStrFormat(){
                updateViewForNU()
            } else if UserObj.uType == userGeneral.getEMStrFormat(){
                updateViewForEM()
            } else {
                print("profile Type is not of type - normalUser or eventManger!")
            }
        } else {
            print("Error-Yazeed: did NOT reseve the userObject while updating the view !")
        }
    }
    
    func updateViewForNU(){
        let NU:normalUser = UserObj as! normalUser
        nameLbl.text = NU.name
        showAndUpdateVolStarsHandler()
        FBDBHandler.FBDBHandlerObj.getImageBy(URL: NU.picURL, imageViewToLoadOn: profileImgView)
    }
    
    func updateViewForEM(){
        let EM:eventManager = UserObj as! eventManager
        nameLbl.text = EM.name
        FBDBHandler.FBDBHandlerObj.getImageBy(URL: EM.picURL, imageViewToLoadOn: profileImgView)
    }
    
    func showAndUpdateVolStarsHandler(){
        if UserObj.uType == userGeneral.getNUStrFormat() {//check wether the user is volunter
            if (UserObj as! normalUser).didVol {
                //prepare
                ExpereancLbl.isHidden = false
                ExpereancDescLbl.isHidden = false

                theWholeStarsView.isHidden = false
                starsLbl.text = "0"
                starNo5.tintColor = UIColor.white
                starNo4.tintColor = UIColor.white
                starNo3.tintColor = UIColor.white
                starNo2.tintColor = UIColor.white
                starNo1.tintColor = UIColor.white
                
                //start proccess
                
                ExpereancDescLbl.text = (UserObj as! normalUser).experians
                
                starsLbl.text = String(format: "%03d", ((UserObj as! normalUser).numrRates ?? 0))
                
                let numofStars:Int = (UserObj as! normalUser).getNumOfStarsToShow()
                switch numofStars {
                case 5:
                    starNo5.tintColor = UIColor(named: "orangRed1")
                    starNo4.tintColor = UIColor(named: "orangRed1")
                    starNo3.tintColor = UIColor(named: "orangRed1")
                    starNo2.tintColor = UIColor(named: "orangRed1")
                    starNo1.tintColor = UIColor(named: "orangRed1")
                    break
                case 4:
                    starNo5.tintColor = UIColor.white
                    starNo4.tintColor = UIColor(named: "orangRed1")
                    starNo3.tintColor = UIColor(named: "orangRed1")
                    starNo2.tintColor = UIColor(named: "orangRed1")
                    starNo1.tintColor = UIColor(named: "orangRed1")
                    break
                case 3:
                    starNo5.tintColor = UIColor.white
                    starNo4.tintColor = UIColor.white
                    starNo3.tintColor = UIColor(named: "orangRed1")
                    starNo2.tintColor = UIColor(named: "orangRed1")
                    starNo1.tintColor = UIColor(named: "orangRed1")
                    break
                case 2:
                    starNo5.tintColor = UIColor.white
                    starNo4.tintColor = UIColor.white
                    starNo3.tintColor = UIColor.white
                    starNo2.tintColor = UIColor(named: "orangRed1")
                    starNo1.tintColor = UIColor(named: "orangRed1")
                case 1:
                    starNo5.tintColor = UIColor.white
                    starNo4.tintColor = UIColor.white
                    starNo3.tintColor = UIColor.white
                    starNo2.tintColor = UIColor.white
                    starNo1.tintColor = UIColor(named: "orangRed1")
                    break
                default:
                    break
                }
            }
        }
    }
}

//
//  ProfileVC.swift
//  Eventor
//
//  Created by Saleh on 19/05/1440 AH.
//  Copyright © 1440 Eventor. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileVC: UIViewController {
    
    @IBOutlet weak var profileImgView: UIImageView!
    //labels
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var DOBLbl: UILabel!
    
    //volunteer stars
    @IBOutlet weak var theWholeStarsView: UIView!
    @IBOutlet weak var starsLbl: UILabel!
    @IBOutlet weak var starNo1: UIImageView!
    @IBOutlet weak var starNo2: UIImageView!
    @IBOutlet weak var starNo3: UIImageView!
    @IBOutlet weak var starNo4: UIImageView!
    @IBOutlet weak var starNo5: UIImageView!
    
    //buttons
    @IBOutlet weak var eveToVolBtn: UIButton!
    @IBOutlet weak var eveToSponsorBtn: UIButton!
    @IBOutlet weak var joinedEveBtn: UIButton!
    @IBOutlet weak var subscribedEveBtn: UIButton!
    @IBOutlet weak var sponsoredEveBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Auth.auth().currentUser!.uid)
        // Do any additional setup after loading the view.
        self.updateView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //acctions
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print (logoutError)
        }
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let WelcomeVC = Storyboard.instantiateViewController(withIdentifier: "WelcomeVC")
        self.present(WelcomeVC, animated: true, completion: nil)
    }
    @IBAction func editProfileBtnPressed(_ sender: Any) {
    }
    
    @IBAction func eveToVolBtnPressed(_ sender: Any) {
    }
    @IBAction func eveToSponsorBtnPressed(_ sender: Any) {
    }
    @IBAction func joinedEveBtnPressed(_ sender: Any) {
    }
    @IBAction func subscribedEveBtnPressed(_ sender: Any) {
    }
    @IBAction func sponsoredEveBtnPressed(_ sender: Any) {
    }
    
    func updateView(){
        //prepare
        DOBLbl.isHidden = true
        eveToVolBtn.isHidden = true
        eveToSponsorBtn.isHidden = true
        joinedEveBtn.isHidden = true
        subscribedEveBtn.isHidden = true
        sponsoredEveBtn.isHidden = true
        
        
        //updating the view acording to the user type
        if currnetUser.uType == userGeneral.getAdminStrFormat(){
            self.updateViewForAdmin()
        }
        else if currnetUser.uType == userGeneral.getEMStrFormat(){
            self.updateViewForEM()
        }
        else if currnetUser.uType == userGeneral.getNUStrFormat(){
            self.updateViewForNU()
        }
        
    }
    func updateViewForAdmin(){//admin View
    }
    func updateViewForEM(){//event manager View
        let profileImgURL:String = (currnetUser as! eventManager).picURL
        FBDBHandler.FBDBHandlerObj.getImageBy(URL: profileImgURL, imageViewToLoadOn: profileImgView)
        nameLbl.text = (currnetUser as! eventManager).name
        
        eveToSponsorBtn.isHidden = false
        sponsoredEveBtn.isHidden = false
    }
    func updateViewForVol(){//volunteer View
        let profileImgURL:String = (currnetUser as! normalUser).picURL
        FBDBHandler.FBDBHandlerObj.getImageBy(URL: profileImgURL, imageViewToLoadOn: profileImgView)

        nameLbl.text = (currnetUser as! normalUser).name
        DOBLbl.text = (currnetUser as! normalUser).DOB.getDateFormatAsString()
        
        DOBLbl.isHidden = false
        eveToVolBtn.isHidden = false
        joinedEveBtn.isHidden = false
        subscribedEveBtn.isHidden = false
        
        //showing stars
        self.showAndUpdateVolStars()
    }
    func updateViewForNU(){//normal user View
        let profileImgURL:String = (currnetUser as! normalUser).picURL
        FBDBHandler.FBDBHandlerObj.getImageBy(URL: profileImgURL, imageViewToLoadOn: profileImgView)

        nameLbl.text = (currnetUser as! normalUser).name
        DOBLbl.text = (currnetUser as! normalUser).DOB.getDateFormatAsString()

        DOBLbl.isHidden = false
        subscribedEveBtn.isHidden = false
        
        
    }
    
    func showAndUpdateVolStars(){
        if currnetUser.uType == userGeneral.getNUStrFormat() {//check wether the user is volunter
            //prepare
            theWholeStarsView.isHidden = false
            starsLbl.text = "0"
            starNo1.tintColor = UIColor.lightGray
            starNo2.tintColor = UIColor.lightGray
            starNo3.tintColor = UIColor.lightGray
            starNo4.tintColor = UIColor.lightGray
            starNo5.tintColor = UIColor.lightGray
            
            //start proccess
            starsLbl.text = String(format: "%03d", ((currnetUser as! normalUser).numrRates ?? 0))
            
            let numofStars:Int = (currnetUser as! normalUser).getNumOfStarsToShow()
            
            switch numofStars {
            case 5:
                starNo5.tintColor = UIColor.orange
                starNo4.tintColor = UIColor.orange
                starNo3.tintColor = UIColor.orange
                starNo2.tintColor = UIColor.orange
                starNo1.tintColor = UIColor.orange
                break
            case 4:
                starNo4.tintColor = UIColor.orange
                starNo3.tintColor = UIColor.orange
                starNo2.tintColor = UIColor.orange
                starNo1.tintColor = UIColor.orange
                break
            case 3:
                starNo3.tintColor = UIColor.orange
                starNo2.tintColor = UIColor.orange
                starNo1.tintColor = UIColor.orange
                break
            case 2:
                starNo2.tintColor = UIColor.orange
                starNo1.tintColor = UIColor.orange
            case 1:
                starNo1.tintColor = UIColor.orange
                break
            default:
                break
            }
        }
        
        
    }
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

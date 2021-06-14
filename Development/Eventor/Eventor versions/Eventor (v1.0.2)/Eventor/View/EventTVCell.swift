//
//  EventTVCell.swift
//  Eventor
//
//  Created by YAZEED NASSER on 26/03/2019.
//  Copyright © 2019 Eventor. All rights reserved.
//

import UIKit

class EventTVCell: UITableViewCell {


    @IBOutlet weak var EveImageView: UIImageView!
    @IBOutlet weak var EvntTitLbl:UILabel!
    @IBOutlet weak var EveDescLbl:UILabel!
    @IBOutlet weak var EveAttTypeLbl:UILabel!
    @IBOutlet weak var EveTimeLbl:UILabel!
    @IBOutlet weak var SopnsorBtn:UIButton!
    var showSponsorBtn:Bool = false
    var mainVC:UIViewController!
    
    var EveObj:Event = Event.init() {
        didSet{
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateView(){
        SopnsorBtn.isHidden = !showSponsorBtn
        
        if  let eveImgURL = EveObj.EventImageURL,
            let eveTitel = EveObj.EventName,
            let eveDesc = EveObj.EventDescription,
            let eveAttType = EveObj.AttendenceType,
            let eveTime = EveObj.EventTime.getBothTimesInOneString() as? String,
            let ImgView:UIImageView = EveImageView{
            
                EvntTitLbl?.text = eveTitel
                EveDescLbl?.text = eveDesc
                EveAttTypeLbl?.text = eveAttType
                EveTimeLbl?.text = eveTime
            
                FBDBHandler.FBDBHandlerObj.getImageBy(URL: eveImgURL, imageViewToLoadOn: ImgView)

        }
    }
    
    @IBAction func SponsorBtnPressed(){
        if currnetUser.uType == userGeneral.getEMStrFormat(){
            if let UID = currnetUser.UID,
                let EID = EveObj.EID{
                refrishingHanler.refrishingHanlerObj.startRefrising(view: mainVC.view)
                FBDBHandler.FBDBHandlerObj.sponsorAnEvent(UID: UID, EID: EID, onSucces: {
                    
                    refrishingHanler.refrishingHanlerObj.endRefrising(view: self.mainVC.view)
                    notificationHelper.notificationHelperObj.showError(callerVC: self.mainVC, Err: "Event Sponsored successfully", color: .green)
                    
                    self.mainVC.navigationController?.popViewController(animated: true)
                    FBDBHandler.FBDBHandlerObj.loadEves(onSucces: {
                        FBDBHandler.FBDBHandlerObj.loadMyUser(UID: currnetUser.UID, onSucces: {})
                    }, onError: {_ in})
                    
                    }, onError: {
                        refrishingHanler.refrishingHanlerObj.endRefrising(view: self.mainVC.view)
                        notificationHelper.notificationHelperObj.showError(callerVC: self.mainVC, Err: "an error happend", color: .red)

                })
            }
        }
    }
    
    
    
}

//
//  EventCollectionViewCell.swift
//  Eventor
//
//  Created by YAZEED NASSER on 23/03/2019.
//  Copyright © 2019 Eventor. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class EventCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ImgView:UIImageView!
    @IBOutlet weak var TitelLbl:UILabel!
    @IBOutlet weak var BGColorView:UIView!
    @IBOutlet weak var SubscriptionLbl:UILabel!
    @IBOutlet weak var DescriptionLbl:UILabel!
    @IBOutlet weak var TypeLbl:UILabel!
    @IBOutlet weak var TimeLbl:UILabel!
    
    let Ref: DatabaseReference = Database.database().reference()
    
    var EventObj:Event? {
        didSet {
            updateView()
        }
    }
    
    func updateView(){
        if let ImgURL:String = EventObj?.EventImageURL,
            let Titel:String = EventObj?.EventName,
            let Descr:String = EventObj?.EventDescription,
            let type:String = EventObj?.AttendenceType {
            FBDBHandler.FBDBHandlerObj.getImageBy(URL: ImgURL, imageViewToLoadOn: self.ImgView)
            self.TitelLbl.text = Titel
            self.BGColorView.backgroundColor = UIColor.gray
            FBDBHandler.FBDBHandlerObj.loadIdOfSubscribers(EventObj: EventObj!, completion: {
                self.SubscriptionLbl.text = "\(String(describing: self.EventObj!.getNumOfSubscribers()))"
            })
            self.DescriptionLbl.text = Descr
            self.TypeLbl.text = type
            self.TimeLbl.text = EventObj!.EventTime.getBothTimesInOneString()
        }
        
        
    }
    
    override func awakeFromNib() {
        ImgView.image = UIImage(named: "imagePlaceholder")
    }
    
    //styles
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 3.0
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.4
        
        self.layer.shadowOffset =  CGSize(width: 5, height: 10)
        
        self.clipsToBounds = false
        
    }
    
}

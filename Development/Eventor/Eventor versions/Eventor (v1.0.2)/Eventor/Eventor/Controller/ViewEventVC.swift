//
//  ViewEventVC.swift
//  Eventor
//
//  Created by Saleh on 05/06/1440 AH.
//  Copyright © 1440 Eventor. All rights reserved.
//

import UIKit

class ViewEventVC: UIViewController {

    @IBOutlet weak var EventImage: UIImageView!
    @IBOutlet weak var EventDescription: UILabel!
    @IBOutlet weak var ShareButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var EMName: UILabel!
    @IBOutlet weak var EventName: UILabel!
    @IBOutlet weak var attendenceType: UILabel!
    @IBOutlet weak var Time: UILabel!
    @IBOutlet weak var subscribeBtn: UIButton!
    @IBOutlet weak var VolunteerBtn: UIButton!
    
    var EventimageURL = ""
    var Description = ""
    var profileImageURL = ""
    var EventManagerName = ""
    var EventNameString = ""
    var EventattendenceType = ""
    var EventTime = ""
    var Eventdate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.cornerRadius = 32
        profileImage.clipsToBounds = true
        
        EventImage.clipsToBounds = true
        
        EventImage.loadImageURLStringUsingCashe(StringURL: EventimageURL)
        EventDescription.text = Description
        profileImage.loadImageURLStringUsingCashe(StringURL: profileImageURL)
        EMName.text = EventManagerName
        EventName.text = EventNameString
        attendenceType.text = EventattendenceType
        Time.text = EventTime
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

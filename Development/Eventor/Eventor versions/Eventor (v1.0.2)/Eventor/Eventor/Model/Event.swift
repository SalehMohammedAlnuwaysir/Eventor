//
//  Event.swift
//  Eventor
//
//  Created by YAZEED NASSER on 08/02/2019.
//  Copyright © 2019 Eventor. All rights reserved.
//

import Foundation

var allEventsGlobalArry:[Event] = []

class Event: NSObject {
    var EID:String!
    var EventName: String
    var AttendenceType: String
    var EventDescription: String
    var EventImageURL: String?
    var EventManagerID: String
    var EventFromTime: String
    var EventToTime: String
    var EventDate: String
    var Eventlatitude: Double
    var Eventlongitude: Double
    var PostedDate: String
    
    init(EventNameTxt: String, AttendenceTypeTxt: String, EventDescriptionTxt: String, EventImageURLString: String, EMID: String, EFT: String, ETT: String, ED: String, Elatitude: Double, Elongitude: Double, postedDate: String) {
        EventName = EventNameTxt
        AttendenceType = AttendenceTypeTxt
        EventDescription = EventDescriptionTxt
        EventImageURL = EventImageURLString
        EventManagerID = EMID
        EventFromTime = EFT
        EventToTime = ETT
        EventDate = ED
        Eventlatitude = Elatitude
        Eventlongitude = Elongitude
        PostedDate = postedDate
    }
}

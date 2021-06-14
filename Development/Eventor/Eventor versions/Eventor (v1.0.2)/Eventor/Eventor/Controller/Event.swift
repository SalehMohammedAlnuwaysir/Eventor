//
//  Event.swift
//  Eventor
//
//  Created by Saleh on 03/06/1440 AH.
//  Copyright © 1440 Eventor. All rights reserved.
//

import Foundation

class Event {
    var EventName: String
    var AttendenceType: String
    var EventDescription: String
    var EventImageURL: String
    var EventManagerID: String
    
    init(EventNameTxt: String, AttendenceTypeTxt: String, EventDescriptionTxt: String, EventImageURLString: String, EMID: String) {
        EventName = EventNameTxt
        AttendenceType = AttendenceTypeTxt
        EventDescription = EventDescriptionTxt
        EventImageURL = EventImageURLString
        EventManagerID = EMID
    }
}

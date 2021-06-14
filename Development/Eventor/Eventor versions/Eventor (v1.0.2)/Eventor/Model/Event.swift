//
//  Event.swift
//  Eventor
//
//  Created by YAZEED NASSER on 08/02/2019.
//  Copyright © 2019 Eventor. All rights reserved.
//

import Foundation

var allEventsGlobalArry:[Event] = []
var allEventsToSponsorGlobalArry:[Event] = []

class Event: NSObject {
    var EID:String!
    var EventName: String!
    var AttendenceType: String!
    var EventDescription: String!
    var EventImageURL: String?
    var EventManagerID: String!
    var EventTime:time!
    var EventFDate: date!
    var EventEDate: date!

    var Eventlatitude: Double!
    var Eventlongitude: Double!
    var NeedVol:Bool!
    var EventVols:[EvePerson]?
    
    var EventIntrests:[String]?

    var subUsers:[String]!

    override init() {
        
        self.EID = ""
        EventName = ""
        AttendenceType = ""
        EventDescription = ""
        EventImageURL = ""
        EventManagerID = ""
        EventTime = time.init()
        EventFDate = date.init()
        EventEDate = date.init()

        Eventlatitude = 0.0
        Eventlongitude = 0.0
        NeedVol = false
        
    }
    
    init(EID: String, EventNameTxt: String, AttendenceTypeTxt: String, EventDescriptionTxt: String, EventImageURLString: String,EveIntrests:[String], EMID: String,ET:time,  FD: date,ED: date, Elatitude: Double, Elongitude: Double, needVol: Bool) {
        self.EID = EID
        EventName = EventNameTxt
        AttendenceType = AttendenceTypeTxt
        EventDescription = EventDescriptionTxt
        EventImageURL = EventImageURLString
        EventIntrests = EveIntrests
        EventManagerID = EMID
        EventTime = ET
        
        EventFDate = FD
        EventEDate = ED

        Eventlatitude = Elatitude
        Eventlongitude = Elongitude
        NeedVol = needVol
    }
    
    
    func getAcceptedVols()-> [EvePerson]{
        var acceptedVols:[EvePerson] = []
        for per in EventVols!{
            if per.didAccepted {
                acceptedVols.append(per)
            }
        }
        return acceptedVols
    }
    
    func getUnAcceptedVols()-> [EvePerson]{
        var unAcceptedVols:[EvePerson] = []
        for per in EventVols!{
            if !per.didAccepted {
                unAcceptedVols.append(per)
            }
        }
        return unAcceptedVols
    }
    
    static func getEveListByIDsFromGolbEveArry(EIDs:[String])-> [Event]{
        var eveList:[Event] = []
        for eid in EIDs{
            let eve:Event = getEveByIDFromGolbEveArry(EID: eid)
            if eve.EID != ""{
                eveList.append(eve)
            }
        }
        return eveList
    }

    static func getEveByIDFromGolbEveArry(EID:String)-> Event{
        for eve in allEventsGlobalArry{
            if eve.EID == EID{
                return eve
            }
        }
        return Event.init()
    }
    
    static func getEvesToVolInList()->[Event]{
        var evesToVolInList:[Event] = []
        for eve in allEventsGlobalArry{
            if eve.NeedVol == true {
                evesToVolInList.append(eve)
            }
        }
        return evesToVolInList
    }
    

    static func getNumOfEveToSponsor() -> Int {
       return allEventsToSponsorGlobalArry.count
    }
    
    static func getNumOfEveNotToSponsor() -> Int {
        return allEventsGlobalArry.count
    }
    
    func getNumOfSubscribers() -> Int {
        return subUsers!.count
    }
}

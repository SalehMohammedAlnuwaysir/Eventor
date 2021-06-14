//
//  volunteer.swift
//  Eventor
//
//  Created by YAZEED NASSER on 08/02/2019.
//  Copyright © 2019 Eventor. All rights reserved.
//

import Foundation
class normalUser: userGeneral {
    var name:String!
    var intrests:[String]?
    var subEvents:[String]?
    var volEvents:[EvePerson]?
    var DOB:date!
    var city:String!
    var experians:String!
    var numrRates:Int!
    var totalRate:Double!
    var didVol:Bool!
    var MyNotifcation:[Notication]?

    
    init(UID:String,picURL:String,uType:String,uEmail:String,uPhone:String,uPassword:String,uStatus:Bool,name:String,intrests:[String],subEvents:[String],DOB:date,city:String,experians:String,numrRates:Int,totalRate:Double,didVol:Bool,MyNotifcation:[Notication]){
        super.init(UID: UID, picURL: picURL, uType: uType, uEmail: uEmail, uPhone: uPhone, uPassword: uPassword,uStatus:uStatus)
    
        
        self.name = name
        self.intrests = intrests
        self.subEvents = subEvents
        self.DOB = DOB
        self.city = city
        self.experians = experians
        self.numrRates = numrRates
        self.totalRate = totalRate
        self.didVol = didVol
        self.MyNotifcation = MyNotifcation
    }
    
    func getVolEveIds() -> [String]{
        var volEveIds:[String] = []
        if let volEvents = volEvents{
            for eve in volEvents{
                volEveIds.append(eve.EID)
            }
        }
        return volEveIds
    }
    
    func getNumOfStarsToShow()-> Int{
        if totalRate != 0{
            //will get the number of stars to show
            let theTotal:Double = Double(numrRates * 100)
            let theDefrance:Int = Int(theTotal / self.totalRate)
            
            //1...5 stars (to show)
            if 0 <= theDefrance && theDefrance <= 5{
                return (5 - theDefrance)
            }else {
                return 0
            }
        }else{
            //if no rates yet!
            return 0
        }
    }
    
    func didISubIn(EID:String) -> Bool {
        if let subEvents = subEvents{
            for eventid in subEvents{
                if eventid == EID{
                    return true
                }
            }
            return false
        }else{
            print("Warning_Yazeed: maybe You havent Subscribed yet in any Event  OR SubEvents[] Lits hasnt been loaded yet -> (to solv this problem just load my sub befor calling this method from [FBDBHandeler.FBDBHandelerObj.loadSubEveIdListFor()])")
            return false
        }
    }
    
    func didIVolIn(EID:String) -> Bool {
        if let volEvents = volEvents{
            for eventid in volEvents{
                if eventid.EID == EID{
                    return true
                }
            }
            return false
        } else {
            print("Warning_Yazeed: maybe You havent Volunteerd yet in any Event OR VolEvents[] Lits hasnt been loaded yet (to solv this problem just load my vol befor calling this method  [FBDBHandeler.FBDBHandelerObj.loadMyVoledEveIdListFor()] )")
            return false
        }
    }
    
    func isMyVolReqAcceptedIn(EID:String)->Bool{
        
        if let volEvents = volEvents{
            for eventid in volEvents{
                if eventid.EID == EID && eventid.didAccepted{
                    return true
                }
            }
            return false
        }else{
            print("Warning_Yazeed: maybe You havent Volunteerd yet in any Event OR VolEvents[] Lits hasnt been loaded yet (to solv this problem just load my vol befor calling this method  [FBDBHandeler.FBDBHandelerObj.loadMyVoledEveIdListFor()] )")
            return false
        }
    }
}

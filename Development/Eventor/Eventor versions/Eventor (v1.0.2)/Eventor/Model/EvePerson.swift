//
//  EveSponsor.swift
//  Eventor
//
//  Created by YAZEED NASSER on 28/03/2019.
//  Copyright © 2019 Eventor. All rights reserved.
//

import Foundation

//for volunteers and Sponsors
class EvePerson {
    let EID:String
    let volObj: normalUser?
    var didAccepted:Bool
    
    /* -for Event */
    init(volObj:normalUser,didAccepted:Bool){
        self.volObj = volObj
        self.didAccepted = didAccepted
        self.EID = ""
    }
    
    /* -for vol */
    init(EID:String,didAccepted:Bool){
        self.EID = EID
        self.didAccepted = didAccepted
        self.volObj = nil
    }
}

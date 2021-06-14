//
//  eventManager.swift
//  Eventor
//
//  Created by YAZEED NASSER on 08/02/2019.
//  Copyright © 2019 Eventor. All rights reserved.
//

import Foundation
class eventManager: userGeneral {
    
    var name:String!
    var address:String!
    var MyEvents:[String]?
    var city:String!
    
    init(UID:String,picURL:String,uType:String,uEmail:String,uPhone:String,uPassword:String,uStatus:Bool,name:String,address:String,MyEvents:[String],city:String){
        super.init(UID: UID,picURL:picURL, uType: uType, uEmail: uEmail, uPhone: uPhone, uPassword: uPassword,uStatus:uStatus)
        
        self.name = name
        self.address = address
        self.MyEvents = MyEvents
        self.city = city
    }
}

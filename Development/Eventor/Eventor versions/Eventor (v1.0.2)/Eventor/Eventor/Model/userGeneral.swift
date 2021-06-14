//
//  User.swift
//  Eventor
//
//  Created by YAZEED NASSER on 08/02/2019.
//  Copyright © 2019 Eventor. All rights reserved.
//

import Foundation

var currnetUser:userGeneral = normalUser.init(UID: "oooooo",picURL:"", uType: "volunteer", uEmail: "y@g.com", uPhone: "065444", uPassword: "1234554321",uStatus: true, name: "yazeed", intrests: [], subEvents: [], DOB : date.init(D: 1, M: "May", Y: 1999), city:"Riyadh", experians: "dont have!", numrRates: 5, totalRate: 350)


class userGeneral{
    
    var UID:String!
    var picURL:String!
    var uType:String!
    var uEmail:String!
    var uPhone:String!
    var uPassword:String!
    var uStatus:Bool!
    
    init(UID:String,picURL:String,uType:String,uEmail:String,uPhone:String,uPassword:String,uStatus:Bool){
        self.UID = UID
        self.picURL = picURL
        self.uType = uType
        self.uEmail = uEmail
        self.uPhone = uPhone
        self.uPassword = uPassword
        self.uStatus = uStatus
    }
    
    
    //String Formatas To compare And avoied misSpelling
    static func getAdminStrFormat()->String{
        return "admin"
    }
    static func getNUStrFormat()->String{
        return "normalUser"
    }
    static func getEMStrFormat()->String{
        return "eventManager"
    }
}

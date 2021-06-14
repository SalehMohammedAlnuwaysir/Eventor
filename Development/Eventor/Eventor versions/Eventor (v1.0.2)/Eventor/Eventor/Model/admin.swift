//
//  admin.swift
//  Eventor
//
//  Created by YAZEED NASSER on 08/02/2019.
//  Copyright © 2019 Eventor. All rights reserved.
//

import Foundation
class admin: userGeneral {
    
    override init(UID:String, picURL: String,uType:String,uEmail:String,uPhone:String,uPassword:String,uStatus:Bool){
        super.init(UID: UID, picURL: picURL, uType: uType, uEmail: uEmail, uPhone: uPhone, uPassword: uPassword,uStatus:uStatus)
        
    }
}

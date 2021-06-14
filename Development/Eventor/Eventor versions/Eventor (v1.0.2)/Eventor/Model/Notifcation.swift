//
//  Ntfcation.swift
//  Eventor
//
//  Created by YAZEED NASSER on 09/04/2019.
//  Copyright © 2019 Eventor. All rights reserved.
//

import Foundation

class Notication{
    let UOREid:String //uid for EM,EID for NU
    let Ntf:String
    
    init(UOREid:String,Ntf:String) {
        self.UOREid = UOREid
        self.Ntf = Ntf
    }
}

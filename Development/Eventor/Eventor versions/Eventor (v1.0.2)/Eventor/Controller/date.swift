//
//  date.swift
//  Eventor
//
//  Created by Saleh on 01/06/1440 AH.
//  Copyright © 1440 Eventor. All rights reserved.
//

import Foundation

class date{
    
    var _D:Int
    var _M:String
    var _Y:Int
    
    init(){
        _D = 0
        _M = ""
        _Y = 0
        
    }
    
    init(D:Int,M:String,Y:Int){
        _D = D
        _M = M
        _Y = Y
        
    }
    
    func getDateFormatAsString() -> String{
        return "\(_D)/\(_M)/\(_Y)"
    }
    
}

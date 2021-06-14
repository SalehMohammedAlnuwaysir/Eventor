//
//  volunteer.swift
//  Eventor
//
//  Created by YAZEED NASSER on 08/02/2019.
//  Copyright © 2019 Eventor. All rights reserved.
//

import Foundation
class volunteer: normalUser {
    var experians:String!
    var numrRates:Int!
    var totalRate:Double!
    
    init(UID:String,picURL:String,uType:String,uEmail:String,uPhone:String,uPassword:String,name:String,intrests:[String],subEvents:[String],DOB:date,city:String,experians:String,numrRates:Int,totalRate:Double){
        super.init(UID: UID, picURL: picURL, uType: uType, uEmail: uEmail, uPhone: uPhone, uPassword: uPassword, name: name, intrests: intrests, subEvents: subEvents,DOB:DOB,city:city)
        
        self.experians = experians
        self.numrRates = numrRates
        self.totalRate = totalRate
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
    
    
}

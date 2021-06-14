//
//  time.swift
//  Eventor
//
//  Created by Saleh on 01/06/1440 AH.
//  Copyright © 1440 Eventor. All rights reserved.
//

import Foundation
import UIKit

class time{
    
    var _fromTimeHH:String
    var _fromTimeMM:String
    var _toTimeHH:String
    var _toTimeMM:String
    
    
    init(){
        _fromTimeHH = "0"
        _fromTimeMM = "0"
        _toTimeHH = "0"
        _toTimeMM = "0"
        
    }
    
    init(timetype:String,fromTimeHH:String,fromTimeMM:String,toTimeHH:String,toTimeMM:String){
        _fromTimeHH = fromTimeHH
        _fromTimeMM = fromTimeMM
        _toTimeHH = toTimeHH
        _toTimeMM = toTimeMM
        
        
    }
    
    
    func getFromTimeFormatAsString() -> String{
        return "من \(_fromTimeHH):\(_fromTimeMM)"
    }
    func getToTimeFormatAsString() -> String{
        return "الى \(_toTimeHH):\(_toTimeMM)"
    }
}

extension Date {//To get the time from Piker
    static func calculateDate(hour: Int, minute: Int) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "en_US_PSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let calculatedDate = formatter.date(from: "\(hour):\(minute)")
        return calculatedDate!
    }
    
    func getHourMinute() -> (hour: String , minute: String) {
        let calendar = Calendar.current
        var hour = String(calendar.component(.hour, from: self))
        var minute = String(calendar.component(.minute, from: self))
        
        if hour.count == 1 && hour == "0"{
            hour = "0\(hour)"
        }
        if minute.count == 1 {
            minute = "0\(minute)"
        }
        return (hour, minute)
    }
    
    func getDMY() ->(D:Int,M:String,Y:Int){
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day,.month,.year], from: self)
        if let day = components.day, let month = components.month, let year = components.year {
            let D = Int(day)
            let M = String(month)
            let Y = Int(year)
            return (D,M,Y)
        }
        return (0,"",0)
    }
}


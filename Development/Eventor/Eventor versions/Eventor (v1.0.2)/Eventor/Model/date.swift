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
    
    func getIntFromD()->Int{
        if let d = Int?(_D){
            return d
        }
        return 0
        
    }
    func getIntFromM()->Int{
        if let d = Int(_M){
            return d
        }
        return 0
        
    }
    func getIntFromY()->Int{
        if let d = Int?(_Y){
            return d
        }
        return 0
        
    }
    
    func getIntToD()->Int{
        if let d = Int?(_D){
            return d
        }
        return 0
        
    }
    func getIntToM()->Int{
        if let d = Int(_M){
            return d
        }
        return 0
        
    }
    func getIntToY()->Int{
        if let d = Int?(_Y){
            return d
        }
        return 0
        
    }
    
    func getDateFormatAsString() -> String{
        return "\(_D)/\(_M)/\(_Y)"
    }
    
    
}

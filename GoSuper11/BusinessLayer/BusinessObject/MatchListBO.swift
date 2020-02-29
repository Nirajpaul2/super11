//
//  MatchListBO.swift
//  GoSuper11
//


import UIKit

class  MatchListAndDetailBO: NSObject {
    var arrMatchList = [MatchListBO]()
    var arrMatchDetaiB0 = [MatchDetailBO]()
}

class MatchListBO: NSObject {
    var strId : String?
    var date : String?
    var is_complete : String?
    var is_playerselectio : String?
    var manOfTheMatch : String?
    var matchid : String?
    var match_format : String?
    var score : String?
    var status : String?
    var taem1_id : String?
    var team2_id : String?
    var taem1_Name : String?
    var taem1_LogoImage : String?
    var taem1_sortName : String?
    var taem2_Name : String?
    var taem2_LogoImage : String?
    var taem2_sortName : String?
}

class MatchDetailBO: NSObject {
    var strId : String?
    var logoimage : String?
    var banner_image : String?
    var pagename : String?
    var button_name : String?
    var text : String?
    var iso_colourcode : String?
    var created_date : String?
    var updated_at : String?
    var colourcode : String?
}

class contestDetailBO: NSObject {
    var uniqueId : String?
    var match_id : String?
    var entry_fee : Float?
    var multiple_team : Int?
    var contest_size : Int?
    var join_user_limit : Int?
    var join_contest_count : Int?
    var total_team : Int?
    var total_join_contest : Int?
    var arrwinnerBreakups = [WinnerDetailBO]()
    
}
class WinnerDetailBO: NSObject {
    var winnerId : String?
    var contest_id : String?
    var first_rank : Int?
    var last_rank : Int?
    var price : Float?
    var order_id : String?
}

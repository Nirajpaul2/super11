//
//  PlayerDetailBO.swift
//  GoSuper11
//


import UIKit

class PlayerWithTeamDetailBO: NSObject {
    var matchdetailBo = MatchListBO()
    var arrPlayerList = [PlayerDetailBO]()
    var arrWKPlayer = [PlayerDetailBO]()
    var arrBATPlayer = [PlayerDetailBO]()
    var arrALPlayer = [PlayerDetailBO]()
    var arrBOWPlayers = [PlayerDetailBO]()
    var teamOneCount : Int = 0
    var teamTwoCount : Int = 0
    var totalLeftPoint : Float?
    var arrSelectedPlayerId = [String]()
}

class PlayerDetailBO: NSObject {
    
      var uniqueId : String?
      var player_id :  String?
      var match_id :  String?
      var name :  String?
      var team_id :  String?
      var player_details_flag : String?
      var credit_point : Float?
      var point :  Float?
      var run : Int?
      var ball_face : Int?
      var bt_strikerate :  Int?
      var wiket : Int?
      var maden_over : Int?
      var total_over : Int?
      var bowling_run : Int?
      var dotball : Int?
      var bowler_econ :  Float?
      var boller_4 : Int?
      var boller_6 : Int?
      var playerCatch : Int?
      var lbw : Int?
      var bowled : Int?
      var stumped : Int?
      var runout : Int?
      var in_match : Int?
    
       var playerType :  Int?
       var bowling_style :  String?
       var batting_style :  String?
       var dob :  String?
       var image_url :  String?
       var profile_details :  String?
       var country :  String?
       var full_name :  String?
       var playingRole :  String?
    
        var strTeamId : String?
        var strTeamName : String?
        var teamLogo : String?
        var strTeamShortname : String?
         var isPlayerSelected : Bool?
        var matchdetailBo = MatchListBO()
}

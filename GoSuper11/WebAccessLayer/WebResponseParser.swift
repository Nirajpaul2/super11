

import UIKit
import SwiftyJSON


struct StatusType {
    static let Success = "success"
    static let Error = "error"
}


class WebResponseParser: NSObject {
    
    func parseProfiledetailResponse(withResponse response:AnyObject) -> NSDictionary {
        let dictResponse = JSON(response)
        let result = dictResponse.dictionaryValue
        if result["success"]?.boolValue == true {
            let data = result["data"]?.dictionaryValue
            UserDefaults.standard.set(data!["userid"]?.stringValue, forKey: STRING_CONSTANT.KEY_USERID)
            UserDefaults.standard.set(true, forKey: STRING_CONSTANT.KEY_ALREADY_LOGIN)
            UserDefaults.standard.synchronize()
            return ["res":response, "stats":1]
        } else{
            return ["res":response, "stats":0]
        }
    }
    
    func parsePagedetailResponse(withResponse response:AnyObject) -> PageDetailBO {
        let dictResponse = JSON(response)
        let dictRespose = dictResponse["data"].dictionaryValue
        let pageDetailBo = PageDetailBO()
        pageDetailBo.pageId = dictRespose["id"]?.stringValue
        pageDetailBo.logoimage = dictRespose["logoimage"]?.stringValue
        pageDetailBo.banner_image = dictRespose["banner_image"]?.stringValue
        pageDetailBo.pagename = dictRespose["pagename"]?.stringValue
        pageDetailBo.button_name = dictRespose["button_name"]?.stringValue
        pageDetailBo.text = dictRespose["text"]?.stringValue
        pageDetailBo.created_date = dictRespose["created_date"]?.stringValue
        pageDetailBo.updated_at = dictRespose["updated_at"]?.stringValue
        pageDetailBo.colorCode =  dictRespose["iso_colourcode"]?.stringValue
        return pageDetailBo
     }
    
    func parseMatchListResponse(withResponse response:AnyObject) -> MatchListAndDetailBO {
        let dictResponse = JSON(response)
        let matchListAndDetailBo = MatchListAndDetailBO()
        let arrMatchListResponse = dictResponse["matchlist"].arrayValue
        let arrMatchDetailResponse = dictResponse["details"].arrayValue
        for i in 0..<arrMatchListResponse.count {
            let matchLisBo = MatchListBO()
            let dictResponse = arrMatchListResponse[i].dictionaryValue
            matchLisBo.strId = dictResponse["id"]?.stringValue
            matchLisBo.date = dictResponse["date"]?.stringValue
            matchLisBo.is_complete = dictResponse["is_complete"]?.stringValue
            matchLisBo.is_playerselectio = dictResponse["is_playerselectio"]?.stringValue
            matchLisBo.manOfTheMatch = dictResponse["man-of-the-match"]?.stringValue
            matchLisBo.matchid = dictResponse["matchid"]?.stringValue
            matchLisBo.match_format = dictResponse["match_format"]?.stringValue
            matchLisBo.score = dictResponse["score"]?.stringValue
            matchLisBo.status = dictResponse["status"]?.stringValue
            matchLisBo.taem1_id = dictResponse["taem1_id"]?.stringValue
            matchLisBo.team2_id = dictResponse["team2_id"]?.stringValue
            
            var dictTeam1Details = dictResponse["teamlist1"]?.dictionaryValue
            matchLisBo.taem1_Name = dictTeam1Details!["Name"]?.stringValue
            matchLisBo.taem1_LogoImage = dictTeam1Details!["logo_image"]?.stringValue
            matchLisBo.taem1_sortName = dictTeam1Details!["shortname"]?.stringValue
            
            var dictTeam2Details = dictResponse["teamlist2"]?.dictionaryValue
            matchLisBo.taem2_Name = dictTeam2Details!["Name"]?.stringValue
            matchLisBo.taem2_LogoImage = dictTeam2Details!["logo_image"]?.stringValue
            matchLisBo.taem2_sortName = dictTeam2Details!["shortname"]?.stringValue
            matchListAndDetailBo.arrMatchList.append(matchLisBo)
        }
        for j in 0..<arrMatchDetailResponse.count {
            let dictRespose = arrMatchDetailResponse[j].dictionaryValue
            let matchDetailBo = MatchDetailBO()
            matchDetailBo.strId = dictRespose["id"]?.stringValue
            matchDetailBo.logoimage = dictRespose["logoimage"]?.stringValue
            matchDetailBo.banner_image = dictRespose["banner_image"]?.stringValue
            matchDetailBo.pagename = dictRespose["pagename"]?.stringValue
            matchDetailBo.button_name = dictRespose["button_name"]?.stringValue
            matchDetailBo.text = dictRespose["text"]?.stringValue
            matchDetailBo.created_date = dictRespose["created_date"]?.stringValue
            matchDetailBo.updated_at = dictRespose["updated_at"]?.stringValue
            matchDetailBo.iso_colourcode =  dictRespose["iso_colourcode"]?.stringValue
            matchListAndDetailBo.arrMatchDetaiB0.append(matchDetailBo)
        }
        return matchListAndDetailBo
    }
    
    func parseMyTeamListResponse(withResponse response:AnyObject) -> [MyTeamListBO] {
        let dictResponses = JSON(response)
        var arrTeamList = [MyTeamListBO]()
        let arrTeamListRes = dictResponses["team_list"].arrayValue
        for i in 0..<arrTeamListRes.count {
            let myteamListBo = MyTeamListBO()
            let dictResponse = arrTeamListRes[i].dictionaryValue
            myteamListBo.captain_name = dictResponse["captain_name"]?.stringValue
            myteamListBo.teamId = dictResponse["id"]?.stringValue
            myteamListBo.match_id = dictResponse["match_id"]?.stringValue
            myteamListBo.team_name = dictResponse["team_name"]?.stringValue
            myteamListBo.team_short_name = dictResponse["team_short_name"]?.stringValue
            myteamListBo.total_alrounder = dictResponse["total_alrounder"]?.stringValue
            myteamListBo.total_batting = dictResponse["total_batting"]?.stringValue
            myteamListBo.total_boweler = dictResponse["total_boweler"]?.stringValue
            myteamListBo.viccaptain_name = dictResponse["viccaptain_name"]?.stringValue
            myteamListBo.total_team_limit = dictResponses["total_team_limit"].stringValue
            arrTeamList.append(myteamListBo)
        }
        return arrTeamList
    }
    
    
    func parsePlayerListResponse(withResponse response:AnyObject) -> PlayerWithTeamDetailBO {
        let dictResponse = JSON(response)
        let playerDetailWithTeam = PlayerWithTeamDetailBO()
        let arrPlayerListResponse = dictResponse["playerdetails"].arrayValue
        let arrMatchDetailResponse = dictResponse["teamdetails"].dictionaryValue
        for i in 0..<arrPlayerListResponse.count {
            let playerDetailBo = PlayerDetailBO()
            let dictResponse = arrPlayerListResponse[i].dictionaryValue
            
            
            playerDetailBo.uniqueId  = dictResponse["id"]?.stringValue
            playerDetailBo.player_id = dictResponse["player_id"]?.stringValue
            playerDetailBo.match_id = dictResponse["match_id"]?.stringValue
            playerDetailBo.name = dictResponse["name"]?.stringValue
            playerDetailBo.team_id = dictResponse["team_id"]?.stringValue
            playerDetailBo.credit_point = dictResponse["credit_point"]?.floatValue
            playerDetailBo.point = dictResponse["point"]?.floatValue
            playerDetailBo.isPlayerSelected = false

            let player = dictResponse["player_details"]?.dictionaryValue
            playerDetailBo.image_url = player!["image_url"]?.stringValue
//            if i == 0 {
//                playerDetailBo.playerType = 2
//
//            } else {
                playerDetailBo.playerType = player!["type"]?.intValue

//            }
        
            let teamDetail = dictResponse["teamname"]?.dictionaryValue
            playerDetailBo.strTeamId = teamDetail!["id"]?.stringValue
            playerDetailBo.strTeamShortname  = teamDetail!["shortname"]?.stringValue
            playerDetailWithTeam.arrPlayerList.append(playerDetailBo)
            switch playerDetailBo.playerType {
            case 1:
                playerDetailWithTeam.arrBATPlayer.append(playerDetailBo)
            case 2:
                playerDetailWithTeam.arrWKPlayer.append(playerDetailBo)
            case 3:
                playerDetailWithTeam.arrALPlayer.append(playerDetailBo)
            case 4:
                playerDetailWithTeam.arrBOWPlayers.append(playerDetailBo)
            default:
                break
            }
        }
       
        playerDetailWithTeam.matchdetailBo.strId = arrMatchDetailResponse["id"]?.stringValue
        playerDetailWithTeam.matchdetailBo.date = arrMatchDetailResponse["date"]?.stringValue
        playerDetailWithTeam.matchdetailBo.matchid = arrMatchDetailResponse["matchid"]?.stringValue
        var dictTeam1Details = arrMatchDetailResponse["teamlist1"]?.dictionaryValue
        playerDetailWithTeam.matchdetailBo.taem1_Name = dictTeam1Details!["Name"]?.stringValue
        playerDetailWithTeam.matchdetailBo.taem1_sortName = dictTeam1Details!["shortname"]?.stringValue
        var dictTeam2Details = arrMatchDetailResponse["teamlist2"]?.dictionaryValue
        playerDetailWithTeam.matchdetailBo.taem2_Name = dictTeam2Details!["Name"]?.stringValue
        playerDetailWithTeam.matchdetailBo.taem2_sortName = dictTeam2Details!["shortname"]?.stringValue
        
        
        return playerDetailWithTeam
    }
   
    
    func parseContestListResponse(withResponse response:AnyObject) -> [contestDetailBO] {
        let dictResponse = JSON(response)
        var arrContestList = [contestDetailBO]()
        let arrContest = dictResponse["contestlist"].arrayValue
        for i in 0..<arrContest.count {
            let contestDetail = contestDetailBO()
            let dictRes = arrContest[i].dictionaryValue
            contestDetail.uniqueId = dictRes["id"]?.stringValue
            contestDetail.match_id = dictRes["match_id"]?.stringValue
            contestDetail.entry_fee  = dictRes["entry_fee"]?.floatValue
            contestDetail.multiple_team  = dictRes["multiple_team"]?.intValue
            contestDetail.contest_size  = dictRes["contest_size"]?.intValue
            contestDetail.join_user_limit  = dictRes["join_user_limit"]?.intValue
            contestDetail.join_contest_count  = dictRes["join_contest_count"]?.intValue
            contestDetail.total_team = dictResponse["total_team"].intValue
            contestDetail.total_join_contest = dictResponse["total_join_contest"].intValue

            if let arrWinner = dictRes["winner_breakups"]?.arrayValue{
                for j in 0..<arrWinner.count{
                    let winterBo = WinnerDetailBO()
                    let dictWinner = arrWinner[j].dictionaryValue
                    winterBo.winnerId = dictWinner["id"]?.stringValue
                    winterBo.contest_id = dictWinner["contest_id"]?.stringValue
                    winterBo.first_rank = dictWinner["first_rank"]?.intValue
                    winterBo.last_rank = dictWinner["last_rank"]?.intValue
                    winterBo.price = dictWinner["price"]?.floatValue
                    winterBo.order_id = dictWinner["order_id"]?.stringValue
                    contestDetail.arrwinnerBreakups.append(winterBo)
                }
            }
            arrContestList.append(contestDetail)
        }
        return arrContestList
    }
}



















import Foundation
import Alamofire
import SwiftyJSON

class APIManeger: NSObject {
    
    // MARK: - Singleton -
    class var sharedInstance:APIManeger {
        struct Static{
            static let _instance = APIManeger()
        }
        return Static._instance
    }
    // MARK: - Request methods -
    func serviceCallForGetdataInPost(withPath path:String, withData param:NSDictionary, withCompletionHandler completion:@escaping (AnyObject?) -> Void){
        if !NetworkReachabilityManager()!.isReachable {
            //AppConstant.sharedInstance.nointenetConnectionView()
        }
        var requestURL : String?
        requestURL = String(format: "%@%@", API_CONSTANT.kBaseURL , path)
        print("*****************************  URL: *********************************\(String(describing: requestURL))")
        Alamofire.request(requestURL!, method: .post, parameters: param as? Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseJson) in
            print("Response : \(responseJson)")
            
            if (responseJson.result.isSuccess){
                switch path {
                case API_PATH.kGetDetails:
                    let dictRes = WebResponseParser().parsePagedetailResponse(withResponse: (responseJson.result.value as AnyObject)) as PageDetailBO
                    if dictRes.pageId != nil && dictRes.pageId != "" {
                        completion(["res":dictRes, "stats":1] as AnyObject?)
                    } else {
                        completion(["res":dictRes, "stats":0] as AnyObject?)
                    }
                case API_PATH.kLogin:
                    let dictRes = WebResponseParser().parseProfiledetailResponse(withResponse: (responseJson.result.value as AnyObject)) as NSDictionary
                    completion(dictRes as AnyObject?)
                   
                 case API_PATH.kSignUp, API_PATH.kOtpValidtion, API_PATH.kForgotPassword, API_PATH.kSetNewPassword:
                    let dictRes = responseJson.result.value as! NSDictionary
                    if let code = dictRes["success"] as? Int{
                        if code == 1{
                            completion(["res":dictRes, "stats":1] as AnyObject?)
                        } else {
                            completion(["res":dictRes, "stats":0] as AnyObject?)
                        }
                    } else {
                        completion(["res":dictRes, "stats":0] as AnyObject?)
                    }
                case API_PATH.kGetTeamlist:
                    let arrTeamList = WebResponseParser().parseMyTeamListResponse(withResponse: (responseJson.result.value as AnyObject)) as [MyTeamListBO]
                    if arrTeamList.count != 0{
                        completion(["res":arrTeamList, "stats":1] as AnyObject?)
                    } else {
                        completion(["res":arrTeamList, "stats":0] as AnyObject?)
                    }
                case API_PATH.kSaveTeam:
                    let dictRes = responseJson.result.value as! NSDictionary
                    completion(["res":dictRes, "stats":1] as AnyObject?)
                    
                case API_PATH.kGetMatchDetails:
                    let dictRes = WebResponseParser().parseMatchListResponse(withResponse: (responseJson.result.value as AnyObject)) as MatchListAndDetailBO
                    if dictRes.arrMatchList.count > 1 || dictRes.arrMatchDetaiB0.count > 1{
                        completion(["res":dictRes, "stats":1] as AnyObject?)
                    } else {
                        completion(["res":dictRes, "stats":0] as AnyObject?)
                    }
                case API_PATH.kGetPlayerDeails:
                    let dictRes = WebResponseParser().parsePlayerListResponse(withResponse:  (responseJson.result.value as AnyObject)) as PlayerWithTeamDetailBO
                    if dictRes.arrPlayerList.count  != 0 {
                        completion(["res":dictRes, "stats":1] as AnyObject?)
                    } else {
                        completion(["res":dictRes, "stats":0] as AnyObject?)
                    }
                case API_PATH.kGetContestList:
                    let arrList = WebResponseParser().parseContestListResponse(withResponse:  (responseJson.result.value as AnyObject)) as [contestDetailBO]
                    if arrList.count  != 0 {
                        completion(["res":arrList, "stats":1] as AnyObject?)
                    } else {
                        completion(["res":responseJson.result.value as! NSDictionary, "stats":0] as AnyObject?)
                    }
                default:
                    break
                }
                
            } else {
                let res : NSDictionary = ["msg":"Network Error"]
                completion(["res":res, "stats":0] as AnyObject?)
            }
        }
    }
  
}





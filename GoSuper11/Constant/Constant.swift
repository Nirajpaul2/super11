
import Foundation
import UIKit



struct API_CONSTANT {
        
    //Current server link
    static let kDevURL      = "http://api.gosuper11.com/api/"

    static let kBaseURL     = kDevURL
}

struct GLOBAL_CONSTANT {
    static let SCREEN_SIZE : CGSize = UIScreen.main.bounds.size
    //FONTS
//    static func FONT_LIGHT(size: CGFloat) -> UIFont {
//        return UIFont(name: "", size: size)!
//    }

    static func FONT_REGULAR(size: CGFloat) -> UIFont {
        return UIFont(name: "SEGOEUI.ttf", size: size)!
    }

    static func FONT_SEMIBOLD(size: CGFloat) -> UIFont {
        return UIFont(name: "seguisb.ttf", size: size)!
    }

    static func FONT_BOLD(size: CGFloat) -> UIFont {
        return UIFont(name: "seguibl.ttf", size: size)!
    }

    static func FONT_EXTRABOLD(size: CGFloat) -> UIFont {
        return UIFont(name: "seguibl.ttf", size: size)!
    }
    static func FONT_ITALIC(size: CGFloat) -> UIFont {
        return UIFont(name: "Segoe_UI_Italic.ttf", size: size)!
    }
}


struct APP_DELEGATE {
    static let appDelegate = UIApplication.shared.delegate! as! AppDelegate
}

struct INITIATE {
    static func INITIATE_STORY_BOARD(identifier: String) -> Any {
      //  if UIDevice.current.userInterfaceIdiom == .phone{
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
//        } else {
//            return UIStoryboard(name: "TabStoryboard", bundle: nil).instantiateViewController(withIdentifier: identifier)
//        }
        
    }
}

struct COLOR {
    
    static let COLOR_THEME_BLUE : UIColor = UIColor(red: 6/255, green: 182/255, blue: 226/255, alpha: 1)
    static let COLOR_BUTTON_GREEN : UIColor = UIColor(red: 34/255.0, green: 121/255.0, blue: 0/255.0, alpha: 1)
    static let COLOR_VIEW_BACKGROUND : UIColor = UIColor(red: 139/255.0, green: 195/255.0, blue: 74/255.0, alpha: 1)
    static let COLOR_NAVIGATIONBAR : UIColor = UIColor(red: 11/255, green: 0/255, blue: 91/255, alpha: 1)
    static let APP_BACKGROUNG_GRAY : UIColor = UIColor(red: 242/255, green: 243/255, blue: 247/255, alpha: 1)
    static let COLOR_BUTTON_LIGHTGRAY : UIColor = UIColor(red: 221/255.0, green: 221/255.0, blue: 221/255.0, alpha: 1)
    static let COLOR_TABLEVIEW_BACKGROUND : UIColor = UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
    static let COLOR_LIGHT_TEXT : UIColor = AppConstant.sharedInstance.UIColorFromHex(0x7CEAFD, alpha: 1)
}

struct NOTIFICATION_TYPE {
    static let error    = "ERROR"
    static let success  = "SUCCESS"
    static let warning  = "WARNING"
    static let none     = "NONE"
}

struct STRING_CONSTANT {
    static let DEVICE_TYPE : String             = "ios"
    static let DEVICE_ID   : String             = UIDevice.current.identifierForVendor!.uuidString
    
    //Userdefaults key
    static let KEY_ALREADY_LOGIN                = "isAlreadyLoggedIn"
    static let KEY_AUTH_TOKEN                   = "AuthToken"
    static let KEY_USERID                       = "UserId"
    static let KEY_USER_NAME                    = "UserName"
    static let KEY_FIRST_NAME                   = "FirstName"
    static let KEY_LAST_NAME                    = "LastName"
    static let KEY_EMAIL                        = "Email"
    static let KEY_COUNTRY_CODE                 = "countryCode"
    static let KEY_MOBILE_NUMBER                = "MobileNumber"
    static let KEY_PROFILE_IMAGE                = "profileImage"
    
    //Messages
    static let WRONG_MSG                        = "Some thing went wrong. Try again."
    static let WAIT                             = "Please wait."
}

struct ERROR{
    static let type     = "error_ident"
    static let message  = "message"
}

struct API_PATH {
    static let kGetDetails           = "getdetails"
    static let kLogin                   = "checklogin"
    static let kSignUp                = "savesignup"
    static let kOtpValidtion        = "verifyphonenumber"
    static let kResendOTP        =  "resendotp"
    static let kForgotPassword = "forgotpassword"
    static let kSetNewPassword = "setpassword"
    static let kGetMatchDetails  = "getmatchdetails"
    static let kGetPlayerDeails  =  "getplayerdetails"
    static let kGetContestList   = "getcontestlist"
    static let kSaveTeam           = "saveuserteam"
    static let kGetTeamlist           = "getteamlist"
}




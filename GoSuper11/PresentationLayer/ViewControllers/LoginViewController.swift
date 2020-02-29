//
//  LoginViewController.swift
//  GoSuper11
//

import UIKit
import  SkyFloatingLabelTextField
import FBSDKCoreKit
import  FBSDKLoginKit
import AlamofireImage


class LoginViewController: UIViewController , UITextFieldDelegate{

    //MARK: - IBOutlets and Variables -
    @IBOutlet weak var logInContaintView: UIView!
    @IBOutlet weak var logInScrollView: UIScrollView!
    @IBOutlet weak var btnLoginWithGoogle: UIButton!
    @IBOutlet weak var btnLoginWithFacebook: UIButton!
    @IBOutlet weak var btnForGotPassord: UIButton!
    @IBOutlet weak var btnLoginUser: UIButton!
    @IBOutlet weak var txtFldLoginPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFldLoginMobileNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnSignUpNewUser: UIButton!
    @IBOutlet weak var txtFldSignUpPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFldSignUpMobileNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var txtfldEmailId: SkyFloatingLabelTextField!
    @IBOutlet weak var txtfldInviteCode: SkyFloatingLabelTextField!
    @IBOutlet weak var SignUpView: UIView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var imgViewLogo: UIImageView!
    let downloader                          = ImageDownloader()
    var pageDetailBo = PageDetailBO()
    var isFromLogin : Bool?
    var forgotPasswordView  :  PopUpWithTextFiled!
    var btnBG : UIButton?
    
    //MARK: - ViewLifw cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBG = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        btnBG?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        btnBG?.isHidden = true
        btnBG?.addTarget(self, action: #selector(btnBGClicked(sender:)), for: .touchUpInside)
        self.view.addSubview(btnBG!)
        designAfterStoryBoard()
        designPopUpForForgotPassword()
        self.serviceCallForGetPageDetails()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //MARK: - Design after story board -
    func designAfterStoryBoard(){
        btnLoginUser.layer.borderColor = UIColor.white.cgColor
        btnLoginUser.layer.borderWidth = 2.0
        btnLoginUser.layer.cornerRadius = 6.0
        btnLoginUser.clipsToBounds = true
        btnSignUpNewUser.layer.cornerRadius = 6.0
        btnSignUpNewUser.clipsToBounds = true
        btnSignUpNewUser.layer.borderColor = UIColor.white.cgColor
        btnSignUpNewUser.layer.borderWidth = 2.0
         btnFacebook.addShadow(cornerRadius: 6, opacity: 1, radius: 5, offset: (x: 0, y: 0), color: .lightGray)
         btnGoogle.addShadow(cornerRadius: 6, opacity: 1, radius: 5, offset: (x: 0, y: 0), color: .lightGray)
        btnLoginWithGoogle.addShadow(cornerRadius: 6, opacity: 1, radius: 5, offset: (x: 0, y: 0), color: .lightGray)
        btnLoginWithFacebook.addShadow(cornerRadius: 6, opacity: 1, radius: 5, offset: (x: 0, y: 0), color: .lightGray)
        designCustomTextField(withSelectedTextField: self.txtFldSignUpMobileNumber)
        designCustomTextField(withSelectedTextField: self.txtFldLoginMobileNumber)
        designCustomTextField(withSelectedTextField: self.txtFldLoginPassword)
        designCustomTextField(withSelectedTextField: self.txtFldSignUpPassword)
        designCustomTextField(withSelectedTextField: self.txtfldEmailId)
        designCustomTextField(withSelectedTextField: self.txtfldInviteCode)
        if isFromLogin! {
            setUpNavigationTitle(title: "Log In")
            self.loginView.isHidden = false
            self.SignUpView.isHidden = true
            self.btnLogin.setTitleColor(UIColor.white, for: .normal)
            self.btnSignUp.setTitleColor(COLOR.COLOR_LIGHT_TEXT, for: .normal)
        } else {
            setUpNavigationTitle(title: "Sign Up")
            self.loginView.isHidden = true
            self.SignUpView.isHidden = false
            self.btnLogin.setTitleColor(COLOR.COLOR_LIGHT_TEXT, for: .normal)
            self.btnSignUp.setTitleColor(UIColor.white, for: .normal)
        }
        
        self.txtFldLoginPassword.rightViewMode = .always
        let btnEye = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        btnEye.setImage( #imageLiteral(resourceName: "openEye").imageWithColor(color: UIColor.white), for: .normal)
        btnEye.setImage( #imageLiteral(resourceName: "closeEye").imageWithColor(color: UIColor.white), for: .selected)
        self.txtFldLoginPassword.rightView = btnEye
        btnEye.addTarget(self, action: #selector(btnbtnPasswordshowHideClicked(sender:)), for: .touchUpInside)
        
        self.txtFldSignUpPassword.rightViewMode = .always
        let btnEyeSignUp = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        btnEyeSignUp.setImage( #imageLiteral(resourceName: "openEye").imageWithColor(color: UIColor.white), for: .normal)
        btnEyeSignUp.setImage( #imageLiteral(resourceName: "closeEye").imageWithColor(color: UIColor.white), for: .selected)
        self.txtFldSignUpPassword.rightView = btnEyeSignUp
        btnEyeSignUp.addTarget(self, action: #selector(btnbtnSignUpPasswordshowHideClicked(sender:)), for: .touchUpInside)
        
    }
    func designPopUpForForgotPassword(){
        forgotPasswordView = PopUpWithTextFiled.instanceFromNib() as! PopUpWithTextFiled
        forgotPasswordView.isHidden = true
        forgotPasswordView.txtFldEnterValue.delegate = self
        forgotPasswordView.txtFldEnterValue.placeholder = "Enter phone number"
        forgotPasswordView.txtFldEnterValue.title = "Phone Number"
        self.forgotPasswordView.btnSubmit.tag = 100
        forgotPasswordView.btnSubmit.addTarget(self, action: #selector(btnForgotPasswordSubitClicked(sender:)), for: .touchUpInside)
        forgotPasswordView.addShadow(cornerRadius: 6, opacity: 1, radius: 5, offset: (x: 0, y: 0), color: .lightGray)
        forgotPasswordView.frame = CGRect(x: 30, y: self.view.frame.size.height, width: self.view.frame.size.width - 60, height: 0)
        self.view.addSubview(forgotPasswordView)
    }
    
    func setUpNavigationTitle(title : String){
        navigationItem.leftBarButtonItems = nil
        var leftAddBarButtonItemBack = UIBarButtonItem()
        leftAddBarButtonItemBack = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.btnBackClicked(sender:)))
        let titel = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.plain, target: self, action: nil)
        navigationItem.leftBarButtonItems = [leftAddBarButtonItemBack, titel]
    }
    func SetUpImage(){
        let urlImageLogo = URL(string: pageDetailBo.logoimage!)
        let urlRequestLogo = URLRequest(url: urlImageLogo!)
        self.downloader.download(urlRequestLogo) { response in
            if let image = response.result.value {
                self.imgViewLogo.image = image
                self.imgViewLogo.clipsToBounds = true
                self.forgotPasswordView.imgViewLogo.image = image
            } else {
                // imgView.contentMode = .scaleAspectFill
             //   let colorCode = UInt32("0x" + self.pageDetailBo.colorCode!)
               // self.logInScrollView.backgroundColor =  AppConstant.sharedInstance.UIColorFromHex(colorCode!, alpha: 1)
            }
        }
    }
    
    func designCustomTextField(withSelectedTextField txtfld:SkyFloatingLabelTextField){
        txtfld.errorColor = UIColor.red
        txtfld.tintColor = UIColor.white
        txtfld.lineColor = UIColor.white
        txtfld.selectedLineColor = UIColor.white
        txtfld.lineHeight = 1.0
        txtfld.textColor = UIColor.white
        txtfld.selectedTitleColor = UIColor.white
        txtfld.titleColor = UIColor.white
        txtfld.placeholderColor = UIColor.white
        switch txtfld {
        case self.txtFldLoginMobileNumber , self.txtFldSignUpMobileNumber:
            txtfld.title = "Enter Mobile No"
            txtfld.selectedTitle = "Enter Mobile No"
            txtfld.placeholder = "Enter Mobile No"
        case self.txtFldLoginPassword , self.txtFldSignUpPassword:
            txtfld.title = "Enter Password"
            txtfld.selectedTitle = "Enter Password"
            txtfld.placeholder = "Enter Password"
        case self.txtfldEmailId :
            txtfld.title = "Enter Email id"
            txtfld.selectedTitle = "Enter Email id"
            txtfld.placeholder = "Enter Email id"
        case self.txtfldInviteCode :
            txtfld.title = "Enter Invite Code"
            txtfld.selectedTitle = "Enter Invite Code"
            txtfld.placeholder = "Enter Invite Code"
        default:
            break
        }
    }
    
    func displayAlertForEnterOTP(){
            let alertController = UIAlertController(title: "OTP", message: "Please send the otp which is send to your phone number.", preferredStyle: .alert)
            
            let applyAction = UIAlertAction(title: "APPLY", style: .default) { (_) in
                
                if let field = alertController.textFields![0] as? UITextField {
                    // store your data
                    
                    print(field.text!)
                    self.serviceCallForOTPValidation(withOtp: field.text!, isFromSignUp: true)
                } else {
                    // user did not fill field
                }
            }
            applyAction.isEnabled = false
            let cancelAction = UIAlertAction(title: "Resend", style: .destructive) { (_) in
                self.serviceCallForResendOTP()
            }
            
            alertController.addTextField { (textField) in
                textField.placeholder = "Enter OTP"
                NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                    applyAction.isEnabled = textField.text!.count > 0
                }
            }
            alertController.addAction(cancelAction)
            alertController.addAction(applyAction)
            
            self.present(alertController, animated: true, completion: nil)
            alertController.view.tintColor = COLOR.COLOR_BUTTON_GREEN
            

    }
    
    //MARK: - Button Action -
    @objc func btnBGClicked(sender : UIButton){
        sender.isHidden = true
        self.viewHideInAnimation(withViewFrameYPosition: self.view.frame.size.height, withSelectedView: self.forgotPasswordView, withEstimatedHeight: 0)
    }
    @objc func btnBackClicked(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnLogInTopClicked(_ sender: Any) {
        setUpNavigationTitle(title: "Log In")
        self.loginView.isHidden = false
        self.SignUpView.isHidden = true
        self.btnLogin.setTitleColor(UIColor.white, for: .normal)
        self.btnSignUp.setTitleColor(COLOR.COLOR_LIGHT_TEXT, for: .normal)
    }
    
    @IBAction func btnSignUpTopClicked(_ sender: Any) {
        setUpNavigationTitle(title: "Sign Up")
        self.loginView.isHidden = true
        self.SignUpView.isHidden = false
        self.btnLogin.setTitleColor(COLOR.COLOR_LIGHT_TEXT, for: .normal)
        self.btnSignUp.setTitleColor(UIColor.white, for: .normal)
    }
    
    //Signup Action
    @IBAction func btnSignUpUserClicked(_ sender: Any) {
        if isValidSignUpDetail(){
            self.serviceCallForSignUp()
        }
    }
    
    @IBAction func btnSignUpWithFacebookClicked(_ sender: Any) {
        
    }
    
    @IBAction func btnSignUpWithGoogleCliked(_ sender: Any) {
    }
    
    //Login Action
    @IBAction func btnLoginWithFacebookClicked(_ sender: Any) {
        faceBookLoginAndSignUP()
    }
    
    @IBAction func btnLogInWithGoogleClicked(_ sender: Any) {
    }
    
    @IBAction func btnForgotPasswordClicked(_ sender: Any) {
        self.forgotPasswordView.isHidden = false
        self.viewShowInAnimation(withViewFrameYPosition: self.view.frame.size.height / 2 - 150, withSelectedView: self.forgotPasswordView, withEstimatedHeight: 250)
    }
    
    @IBAction func btnLogInUserClicked(_ sender: Any) {
        if isValidLoginDetail() {
            serviceCallForLogin()
        }
    }
    
    func faceBookLoginAndSignUP(){
        let fbloginManger: FBSDKLoginManager = FBSDKLoginManager()
        fbloginManger.logIn(withReadPermissions: ["email"], from:self) {(result, error) -> Void in
            if(error == nil){
                let fbLoginResult: FBSDKLoginManagerLoginResult  = result!
                
                if( result?.isCancelled)!{
                    return }
                
                if(fbLoginResult .grantedPermissions.contains("email")){
                    self.getFbId()
                }
            }  }

       
    }
    func getFbId(){
        let accessToken = FBSDKAccessToken.current()
        //  let r = FBSDKGraphRequest(graphPath: "me", parameters:  ["fields":"email,name"], httpMethod: "GET")
        let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, name, first_name, last_name, email, picture.type(large)"], tokenString: accessToken?.tokenString, version: nil, httpMethod: "GET")
        req?.start(completionHandler: { (connection, result, error) in
            if(error == nil)
            {
                print("result \(result ?? "")")
                guard let Info = result as? [String: Any] else { return }
                
                if let imageURL = ((Info["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                    //Download image from imageURL
                    print(imageURL)
                }
            }
            else
            {
                print("error \(error ?? "" as! Error)")
            }
        })
    }
    
    @objc func btnbtnPasswordshowHideClicked(sender:UIButton){
        sender.isSelected = !sender.isSelected
        self.txtFldLoginPassword.isSecureTextEntry = !self.txtFldLoginPassword.isSecureTextEntry
    }
    @objc func btnbtnSignUpPasswordshowHideClicked(sender:UIButton){
        sender.isSelected = !sender.isSelected
        self.txtFldSignUpPassword.isSecureTextEntry = !self.txtFldSignUpPassword.isSecureTextEntry
    }
    
    @objc func btnForgotPasswordSubitClicked(sender: UIButton){
        if (forgotPasswordView.txtFldEnterValue.text?.count)! > 0{
            switch sender.tag {
            case 100:
                self.serviceCallForForgotPassword()
            case 101:
                self.serviceCallForOTPValidation(withOtp: self.forgotPasswordView.txtFldEnterValue.text!, isFromSignUp: false)
            case 102:
                self.serviceCallForSetNewPassword()
            default:
                break
            }
        } else {
            sender.shake()
        }
    }
    
    //MARK: - Validtion part -
    func isValidLoginDetail() -> Bool {
        
        let strUserName = self.txtFldLoginMobileNumber.text
        let strPassword = self.txtFldLoginPassword.text
        
        if (((strUserName?.count) != 0) && ((strPassword?.count) != 0)) {
            let whitespace = NSCharacterSet.whitespaces
            let range = strUserName?.rangeOfCharacter(from: whitespace)
            // range will be nil if no whitespace is found
            if range != nil {
                // whitespace found
                self.txtFldLoginMobileNumber.errorMessage = "Phone Number does not content white space"
               // APP_DELEGATE.appDelegate.showErrorTab(withMessage: "Phone Number does not content white space", andType: NOTIFICATION_TYPE.error)
                return false
            }
            else if ((strPassword?.count)! < 5) {
                // Password must be 8 chars
                self.txtFldLoginPassword.errorMessage = "Passwood not less than 5 charecter"
                //APP_DELEGATE.appDelegate.showErrorTab(withMessage: "Passwood not less than 5 charecter", andType: NOTIFICATION_TYPE.error)
                //self.txtFldPassord.errorMessage = "Passwood not less than 5 charecter"
                return false
            }
            else {
                return true
            }
        }
        else{
            if ((strUserName?.count) == 0) {
                self.txtFldLoginMobileNumber.errorMessage = "Mobile number can't be blank."

              //  APP_DELEGATE.appDelegate.showErrorTab(withMessage: "Mobile number can't be blank.", andType: NOTIFICATION_TYPE.error)
                //self.txtFldEmai.errorMessage = "Email id can't be empty"
            }
            else {
                self.txtFldLoginPassword.errorMessage = "Password can't be blank."

                //APP_DELEGATE.appDelegate.showErrorTab(withMessage: "Password can't be blank.", andType: NOTIFICATION_TYPE.error)
                //self.txtFldPassord.errorMessage = "Password can't be empty"
            }
            
            return false
        }
    }
    
    func isValidSignUpDetail() -> Bool {
        let strEmail = self.txtfldEmailId.text
        let strMobileNumber = self.txtFldSignUpMobileNumber.text
        let strPassword = self.txtFldSignUpPassword.text
        
        if (((strMobileNumber?.count) != 0) && ((strPassword?.count) != 0) && ((strEmail?.count) != 0)) {
            let whitespace = NSCharacterSet.whitespaces
            let range = strMobileNumber?.rangeOfCharacter(from: whitespace)
            // range will be nil if no whitespace is found
            if !AppConstant.sharedInstance.isValidEmail(testStr: strEmail!){
                self.txtfldEmailId.errorMessage = "Please enter valid email."
                return false
            }
            else if range != nil {
                // whitespace found
                self.txtFldSignUpMobileNumber.errorMessage = "Phone Number does not content white space"
                // APP_DELEGATE.appDelegate.showErrorTab(withMessage: "Phone Number does not content white space", andType: NOTIFICATION_TYPE.error)
                return false
            }
            
            else if ((strPassword?.count)! < 5) {
                // Password must be 8 chars
                self.txtFldSignUpPassword.errorMessage = "Passwood not less than 5 charecter"
                //APP_DELEGATE.appDelegate.showErrorTab(withMessage: "Passwood not less than 5 charecter", andType: NOTIFICATION_TYPE.error)
                //self.txtFldPassord.errorMessage = "Passwood not less than 5 charecter"
                return false
            }
            else {
                return true
            }
        }
        else{
            if strEmail?.count == 0 {
                self.txtfldEmailId.errorMessage = "Emailid can't be blank."
            }
            else if ((strMobileNumber?.count) == 0) {
                self.txtFldSignUpMobileNumber.errorMessage = "Mobile number can't be blank."
                
                //  APP_DELEGATE.appDelegate.showErrorTab(withMessage: "Mobile number can't be blank.", andType: NOTIFICATION_TYPE.error)
                //self.txtFldEmai.errorMessage = "Email id can't be empty"
            }
            
            else {
                self.txtFldSignUpPassword.errorMessage = "Password can't be blank."
                
                //APP_DELEGATE.appDelegate.showErrorTab(withMessage: "Password can't be blank.", andType: NOTIFICATION_TYPE.error)
                //self.txtFldPassord.errorMessage = "Password can't be empty"
            }
            
            return false
        }
    }
    
    //MARK: - Servicecall Method -
    func serviceCallForGetPageDetails(){
        AppConstant.sharedInstance.showActivityIndicatory(withTitle: "Loader...", andUserInteraction: false)
        let param = ["pagename":"slash_page"] as [String : Any]
        
        APIManeger.sharedInstance.serviceCallForGetdataInPost(withPath: API_PATH.kGetDetails, withData: param as NSDictionary, withCompletionHandler: { (withCompletionHandler:AnyObject?) in
            print("result : \(String(describing: withCompletionHandler))");
            AppConstant.sharedInstance.removeActivityIndicatory()
            let dictResponse = withCompletionHandler as! Dictionary<String, Any>
            let isSuccess : Int = dictResponse["stats"] as! Int
            
            if isSuccess == 1{
                print("Success")
                self.pageDetailBo = dictResponse["res"] as! PageDetailBO
                self.SetUpImage()
            } else {
                print("Error")
                APP_DELEGATE.appDelegate.showErrorTab(withMessage: STRING_CONSTANT.WRONG_MSG, andType: NOTIFICATION_TYPE.error)
            }
        })
    }
    func serviceCallForLogin(){
        AppConstant.sharedInstance.showActivityIndicatory(withTitle: "Loader...", andUserInteraction: false)
        
        let param = ["password" : self.txtFldLoginPassword.text!, "type" : "phone" , "phonenumber" : self.txtFldLoginMobileNumber.text!] as [String : Any]
        
        APIManeger.sharedInstance.serviceCallForGetdataInPost(withPath: API_PATH.kLogin, withData: param as NSDictionary, withCompletionHandler: { (withCompletionHandler:AnyObject?) in
            print("result : \(String(describing: withCompletionHandler))");
            AppConstant.sharedInstance.removeActivityIndicatory()
            let dictResponse = withCompletionHandler as! Dictionary<String, Any>
            let isSuccess : Int = dictResponse["stats"] as! Int
            
            if isSuccess == 1{
                print("Success")
                let matchVC = INITIATE.INITIATE_STORY_BOARD(identifier: "CricketMatchStatusViewController") as! CricketMatchStatusViewController
                self.navigationController?.pushViewController(matchVC, animated: true)
            } else {
                print("Error")
                let result = dictResponse["res"] as! NSDictionary
                APP_DELEGATE.appDelegate.showErrorTab(withMessage: result["msg"] as! String, andType: NOTIFICATION_TYPE.error)
            }
        })
    }
    
    func serviceCallForSignUp(){
        AppConstant.sharedInstance.showActivityIndicatory(withTitle: "Loader...", andUserInteraction: false)
        let  param =  ["referrelcode":self.txtfldInviteCode.text ?? "","email" : self.txtfldEmailId.text ?? "", "phonenumber" : self.txtFldSignUpMobileNumber.text ?? "", "password":self.txtFldLoginPassword.text ?? "", "deviceid" : STRING_CONSTANT.DEVICE_ID , "name" : "", "signby" : "default" ] as [String : Any]
        
        APIManeger.sharedInstance.serviceCallForGetdataInPost(withPath: API_PATH.kSignUp, withData: param as NSDictionary, withCompletionHandler: { (withCompletionHandler:AnyObject?) in
            print("result : \(String(describing: withCompletionHandler))");
            AppConstant.sharedInstance.removeActivityIndicatory()
            let dictResponse = withCompletionHandler as! Dictionary<String, Any>
            let isSuccess : Int = dictResponse["stats"] as! Int
            
            if isSuccess == 1{
                print("Success")
                let result = dictResponse["res"] as! NSDictionary
                let userId = result["data"] as! NSDictionary
                UserDefaults.standard.set(userId["userid"], forKey: STRING_CONSTANT.KEY_USERID)
                self.displayAlertForEnterOTP()
            } else {
                print("Error")
                 let result = dictResponse["res"] as! NSDictionary
                APP_DELEGATE.appDelegate.showErrorTab(withMessage: result["msg"] as! String, andType: NOTIFICATION_TYPE.error)
            }
        })
    }
    
    
    func serviceCallForOTPValidation(withOtp otp:String , isFromSignUp :Bool){
        AppConstant.sharedInstance.showActivityIndicatory(withTitle: "Loader...", andUserInteraction: false)
        let param = ["otp" : otp,"userid" : UserDefaults.standard.value(forKey: STRING_CONSTANT.KEY_USERID) ?? ""] as [String : Any]
        
        APIManeger.sharedInstance.serviceCallForGetdataInPost(withPath: API_PATH.kOtpValidtion, withData: param as NSDictionary, withCompletionHandler: { (withCompletionHandler:AnyObject?) in
            print("result : \(String(describing: withCompletionHandler))");
            AppConstant.sharedInstance.removeActivityIndicatory()
            let dictResponse = withCompletionHandler as! Dictionary<String, Any>
            let isSuccess : Int = dictResponse["stats"] as! Int
            
            if isSuccess == 1{
                print("Success")
                if isFromSignUp {
                    UserDefaults.standard.set(true, forKey: STRING_CONSTANT.KEY_ALREADY_LOGIN)
                    let matchVC = INITIATE.INITIATE_STORY_BOARD(identifier: "CricketMatchStatusViewController") as! CricketMatchStatusViewController
                    self.navigationController?.pushViewController(matchVC, animated: true)
                } else{
                    self.forgotPasswordView.txtFldEnterValue.placeholder = "Enter New password"
                    self.forgotPasswordView.txtFldEnterValue.title = "Enter New password"
                    self.forgotPasswordView.txtFldEnterValue.text = ""
                    self.forgotPasswordView.btnSubmit.tag = 102
                    self.forgotPasswordView.btnSubmit.setTitle("DONE", for: .normal)
                }
               
            } else {
                print("Error")
                self.displayAlertForEnterOTP()
                APP_DELEGATE.appDelegate.showErrorTab(withMessage: STRING_CONSTANT.WRONG_MSG, andType: NOTIFICATION_TYPE.error)
            }
        })
    }
    
    func serviceCallForResendOTP(){
        AppConstant.sharedInstance.showActivityIndicatory(withTitle: "Loader...", andUserInteraction: false)
        let param = ["useid" : UserDefaults.standard.value(forKey: STRING_CONSTANT.KEY_USERID) ?? ""] as [String : Any]
        
        APIManeger.sharedInstance.serviceCallForGetdataInPost(withPath: API_PATH.kResendOTP, withData: param as NSDictionary, withCompletionHandler: { (withCompletionHandler:AnyObject?) in
            print("result : \(String(describing: withCompletionHandler))");
            AppConstant.sharedInstance.removeActivityIndicatory()
            let dictResponse = withCompletionHandler as! Dictionary<String, Any>
            let isSuccess : Int = dictResponse["stats"] as! Int
            
            if isSuccess == 1{
                print("Success")
               
            } else {
                print("Error")
                APP_DELEGATE.appDelegate.showErrorTab(withMessage: STRING_CONSTANT.WRONG_MSG, andType: NOTIFICATION_TYPE.error)
            }
        })
    }
    
    func serviceCallForForgotPassword(){
        AppConstant.sharedInstance.showActivityIndicatory(withTitle: "Loader...", andUserInteraction: false)
        let param = ["phonenumber" : self.forgotPasswordView.txtFldEnterValue.text ?? ""] as [String : Any]
        
        APIManeger.sharedInstance.serviceCallForGetdataInPost(withPath: API_PATH.kForgotPassword, withData: param as NSDictionary, withCompletionHandler: { (withCompletionHandler:AnyObject?) in
            print("result : \(String(describing: withCompletionHandler))");
            AppConstant.sharedInstance.removeActivityIndicatory()
            let dictResponse = withCompletionHandler as! Dictionary<String, Any>
            let isSuccess : Int = dictResponse["stats"] as! Int
            
            if isSuccess == 1{
                print("Success")
                self.forgotPasswordView.txtFldEnterValue.placeholder = "Please Enter OTP"
                self.forgotPasswordView.txtFldEnterValue.title = "Enter OTP"
                self.forgotPasswordView.txtFldEnterValue.text = ""
                self.forgotPasswordView.btnSubmit.tag = 101
                self.forgotPasswordView.btnSubmit.setTitle("VERIFY", for: .normal)

            } else {
                print("Error")
                let response = dictResponse["res"] as! NSDictionary
                APP_DELEGATE.appDelegate.showErrorTab(withMessage: response["msg"] as! String, andType: NOTIFICATION_TYPE.error)
            }
        })
    }
    
    func serviceCallForSetNewPassword(){
        AppConstant.sharedInstance.showActivityIndicatory(withTitle: "Loader...", andUserInteraction: false)
        let param = ["password" : self.forgotPasswordView.txtFldEnterValue.text ?? "", "userid" : UserDefaults.standard.value(forKey: STRING_CONSTANT.KEY_USERID)!] as [String : Any]
        
        APIManeger.sharedInstance.serviceCallForGetdataInPost(withPath: API_PATH.kSetNewPassword, withData: param as NSDictionary, withCompletionHandler: { (withCompletionHandler:AnyObject?) in
            print("result : \(String(describing: withCompletionHandler))");
            AppConstant.sharedInstance.removeActivityIndicatory()
            let dictResponse = withCompletionHandler as! Dictionary<String, Any>
            let isSuccess : Int = dictResponse["stats"] as! Int
            
            if isSuccess == 1{
                print("Success")
                 let response = dictResponse["res"] as! NSDictionary
                 APP_DELEGATE.appDelegate.showErrorTab(withMessage: response["msg"] as! String, andType: NOTIFICATION_TYPE.success)
                self.viewHideInAnimation(withViewFrameYPosition: self.view.frame.size.height, withSelectedView: self.forgotPasswordView, withEstimatedHeight: 0)
            } else {
                print("Error")
                let response = dictResponse["res"] as! NSDictionary
                APP_DELEGATE.appDelegate.showErrorTab(withMessage: response["msg"] as! String, andType: NOTIFICATION_TYPE.error)
            }
        })
    }
    
    //MARK: - UITextField Delegate -
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        txtFldLoginPassword.errorMessage = ""
        txtFldLoginMobileNumber.errorMessage = ""
        txtFldSignUpPassword.errorMessage = ""
        txtFldSignUpMobileNumber.errorMessage = ""
        txtfldEmailId.errorMessage = ""
        txtfldInviteCode.errorMessage = ""
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
   
    
    //MARK: - Animation part -
    func viewShowInAnimation(withViewFrameYPosition yPostion : CGFloat, withSelectedView customView: UIView, withEstimatedHeight height : CGFloat){
        UIView.transition(with: customView, duration: 0.2, options: .curveEaseIn,
                          animations: {
                            customView.frame.origin.y = yPostion
                            customView.frame.size.height = height
                            self.btnBG?.isHidden = false
        },
                          completion: { finished in
                            // Compeleted
        })
    }
    func viewHideInAnimation(withViewFrameYPosition yPostion : CGFloat, withSelectedView customView: UIView, withEstimatedHeight height : CGFloat){
        self.view.endEditing(true)
        UIView.transition(with: customView, duration: 0.2, options: .curveEaseOut,
                          animations: {
                            customView.frame.origin.y = yPostion
                            customView.frame.size.height = height
                            
        },
                          completion: { finished in
                  
                            self.btnBG?.isHidden = true
                            
                            
                            // Compeleted
        })
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardHeight = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            if !forgotPasswordView.txtFldEnterValue.isFirstResponder {
                self.logInScrollView.contentOffset = CGPoint(x: 0, y: keyboardHeight)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        self.logInScrollView.contentOffset = CGPoint(x: 0, y: 0)
        
    }
    
    //MARK: - -
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

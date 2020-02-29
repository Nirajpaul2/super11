//
//  HomeViewController.swift
//  GoSuper11
//


import UIKit
import AlamofireImage


class HomeViewController: UIViewController {

    //MARK: - IBOutlets and Variables -
    @IBOutlet weak var imgViewBackGroung : UIImageView!
    @IBOutlet weak var imgViewLogo             : UIImageView!
    @IBOutlet weak var btnLogin                     : UIButton!
    @IBOutlet weak var btnSignUp                  : UIButton!
    let downloader                                             = ImageDownloader()
    var pageDetailBo                                         = PageDetailBO()

    //MARK: - View lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        designAfterStoryBoard()
        serviceCallForGetPageDetails()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //MARK: - Design Part -
    func designAfterStoryBoard(){
        btnLogin.addShadow(cornerRadius: 6, opacity: 1, radius: 5, offset: (x: 0, y: 0), color: .lightGray)
        let attributedString = NSMutableAttributedString(string: "Sign Up")
        attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: attributedString.length))
        btnSignUp.setAttributedTitle(attributedString, for: .normal)
    }
    func imageSetUp(){
        self.btnLogin.setTitle(pageDetailBo.button_name?.capitalized, for: .normal)
        let urlImage = URL(string: pageDetailBo.banner_image!)
        let urlRequest = URLRequest(url: urlImage!)
        self.downloader.download(urlRequest) { response in
            if let image = response.result.value {
                self.imgViewBackGroung.image = image
                self.imgViewBackGroung.clipsToBounds = true
            } else {
                // imgView.contentMode = .scaleAspectFill
             //   let colorCode = UInt32("0x" + self.pageDetailBo.colorCode!)
             //   self.imgViewBackGroung.backgroundColor =  AppConstant.sharedInstance.UIColorFromHex(colorCode!, alpha: 1)
            }
        }
        
        let urlImageLogo = URL(string: pageDetailBo.logoimage!)
        let urlRequestLogo = URLRequest(url: urlImageLogo!)
        self.downloader.download(urlRequestLogo) { response in
            if let image = response.result.value {
                self.imgViewLogo.image = image
                self.imgViewLogo.clipsToBounds = true
            } else {
                // imgView.contentMode = .scaleAspectFill
                //self.imgViewLogo.image = #imageLiteral(resourceName: "Burger")
            }
        }
    }

    //MARK: - Servicecall method -
    func serviceCallForGetPageDetails(){
        AppConstant.sharedInstance.showActivityIndicatory(withTitle: "Loader...", andUserInteraction: false)
        let param = ["pagename":"landing_page"] as [String : Any]
        
        APIManeger.sharedInstance.serviceCallForGetdataInPost(withPath: API_PATH.kGetDetails, withData: param as NSDictionary, withCompletionHandler: { (withCompletionHandler:AnyObject?) in
            print("result : \(String(describing: withCompletionHandler))");
            AppConstant.sharedInstance.removeActivityIndicatory()
            let dictResponse = withCompletionHandler as! Dictionary<String, Any>
            let isSuccess : Int = dictResponse["stats"] as! Int
            
            if isSuccess == 1{
                print("Success")
                self.pageDetailBo = dictResponse["res"] as! PageDetailBO
                self.imageSetUp()
            } else {
                print("Error")
                APP_DELEGATE.appDelegate.showErrorTab(withMessage: STRING_CONSTANT.WRONG_MSG, andType: NOTIFICATION_TYPE.error)
            }
        })
    }
    
    //MARK: - Button action -
    @IBAction func btnLoginclicked(_ sender: Any) {
        let loginVC = INITIATE.INITIATE_STORY_BOARD(identifier: "LoginViewController") as! LoginViewController
        loginVC.isFromLogin = true
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @IBAction func btnSignUpClicked(_ sender: Any) {
        let loginVC = INITIATE.INITIATE_STORY_BOARD(identifier: "LoginViewController") as! LoginViewController
        loginVC.isFromLogin = false
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    //MARK: -  -
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

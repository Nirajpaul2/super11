//
//  ChooseCaptainViewController.swift
//  GoSuper11

import UIKit
import AlamofireImage

class ChooseCaptainViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    //MARK: - IBOutlets and Variables -
    var strMatchId  : String?
    var intTeamId : Int = 0
    let downloader                          = ImageDownloader()
    var strCaptainId    : String?
    var strViceCaptainId : String?
    @IBOutlet weak var lblTeamNameInTop: UILabel!
    @IBOutlet weak var lblTimeRemainingToStartMatch: UILabel!
    var timer : Timer!
    @IBOutlet weak var tblChooseCaptainViewController: UITableView!
    var selectedPlayerBo = PlayerWithTeamDetailBO()
    
    //MARK: - View lifeCycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationTitle()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(setTimeInTop), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        timer.invalidate()
    }

    //MARK: - Design Part -
    @objc func setTimeInTop(){
        self.lblTimeRemainingToStartMatch.text = AppConstant.sharedInstance.time(withDateString: AppConstant.sharedInstance.strMatchStartingTime!)
    }
    func setUpNavigationTitle(){
        navigationItem.leftBarButtonItems = nil
        var leftAddBarButtonItemBack = UIBarButtonItem()
        leftAddBarButtonItemBack = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.btnBackClicked(sender:)))
        let titel = UIBarButtonItem(title: "Create Team", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        navigationItem.leftBarButtonItems = [leftAddBarButtonItemBack, titel]
        var leftAddBarButtonItemMenu = UIBarButtonItem()
        leftAddBarButtonItemMenu = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: UIBarButtonItemStyle.plain, target: self, action: nil)
        navigationItem.rightBarButtonItems = [leftAddBarButtonItemMenu]
        self.lblTeamNameInTop.text = AppConstant.sharedInstance.strSelectedMatchTeamName
    }
    
    //MARK: - Tableview delegates and datasource -
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return selectedPlayerBo.arrWKPlayer.count
        case 1:
            return selectedPlayerBo.arrBATPlayer.count
        case 2:
            return selectedPlayerBo.arrALPlayer.count
        case 3:
            return selectedPlayerBo.arrBOWPlayers.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var playerDetailBO = PlayerDetailBO()
        switch indexPath.section {
        case 0:
            playerDetailBO = selectedPlayerBo.arrWKPlayer[indexPath.row]
        case 1:
            playerDetailBO = selectedPlayerBo.arrBATPlayer[indexPath.row]
        case 2:
            playerDetailBO = selectedPlayerBo.arrALPlayer[indexPath.row]
        case 3:
            playerDetailBO = selectedPlayerBo.arrBOWPlayers[indexPath.row]
        default:
            break
        }
         let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseCaptainTableViewCell", for: indexPath) as! ChooseCaptainTableViewCell
        cell.lblPlayerName.text = playerDetailBO.name
        cell.lblPoints.text = String(format: "%.2f Points", playerDetailBO.point!)
        cell.lblPlayerTeam.text = playerDetailBO.strTeamShortname
        
        
        if playerDetailBO.image_url != nil && playerDetailBO.image_url != ""{
            let urlImageLogo = URL(string: playerDetailBO.image_url!)
            let urlRequestLogo = URLRequest(url: urlImageLogo!)
            self.downloader.download(urlRequestLogo) { response in
                if let image = response.result.value {
                    cell.imgViewProfile.image = image
                    //cell.imgViewPlayerProfile.clipsToBounds = true
                } else {
                }
            }
        } else {
        }
//        if playerDetailBO.isPlayerSelected! {
//            cell.imgViewProfile.image = #imageLiteral(resourceName: "roundTick").imageWithColor(color: COLOR.COLOR_BUTTON_GREEN)
//        } else {
//            cell.imgViewProfile.image = #imageLiteral(resourceName: "roundTick").imageWithColor(color: COLOR.APP_BACKGROUNG_GRAY)
//        }
        cell.btnC.tag = 100 * indexPath.section + indexPath.row
        cell.btnVC.tag = 100 * indexPath.section + indexPath.row

        cell.btnC.addTarget(self, action: #selector(btnCaptainClicked(sender:)), for: .touchUpInside)
        cell.btnVC.addTarget(self, action: #selector(btnViceCaptainClicked(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "WICKET-KEEPER"
        case 1:
            return "BATSMEN"
        case 2:
            return "ALL-ROUNDERS"
        case 3:
            return "BOWLERS"
        default:
            return ""
        }
    }
    
    //MARK:- Button Action -
    @objc func btnBackClicked(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func btnCaptainClicked(sender : UIButton){
        let reminder = sender.tag % 100
        let tag = (sender.tag - reminder) / 100
        if sender.tag < 99 {
            guard let btnC = (self.tblChooseCaptainViewController.cellForRow(at: IndexPath(row: tag, section: 0)) as! ChooseCaptainTableViewCell).btnC else {
                return
            }
            btnC.backgroundColor = COLOR.COLOR_BUTTON_GREEN
            btnC.setTitleColor(UIColor.white, for: .normal)
            strCaptainId = self.selectedPlayerBo.arrWKPlayer[tag].player_id
        }
        else if sender.tag < 199 {
            guard let btnC = (self.tblChooseCaptainViewController.cellForRow(at: IndexPath(row: tag, section: 1)) as! ChooseCaptainTableViewCell).btnC else {
                return
            }
            btnC.backgroundColor = COLOR.COLOR_BUTTON_GREEN
            btnC.setTitleColor(UIColor.white, for: .normal)
            strCaptainId = self.selectedPlayerBo.arrBATPlayer[tag].player_id
        }
        else if sender.tag < 299 {
            guard let btnC = (self.tblChooseCaptainViewController.cellForRow(at: IndexPath(row: tag, section: 2)) as! ChooseCaptainTableViewCell).btnC else {
                return
            }
            btnC.backgroundColor = COLOR.COLOR_BUTTON_GREEN
            btnC.setTitleColor(UIColor.white, for: .normal)
            strCaptainId = self.selectedPlayerBo.arrALPlayer[tag].player_id
        }
        else if sender.tag < 399 {
            guard let btnC = (self.tblChooseCaptainViewController.cellForRow(at: IndexPath(row: tag, section: 3)) as! ChooseCaptainTableViewCell).btnC else {
                return
            }
            btnC.backgroundColor = COLOR.COLOR_BUTTON_GREEN
            btnC.setTitleColor(UIColor.white, for: .normal)
            strCaptainId = self.selectedPlayerBo.arrBOWPlayers[tag].player_id
        }
    }
    @objc func btnViceCaptainClicked(sender : UIButton){
        let reminder = sender.tag % 100
        let tag = (sender.tag - reminder) / 100
        if sender.tag < 99 {
            guard let btnC = (self.tblChooseCaptainViewController.cellForRow(at: IndexPath(row: tag, section: 0)) as! ChooseCaptainTableViewCell).btnVC else {
                return
            }
            btnC.backgroundColor = COLOR.COLOR_NAVIGATIONBAR
            btnC.setTitleColor(UIColor.white, for: .normal)
            strViceCaptainId = self.selectedPlayerBo.arrWKPlayer[tag].player_id
        }
        else if sender.tag < 199 {
            guard let btnC = (self.tblChooseCaptainViewController.cellForRow(at: IndexPath(row: tag, section: 1)) as! ChooseCaptainTableViewCell).btnVC else {
                return
            }
            btnC.backgroundColor = COLOR.COLOR_NAVIGATIONBAR
            btnC.setTitleColor(UIColor.white, for: .normal)
            strViceCaptainId = self.selectedPlayerBo.arrBATPlayer[tag].player_id
        }
        else if sender.tag < 299 {
            guard let btnC = (self.tblChooseCaptainViewController.cellForRow(at: IndexPath(row: tag, section: 2)) as! ChooseCaptainTableViewCell).btnVC else {
                return
            }
            btnC.backgroundColor = COLOR.COLOR_NAVIGATIONBAR
            btnC.setTitleColor(UIColor.white, for: .normal)
            strViceCaptainId = self.selectedPlayerBo.arrALPlayer[tag].player_id
        }
        else if sender.tag < 399 {
            guard let btnC = (self.tblChooseCaptainViewController.cellForRow(at: IndexPath(row: tag, section: 3)) as! ChooseCaptainTableViewCell).btnVC else {
                return
            }
            btnC.backgroundColor = COLOR.COLOR_NAVIGATIONBAR
            btnC.setTitleColor(UIColor.white, for: .normal)
            strViceCaptainId = self.selectedPlayerBo.arrBOWPlayers[tag].player_id
        }
    }
   
    @IBAction func btnSaveItemClicked(_ sender: Any) {
        if strViceCaptainId != nil &&  strCaptainId != nil {
            self.serviceCallForCreateTeam()
        } else {
            APP_DELEGATE.appDelegate.showErrorTab(withMessage: "Please choose captain and vice captain from the list", andType: NOTIFICATION_TYPE.none)
            let btn = sender as! UIButton
            btn.shake()
        }
    }
    
    //MARK: - Servicecall method -
    func serviceCallForCreateTeam(){
        AppConstant.sharedInstance.showActivityIndicatory(withTitle: "Loader...", andUserInteraction: false)
        var strIds : String = ""
        for i in 0..<selectedPlayerBo.arrSelectedPlayerId.count{
            if selectedPlayerBo.arrSelectedPlayerId.count - 1 != i {
                strIds.append(selectedPlayerBo.arrSelectedPlayerId[i] + "####")
            } else {
                strIds.append(selectedPlayerBo.arrSelectedPlayerId[i])
            }
        }
        let param = ["selected_plyers" : strIds, "match_id" : strMatchId,"captain_id" : strCaptainId,  "vicecaptain_id" : strViceCaptainId, "team_id" : intTeamId, "userid" : UserDefaults.standard.value(forKey: STRING_CONSTANT.KEY_USERID) ]
        APIManeger.sharedInstance.serviceCallForGetdataInPost(withPath: API_PATH.kSaveTeam, withData: param as NSDictionary, withCompletionHandler: { (withCompletionHandler:AnyObject?) in
            AppConstant.sharedInstance.removeActivityIndicatory()
            print("result : \(String(describing: withCompletionHandler))");
            let dictResponse = withCompletionHandler as! Dictionary<String, Any>
            let isSuccess : Int = dictResponse["stats"] as! Int
            
            if isSuccess == 1{
                print("Success")
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: MyTeamViewController.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            } else {
                print("Error")
                APP_DELEGATE.appDelegate.showErrorTab(withMessage: STRING_CONSTANT.WRONG_MSG, andType: NOTIFICATION_TYPE.none)
            }
        })
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

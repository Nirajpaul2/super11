//
//  JoinContestViewController.swift
//  GoSuper11
//
//  Created by Krishna on 07/09/18.
//  Copyright © 2018 Krishna. All rights reserved.
//

import UIKit

class JoinContestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    //MARK: - IBOutlets and Variables -
    
    @IBOutlet weak var lblTotalWinnerPrice: UILabel!
    @IBOutlet weak var heightConstaOfWinnerView: NSLayoutConstraint!
    @IBOutlet weak var tblWinnersRankBreakUp: UITableView!
    @IBOutlet weak var winnersView: UIView!
    @IBOutlet weak var lblremainingTimeToStartMatch: UILabel!
    @IBOutlet weak var lblTeamNameInTop: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var btnMyTeams: UIButton!
    @IBOutlet weak var lblJoinContestCount: UILabel!
    @IBOutlet weak var lblMyTeamCount: UILabel!
    @IBOutlet weak var tblJoinContest: UITableView!
    var arrContestList = [contestDetailBO]()
    var strMatchId : String?
    var timer : Timer!
    var inviteCodeView  :  PopUpWithTextFiled!
    var btnBG : UIButton?
    var selectedWinner : Int = 0
    
    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationTitle()
        serviceCallForGetContestDetails()
        lblJoinContestCount.layer.cornerRadius = lblJoinContestCount.frame.size.width / 2
        lblJoinContestCount.layer.borderColor  = UIColor.white.cgColor
        lblJoinContestCount.layer.borderWidth = 2.0
        
        lblMyTeamCount.layer.cornerRadius = lblMyTeamCount.frame.size.width / 2
        lblMyTeamCount.layer.borderColor  = UIColor.white.cgColor
        lblMyTeamCount.layer.borderWidth = 2.0
        topView.addShadow(cornerRadius: 0, opacity: 1, radius: 3, offset: (x: 0, y: 3), color: COLOR.COLOR_BUTTON_LIGHTGRAY)
        let footerView = UIView()
        self.tblJoinContest.tableFooterView = footerView
        btnBG = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        btnBG?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        btnBG?.isHidden = true
        btnBG?.addTarget(self, action: #selector(btnBGClicked(sender:)), for: .touchUpInside)
        self.view.addSubview(btnBG!)
        designPopUpForInviteCode()
        heightConstaOfWinnerView.constant = 0
        self.winnersView.isHidden = true
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
    func setUpNavigationTitle(){
        navigationItem.leftBarButtonItems = nil
        var leftAddBarButtonItemBack = UIBarButtonItem()
        leftAddBarButtonItemBack = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.btnBackClicked(sender:)))
        let titel = UIBarButtonItem(title: "Join Contest", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        navigationItem.leftBarButtonItems = [leftAddBarButtonItemBack, titel]
        var leftAddBarButtonItemMenu = UIBarButtonItem()
        leftAddBarButtonItemMenu = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: UIBarButtonItemStyle.plain, target: self, action: nil)
        navigationItem.rightBarButtonItems = [leftAddBarButtonItemMenu]
        self.lblTeamNameInTop.text = AppConstant.sharedInstance.strSelectedMatchTeamName
    }
    
    func designPopUpForInviteCode(){
        inviteCodeView = PopUpWithTextFiled.instanceFromNib() as! PopUpWithTextFiled
        inviteCodeView.isHidden = true
        inviteCodeView.txtFldEnterValue.delegate = self
        inviteCodeView.txtFldEnterValue.placeholder = "Enter Invite Code"
        inviteCodeView.txtFldEnterValue.title = "Invite Code"
        self.inviteCodeView.btnSubmit.tag = 100
       // inviteCodeView.btnSubmit.addTarget(self, action: #selector(btnSubmitClicked(sender:)), for: .touchUpInside)
        inviteCodeView.addShadow(cornerRadius: 6, opacity: 1, radius: 5, offset: (x: 0, y: 0), color: .lightGray)
        inviteCodeView.frame = CGRect(x: 30, y: self.view.frame.size.height, width: self.view.frame.size.width - 60, height: 0)
        self.inviteCodeView.btnSubmit.backgroundColor = COLOR.COLOR_BUTTON_GREEN
        self.inviteCodeView.lblTitle.isHidden = false
        self.inviteCodeView.lblTitle.addShadow(cornerRadius: 6, opacity: 1, radius: 3, offset: (x: 0, y: 3), color: COLOR.COLOR_BUTTON_LIGHTGRAY)

        self.inviteCodeView.btnSubmit.setTitle("JOIN THIS CONTEST", for: .normal)

        self.view.addSubview(inviteCodeView)
    }

    
    @objc func setTimeInTop(){
        self.lblremainingTimeToStartMatch.text = AppConstant.sharedInstance.time(withDateString: AppConstant.sharedInstance.strMatchStartingTime!)        
    }
    
    //MARK: - Tableview delegates and datasource -
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return tableView == self.tblJoinContest ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tblJoinContest {
            if section == 0 {
                return self.arrContestList.count
            }
            return 2
        } else {
            if self.arrContestList.count > 0 {
                return self.arrContestList[selectedWinner].arrwinnerBreakups.count
            } else {
                return 0
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tblJoinContest {
            if indexPath.section == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "JoinContestTableViewCell", for: indexPath) as! JoinContestTableViewCell
                cell.lblNumberofTeams.text = String(format: "%d Teams", self.arrContestList[indexPath.row].join_contest_count!)
                cell.lblEntryFee.text = String(format: "₹%.2f", self.arrContestList[indexPath.row].entry_fee!)
                var price : Float = 0.0
                for i in 0..<self.arrContestList[indexPath.row].arrwinnerBreakups.count{
                    let winner = self.arrContestList[indexPath.row].arrwinnerBreakups[i]
                    let value = Float((winner.last_rank! -  winner.first_rank!) + 1) * winner.price!
                    price = price + value
                }
                
                cell.lblTotalWinnersPrice.text = String(format: "Rs.%.2f", price)
                cell.lblTotalWinersCount.text = String(format: "%d", self.arrContestList[indexPath.row].arrwinnerBreakups[self.arrContestList[indexPath.row].arrwinnerBreakups.count - 1].last_rank!)
                cell.btnJoin.addTarget(self, action: #selector(btnJoinTeamClicked(sender:)), for: .touchUpInside)
                if  self.arrContestList[indexPath.row].contest_size == self.arrContestList[indexPath.row].join_contest_count{
                    cell.lblContestStatus.text = "Contest full"
                } else {
                    cell.lblContestStatus.text = String(format: "Only %d spots left", self.arrContestList[indexPath.row].contest_size! - self.arrContestList[indexPath.row].join_contest_count!)
                }
                
                if self.arrContestList[indexPath.row].join_user_limit != 0{
                    if self.arrContestList[indexPath.row].join_contest_count! > self.arrContestList[indexPath.row].join_user_limit!{
                        let lbljoinContextWidth = (cell.widthConstantofViewlimit.constant / CGFloat(self.arrContestList[indexPath.row].contest_size!) ) * CGFloat(self.arrContestList[indexPath.row].join_contest_count!)
                        let lblJoinContext = UILabel(frame: CGRect(x: 0, y: 0, width: lbljoinContextWidth, height: cell.ViewLimit.frame.size.height))
                        lblJoinContext.backgroundColor = COLOR.COLOR_BUTTON_GREEN
                        cell.ViewLimit.addSubview(lblJoinContext)
                        
                        let lblUserLimitWidth = (cell.widthConstantofViewlimit.constant / CGFloat(self.arrContestList[indexPath.row].contest_size!) ) * CGFloat(self.arrContestList[indexPath.row].join_user_limit!)
                        let lblUserLimit = UILabel(frame: CGRect(x: 0, y: 0, width: lblUserLimitWidth, height: cell.ViewLimit.frame.size.height))
                        lblUserLimit.backgroundColor = UIColor.red
                        let lblBarrior = UILabel(frame: CGRect(x: lblUserLimit.frame.maxX , y: -4, width: 2, height: cell.ViewLimit.frame.size.height + 8))
                        lblBarrior.backgroundColor = UIColor.red
                        cell.ViewLimit.addSubview(lblBarrior)
                        cell.ViewLimit.addSubview(lblUserLimit)
                    } else {
                        var lblUserLimitWidth : CGFloat?
                        if self.arrContestList[indexPath.row].join_user_limit == self.arrContestList[indexPath.row].contest_size {
                            lblUserLimitWidth = cell.widthConstantofViewlimit.constant
                        } else {
                            lblUserLimitWidth = (cell.widthConstantofViewlimit.constant / CGFloat(self.arrContestList[indexPath.row].contest_size!) ) * CGFloat(self.arrContestList[indexPath.row].join_user_limit!)
                        }
                        
                        let lblUserLimit = UILabel(frame: CGRect(x: 0, y: 0, width: lblUserLimitWidth!, height: cell.ViewLimit.frame.size.height))
                        lblUserLimit.backgroundColor = UIColor.red
                        let lblBarrior = UILabel(frame: CGRect(x: lblUserLimit.frame.maxX , y: -4, width: 2, height: cell.ViewLimit.frame.size.height + 8))
                        lblBarrior.backgroundColor = UIColor.red
                        cell.ViewLimit.addSubview(lblBarrior)
                        cell.ViewLimit.addSubview(lblUserLimit)
                    }
                } else {
                    let lblUserLimitWidth = (cell.widthConstantofViewlimit.constant / CGFloat(self.arrContestList[indexPath.row].contest_size!) ) * CGFloat(self.arrContestList[indexPath.row].join_contest_count!)
                    let lblUserLimit = UILabel(frame: CGRect(x: 0, y: 0, width: lblUserLimitWidth, height: cell.ViewLimit.frame.size.height))
                    lblUserLimit.backgroundColor = UIColor.red
                    cell.ViewLimit.addSubview(lblUserLimit)
                }
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PlayWithFriendsTableViewCell", for: indexPath) as! PlayWithFriendsTableViewCell
                if indexPath.row == 1{
                    cell.lblTitle.text = "Got a Contest Code?"
                } else {
                    cell.lblTitle.text = "Make Your Own Contest"
                }
                return cell
            }
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WinnerBreakUpTableViewCell", for: indexPath) as! WinnerBreakUpTableViewCell
            cell.lblRank.text = String(format: "Rank: %d - %d", self.arrContestList[selectedWinner].arrwinnerBreakups[indexPath.row].first_rank! , self.arrContestList[selectedWinner].arrwinnerBreakups[indexPath.row].last_rank!)
            cell.lblPrice.text = String(format: "Rs %.2f", self.arrContestList[selectedWinner].arrwinnerBreakups[indexPath.row].price!)
            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 1{
                self.inviteCodeView.isHidden = false
               // self.inviteCodeView.txtFldEnterValue.becomeFirstResponder()
                self.viewShowInAnimation(withViewFrameYPosition: self.view.frame.size.height / 2 - 120, withSelectedView: self.inviteCodeView, withEstimatedHeight: 180)
            }
        } else {
            self.winnersView.isHidden = false
            selectedWinner = indexPath.row
            var price : Float = 0.0
            for i in 0..<self.arrContestList[selectedWinner].arrwinnerBreakups.count {
                let winner = self.arrContestList[selectedWinner].arrwinnerBreakups[i]
                let value = Float((winner.last_rank! -  winner.first_rank!) + 1) * winner.price!
                price = price + value
            }
            self.lblTotalWinnerPrice.text = String(format: "Rs.%.2f", price)
            self.tblWinnersRankBreakUp.reloadData()
            let height : CGFloat?
            if CGFloat(self.arrContestList[selectedWinner].arrwinnerBreakups.count * 50  + 300) > self.view.frame.size.height - 48 {
                height = self.view.frame.size.height - 48
            } else {
                height = CGFloat(self.arrContestList[selectedWinner].arrwinnerBreakups.count * 50  + 300)
            }
            self.viewShowInAnimation(withViewFrameYPosition: self.view.frame.size.height - height!, withSelectedView: self.winnersView, withEstimatedHeight: height!)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 70))
        footerView.backgroundColor = UIColor.groupTableViewBackground
        let lblPlayWithFriends = UILabel(frame: CGRect(x: 23, y: 15, width: tableView.frame.size.width - 23, height: 20))
        lblPlayWithFriends.text = "PLAY WITH FRIENDS"
        //lblPlayWithFriends.font = GLOBAL_CONSTANT.FONT_REGULAR(size: 18)
        footerView.addSubview(lblPlayWithFriends)
        let lblProveYourSkil = UILabel(frame: CGRect(x: 23, y: lblPlayWithFriends.frame.maxY, width: tableView.frame.size.width - 23, height: 20))
        lblProveYourSkil.text = "Prove your skill!"
        lblProveYourSkil.font = self.lblremainingTimeToStartMatch.font
        footerView.addSubview(lblProveYourSkil)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0  || tableView == self.tblWinnersRankBreakUp ? 0 : 70
    }
    
    
    //MARK: - Button Action -
    @IBAction func btnMyTeamsClicked(_ sender: Any) {
        //if self.arrContestList[0].total_team == 0{
            let myTeamVC = INITIATE.INITIATE_STORY_BOARD(identifier: "MyTeamViewController") as! MyTeamViewController
            myTeamVC.strMatchId = self.strMatchId
            myTeamVC.isFromJoinContest = false
            self.navigationController?.pushViewController(myTeamVC, animated: true)
      //  }
    }
    
    @IBAction func btnWinnersClicked(_ sender: Any) {
        self.winnersView.isHidden = true
        self.viewShowInAnimation(withViewFrameYPosition: 48, withSelectedView: self.winnersView, withEstimatedHeight: self.view.frame.size.height - 48)
    }
    
    
    @objc func btnBackClicked(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnJoinTeamClicked(sender: UIButton){
        if self.arrContestList[0].total_team == 0{
                let createMatchVC = INITIATE.INITIATE_STORY_BOARD(identifier: "CreateTeamViewController") as! CreateTeamViewController
                createMatchVC.strMatchId = self.strMatchId
                self.navigationController?.pushViewController(createMatchVC, animated: true)
        } else{
                let createMatchVC = INITIATE.INITIATE_STORY_BOARD(identifier: "MyTeamViewController") as! MyTeamViewController
                createMatchVC.strMatchId = self.strMatchId
                createMatchVC.isFromJoinContest = true
                self.navigationController?.pushViewController(createMatchVC, animated: true)
        }
    }
    @objc func btnBGClicked(sender : UIButton){
        sender.isHidden = true
        if self.inviteCodeView.isHidden == false{
            self.inviteCodeView.isHidden = true
            self.viewHideInAnimation(withViewFrameYPosition: self.view.frame.size.height, withSelectedView: self.inviteCodeView, withEstimatedHeight: 0)
        } else {
            self.winnersView.isHidden = true
            self.viewHideInAnimation(withViewFrameYPosition: self.view.frame.size.height, withSelectedView: self.winnersView, withEstimatedHeight: 0)
        }
        
    }

    @IBAction func btnCloseClicked(_ sender: Any) {
        self.viewHideInAnimation(withViewFrameYPosition: self.view.frame.size.height, withSelectedView: self.winnersView, withEstimatedHeight: 0)
    }
    
    
    //MARK: - Animation part -
    func viewShowInAnimation(withViewFrameYPosition yPostion : CGFloat, withSelectedView customView: UIView, withEstimatedHeight height : CGFloat){
        UIView.transition(with: customView, duration: 0.2, options: .curveEaseIn,
                          animations: {
                            if customView == self.winnersView {
                                self.view.bringSubview(toFront: self.winnersView)
                                self.heightConstaOfWinnerView.constant = height
                            }
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
                            if customView == self.winnersView {
                                self.heightConstaOfWinnerView.constant = 0
                                self.winnersView.isHidden = true
                            }
                            customView.frame.origin.y = yPostion
                            customView.frame.size.height = height
                            
        },
                          completion: { finished in
                            
                            self.btnBG?.isHidden = true
                            
                            
                            // Compeleted
        })
    }
    
    //MARK: - Servicecall Method -
    func serviceCallForGetContestDetails(){
        AppConstant.sharedInstance.showActivityIndicatory(withTitle: "Loader...", andUserInteraction: false)
        let param = ["user_id": UserDefaults.standard.value(forKey: STRING_CONSTANT.KEY_USERID)! , "match_id"  : strMatchId ?? "" ] as [String : Any]
        
        APIManeger.sharedInstance.serviceCallForGetdataInPost(withPath: API_PATH.kGetContestList, withData: param as NSDictionary, withCompletionHandler: { (withCompletionHandler:AnyObject?) in
            AppConstant.sharedInstance.removeActivityIndicatory()
            print("result : \(String(describing: withCompletionHandler))");
            let dictResponse = withCompletionHandler as! Dictionary<String, Any>
            let isSuccess : Int = dictResponse["stats"] as! Int
            
            if isSuccess == 1{
                print("Success")
                self.arrContestList = dictResponse["res"] as! [contestDetailBO]
                self.tblJoinContest.reloadData()
                if self.arrContestList.count > 0 {
                    self.lblMyTeamCount.text =  String(format: "%d", self.arrContestList[0].total_team!)
                    self.lblJoinContestCount.text = String(format: "%d", self.arrContestList[0].total_join_contest!)
                }
               
            } else {
                print("Error")
               // APP_DELEGATE.appDelegate.showErrorTab(withMessage: , andType: NOTIFICATION_TYPE.error)
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

//
//  MyTeamViewController.swift
//  GoSuper11
//
//  Created by Krishna on 13/09/18.
//  Copyright © 2018 Krishna. All rights reserved.
//

import UIKit

class MyTeamViewController: UIViewController , UITableViewDelegate , UITableViewDataSource  {

    //MARK: - IBOutles and Varables -
    @IBOutlet weak var topViewTimer: UIView!
    @IBOutlet weak var NoTeamView: UIView!
    @IBOutlet weak var tblMyTeamList: UITableView!
    @IBOutlet weak var btnCreateTeam: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var lblTeamCountTtitle: UILabel!
    @IBOutlet weak var lblTeamCount: UILabel!
    @IBOutlet weak var lblTmeRemainingToStartMatch: UILabel!
    @IBOutlet weak var lblTeamNameInTop: UILabel!
    var timer : Timer!
    var strMatchId : String?
    var arrMyTeams = [MyTeamListBO]()
    var isFromJoinContest : Bool?
    
    //MARK: - View lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationTitle()
        topViewTimer.addShadow(cornerRadius: 0, opacity: 1, radius: 3, offset: (x: 0, y: 3), color: COLOR.COLOR_BUTTON_LIGHTGRAY)
        if isFromJoinContest!  {
            btnCreateTeam.setTitle("          JOIN CONTEST          ", for: .normal)
        } else {
            btnCreateTeam.setTitle("          CREAT TEAM          ", for: .normal)
        }
        btnCreateTeam.addShadow(cornerRadius: 6, opacity: 1, radius: 5, offset: (x: 0, y: 0), color: .lightGray)

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        serviceCallForGetTeamList()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(setTimeInTop), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        timer.invalidate()
    }
    
    @objc func setTimeInTop(){
        self.lblTmeRemainingToStartMatch.text = AppConstant.sharedInstance.time(withDateString: AppConstant.sharedInstance.strMatchStartingTime!)
    }
    
    func setUpNavigationTitle(){
        navigationItem.leftBarButtonItems = nil
        var leftAddBarButtonItemBack = UIBarButtonItem()
        leftAddBarButtonItemBack = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.btnBackClicked(sender:)))
        let titel = UIBarButtonItem(title: "My Teams", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        navigationItem.leftBarButtonItems = [leftAddBarButtonItemBack, titel]
        var leftAddBarButtonItemMenu = UIBarButtonItem()
        leftAddBarButtonItemMenu = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: UIBarButtonItemStyle.plain, target: self, action: nil)
        navigationItem.rightBarButtonItems = [leftAddBarButtonItemMenu]
        self.lblTeamNameInTop.text = AppConstant.sharedInstance.strSelectedMatchTeamName

    }

    
    //MARK: - Tableview delegates and datasource -
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrMyTeams.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTeamListTableViewCell", for: indexPath) as! MyTeamListTableViewCell
        var teamBo = MyTeamListBO()
        teamBo = self.arrMyTeams[indexPath.section]
        //cell.lblWKCount.text = teamBo.total_WK
        cell.lblAllCount.text = teamBo.total_alrounder
        cell.lblBATCount.text = teamBo.total_batting
        cell.lblBOWCount.text = teamBo.total_boweler
        cell.lblTeamName.text = teamBo.team_name
        cell.lblCaptainName.text = teamBo.captain_name
        cell.lblViceCaptainName.text = teamBo.viccaptain_name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK: - Button Action -
    @objc func btnBackClicked(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnCreateTeamClicked(_ sender: Any) {
            let createMatchVC = INITIATE.INITIATE_STORY_BOARD(identifier: "CreateTeamViewController") as! CreateTeamViewController
            createMatchVC.strMatchId = strMatchId
            self.navigationController?.pushViewController(createMatchVC, animated: true)
    }
    
    //MARK: - Servicecall Method -
    func serviceCallForGetTeamList(){
        AppConstant.sharedInstance.showActivityIndicatory(withTitle: "Loader...", andUserInteraction: false)
        let param = ["user_id": UserDefaults.standard.value(forKey: STRING_CONSTANT.KEY_USERID)! , "match_id"  : strMatchId ?? "" ] as [String : Any]
        
        APIManeger.sharedInstance.serviceCallForGetdataInPost(withPath: API_PATH.kGetTeamlist, withData: param as NSDictionary, withCompletionHandler: { (withCompletionHandler:AnyObject?) in
            AppConstant.sharedInstance.removeActivityIndicatory()
            print("result : \(String(describing: withCompletionHandler))");
            let dictResponse = withCompletionHandler as! Dictionary<String, Any>
            let isSuccess : Int = dictResponse["stats"] as! Int
            
            if isSuccess == 1{
                print("Success")
                self.NoTeamView.isHidden = true
                self.tblMyTeamList.isHidden = false
                self.arrMyTeams = dictResponse["res"] as! [MyTeamListBO]
                self.tblMyTeamList.reloadData()
                self.btnCreateTeam.setTitle("          CREATE TEAM " + String(self.arrMyTeams.count + 1) + "          ", for: .normal)
                if self.arrMyTeams.count == Int(self.arrMyTeams[0].total_team_limit!)!{
                    self.btnCreateTeam.isEnabled = false
                } else {
                    self.btnCreateTeam.isEnabled = true
                }
            } else {
                print("Error")
                self.NoTeamView.isHidden = false
                self.tblMyTeamList.isHidden = true
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

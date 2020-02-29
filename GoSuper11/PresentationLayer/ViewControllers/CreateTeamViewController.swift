//
//  CreateTeamViewController.swift
//  GoSuper11


import UIKit
import XMSegmentedControl
import AlamofireImage

class CreateTeamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, XMSegmentedControlDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {

    //MARK: - IBOutlets and variables -
    
    @IBOutlet weak var lblTimerInTop: UILabel!
    @IBOutlet weak var lblTeamNameInTop: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var lblARSelectedStatus: UILabel!
    @IBOutlet weak var imgViewAR: UIImageView!
    @IBOutlet weak var lblBOWSelectedStatus: UILabel!
    @IBOutlet weak var imgViewBOW: UIImageView!
    @IBOutlet weak var lblBATSelectedStatus: UILabel!
    @IBOutlet weak var imgViewBAT: UIImageView!
    @IBOutlet weak var lblWKSelectedStatus: UILabel!
    @IBOutlet weak var imgViewWK: UIImageView!
    @IBOutlet weak var btnTeamPreview: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var lblTotalPlayerCount: UILabel!
    @IBOutlet weak var lblTeamTwoName: UILabel!
    @IBOutlet weak var lblTeamTwoPlayerCount: UILabel!
    @IBOutlet weak var lblTeamOneName: UILabel!
    @IBOutlet weak var lblTeamOnePlayerCount: UILabel!
    @IBOutlet weak var lblCreditScore: UILabel!
    @IBOutlet weak var segmentControlCategory: XMSegmentedControl!
    @IBOutlet weak var tblPlayerDetailList: UITableView!
    let downloader                          = ImageDownloader()
    var playerWithTeamBo = PlayerWithTeamDetailBO()
    var selectedPlayerBo = PlayerWithTeamDetailBO()
    var strMatchId  : String?
    var wkCount : Int = 0
    var batCount : Int = 0
    var bowCount : Int = 0
    var arCount : Int = 0
    var matchPreViewView :   MatchPreViewView!
    var intTeamId : Int = 0
    var timer : Timer!

    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        serviceCallForGetPlayerDetails()
        designAfterStoryBoard()
        let footerView = UIView()
        self.tblPlayerDetailList.tableFooterView = footerView
        scoreCalculation()
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
        self.lblTimerInTop.text = AppConstant.sharedInstance.time(withDateString: AppConstant.sharedInstance.strMatchStartingTime!)
    }
    
    func designAfterStoryBoard(){
        matchPreViewView = MatchPreViewView.instanceFromNib() as! MatchPreViewView
        matchPreViewView.isHidden = true
        matchPreViewView.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 0)
        self.view.addSubview(matchPreViewView)
        
        
        matchPreViewView.collctionViewBL.register(UINib(nibName: "SelectedPlayerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SelectedPlayerCollectionViewCell")
        matchPreViewView.collectionViewAL.register(UINib(nibName: "SelectedPlayerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SelectedPlayerCollectionViewCell")
        matchPreViewView.collectionViewBAT.register(UINib(nibName: "SelectedPlayerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SelectedPlayerCollectionViewCell")
        matchPreViewView.collectionViewWK.register(UINib(nibName: "SelectedPlayerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SelectedPlayerCollectionViewCell")

        matchPreViewView.collctionViewBL.delegate = self
        matchPreViewView.collctionViewBL.dataSource = self
        matchPreViewView.collectionViewAL.delegate = self
        matchPreViewView.collectionViewAL.dataSource = self
        matchPreViewView.collectionViewBAT.delegate = self
        matchPreViewView.collectionViewBAT.dataSource = self
        matchPreViewView.collectionViewWK.delegate = self
        matchPreViewView.collectionViewWK.dataSource = self
        matchPreViewView.btnClose.addTarget(self, action: #selector(btnCloseClicked(sender:)), for: .touchUpInside)
        
        let arrTitle = ["WK" , "BAT" , "BOW", "AR"]
        let arrImages = [ UIImage(named: "wkt.PNG") , UIImage(named: "bat.PNG"), UIImage(named: "bowl.PNG") , UIImage(named: "ar.PNG")] as! [UIImage]
        segmentControlCategory.segmentContent = (arrTitle , arrImages)
       // segmentControlCategory.setupVerticalSegmentContent((text: arrTitle, icon: arrImages))
        segmentControlCategory.backgroundColor = COLOR.APP_BACKGROUNG_GRAY
        segmentControlCategory.highlightColor = COLOR.COLOR_BUTTON_GREEN
        segmentControlCategory.selectedItemHighlightStyle = .bottomEdge
        segmentControlCategory.tint = UIColor.lightGray
        segmentControlCategory.highlightTint = COLOR.COLOR_BUTTON_GREEN
        segmentControlCategory.edgeHighlightHeight = 4
        // segmentCntrol.font = GLOBAL_CONSTANT.FONT_SEMIBOLD(size: 20)
        segmentControlCategory.selectedSegment = 0
        segmentControlCategory.delegate = self
        topView.addShadow(cornerRadius: 0, opacity: 1, radius: 3, offset: (x: 0, y: 3), color: COLOR.COLOR_BUTTON_LIGHTGRAY)
        segmentControlCategory.addShadow(cornerRadius: 0, opacity: 1, radius: 3, offset: (x: 0, y: 3), color: COLOR.COLOR_BUTTON_LIGHTGRAY)

        self.imgViewWK.image = UIImage(named:"greenbar_new.png" )
        self.imgViewWK.backgroundColor = COLOR.APP_BACKGROUNG_GRAY
        self.imgViewAR.backgroundColor = COLOR.APP_BACKGROUNG_GRAY
        self.imgViewBAT.backgroundColor = COLOR.APP_BACKGROUNG_GRAY
        self.imgViewBOW.backgroundColor = COLOR.APP_BACKGROUNG_GRAY

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
    
    func valueSetUp(){
        self.lblCreditScore.text =  "0"
        self.lblTeamOneName.text = self.playerWithTeamBo.matchdetailBo.taem1_sortName
        self.lblTeamTwoName.text = self.playerWithTeamBo.matchdetailBo.taem2_sortName
        self.lblTeamOnePlayerCount.text = "0"
        self.lblTeamTwoPlayerCount.text = "0"
        self.lblTotalPlayerCount.text = "0"
        self.lblTeamNameInTop.text = self.playerWithTeamBo.matchdetailBo.taem1_sortName! +  " VS " + self.playerWithTeamBo.matchdetailBo.taem2_sortName!
        
    }
    
    func scoreCalculation(){
        var totalScore : Float = 0
        var arrPlayerIds = [String]()

        for i in 0..<self.selectedPlayerBo.arrWKPlayer.count{
            totalScore = selectedPlayerBo.arrWKPlayer[i].credit_point! + totalScore
            arrPlayerIds.append(selectedPlayerBo.arrWKPlayer[i].player_id!)
        }
        
        
        for i in 0..<self.selectedPlayerBo.arrBATPlayer.count{
            totalScore = selectedPlayerBo.arrBATPlayer[i].credit_point! + totalScore
            arrPlayerIds.append(selectedPlayerBo.arrBATPlayer[i].player_id!)
        }
        for i in 0..<self.selectedPlayerBo.arrBOWPlayers.count{
            totalScore = selectedPlayerBo.arrBOWPlayers[i].credit_point! + totalScore
            arrPlayerIds.append(selectedPlayerBo.arrBOWPlayers[i].player_id!)
        }
        for i in 0..<self.selectedPlayerBo.arrALPlayer.count{
            totalScore = selectedPlayerBo.arrALPlayer[i].credit_point! + totalScore
            arrPlayerIds.append(selectedPlayerBo.arrALPlayer[i].player_id!)
        }
        
//        for j in 0..<self.playerWithTeamBo.arrTeamTwoPlayers.count{
//            totalScore = self.playerWithTeamBo.arrTeamTwoPlayers[j].credit_point! + totalScore
//        }
        if totalScore > 0{
            totalScore = 100 - totalScore
        }
        selectedPlayerBo.arrSelectedPlayerId = arrPlayerIds
         self.lblCreditScore.text =  String(format: "%.2f",totalScore )
        selectedPlayerBo.totalLeftPoint = totalScore
        self.lblTeamOnePlayerCount.text = String( selectedPlayerBo.teamOneCount)
        self.lblTeamTwoPlayerCount.text = String(selectedPlayerBo.teamTwoCount)
        self.lblTotalPlayerCount.text = String( selectedPlayerBo.teamOneCount + selectedPlayerBo.teamTwoCount)
        
        self.lblARSelectedStatus.text = String(format: "%d/1-3", self.selectedPlayerBo.arrALPlayer.count)
        self.lblWKSelectedStatus.text = String(format: "%d/1-1", self.selectedPlayerBo.arrWKPlayer.count)
        self.lblBATSelectedStatus.text = String(format: "%d/3-5", self.selectedPlayerBo.arrBATPlayer.count)
        self.lblBOWSelectedStatus.text = String(format: "%d/3-5", self.selectedPlayerBo.arrBOWPlayers.count)

        btnDone.isEnabled = validationPlayer()
        btnDone.backgroundColor = validationPlayer() ? COLOR.COLOR_BUTTON_GREEN : UIColor.lightGray
    }
    
    func validationPlayer() -> Bool{
        if selectedPlayerBo.arrWKPlayer.count < 1 {
            return false
        }
        else if selectedPlayerBo.arrBATPlayer.count < 3 {
            return false
        }
        else if selectedPlayerBo.arrBOWPlayers.count < 3 {
            return false
        }
        else if selectedPlayerBo.arrALPlayer.count < 1 {
            return false
        }
        else if selectedPlayerBo.teamOneCount + selectedPlayerBo.teamTwoCount  < 11 {
            return false
        }
        return true
    }
    
    //MARK: - Tableview delegates and datasource -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentControlCategory.selectedSegment {
        case 0:
            return playerWithTeamBo.arrWKPlayer.count
        case 1:
            return playerWithTeamBo.arrBATPlayer.count
        case 2:
            return playerWithTeamBo.arrBOWPlayers.count
        case 3:
            return playerWithTeamBo.arrALPlayer.count
        default:
            return 0
        }
       //return self.playerWithTeamBo.arrPlayerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerDetailsTableViewCell", for: indexPath) as! PlayerDetailsTableViewCell
        var playerDetailBO = PlayerDetailBO()
        
        switch segmentControlCategory.selectedSegment {
        case 0:
            playerDetailBO = playerWithTeamBo.arrWKPlayer[indexPath.row]
        case 1:
            playerDetailBO = playerWithTeamBo.arrBATPlayer[indexPath.row]
        case 2:
            playerDetailBO = playerWithTeamBo.arrBOWPlayers[indexPath.row]
        case 3:
            playerDetailBO = playerWithTeamBo.arrALPlayer[indexPath.row]
        default:
            break
        }
        
        cell.lblPlayername.text = playerDetailBO.name
        cell.lblPlayerCity.text = playerDetailBO.strTeamShortname! + "  |"
       
        
        if playerDetailBO.point == 0{
            cell.lblPlayerPoint.text = "0 Points"
        } else {
            cell.lblPlayerPoint.text = String(format: "%.2f Points", playerDetailBO.point!)
        }
        
        if playerDetailBO.credit_point == 0{
            cell.lblCredittedScore.text = "0"
        } else {
            cell.lblCredittedScore.text = String(format: "%.2f",playerDetailBO.credit_point!)
        }
        
        
        if playerDetailBO.image_url != nil && playerDetailBO.image_url != ""{
            let urlImageLogo = URL(string: playerDetailBO.image_url!)
            let urlRequestLogo = URLRequest(url: urlImageLogo!)
            self.downloader.download(urlRequestLogo) { response in
                if let image = response.result.value {
                    cell.imgViewPlayerProfile.image = image
                    //cell.imgViewPlayerProfile.clipsToBounds = true
                } else {
                }
            }
        } else {
        }
        if playerDetailBO.isPlayerSelected! {
            cell.imgViewSelected.image = #imageLiteral(resourceName: "roundTick").imageWithColor(color: COLOR.COLOR_BUTTON_GREEN)
        } else {
            cell.imgViewSelected.image = #imageLiteral(resourceName: "roundTick").imageWithColor(color: COLOR.APP_BACKGROUNG_GRAY)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var playerDetailBO = PlayerDetailBO()
        
        switch segmentControlCategory.selectedSegment {
        case 0:
            playerDetailBO = playerWithTeamBo.arrWKPlayer[indexPath.row]
            if selectedPlayerBo.arrWKPlayer.contains(playerDetailBO){
                selectedPlayerBo.arrWKPlayer.remove(at: selectedPlayerBo.arrWKPlayer.index(of: playerDetailBO)!)
                playerDetailBO.isPlayerSelected = false
                if playerDetailBO.strTeamShortname == self.playerWithTeamBo.matchdetailBo.taem1_sortName{
                    selectedPlayerBo.teamOneCount = selectedPlayerBo.teamOneCount - 1
                } else {
                    selectedPlayerBo.teamTwoCount = selectedPlayerBo.teamTwoCount - 1
                }
            } else {
                if selectedPlayerBo.arrWKPlayer.count != 1 && validation(){
                    selectedPlayerBo.arrWKPlayer.append(playerDetailBO)
                    playerDetailBO.isPlayerSelected = true
                    if playerDetailBO.strTeamShortname == self.playerWithTeamBo.matchdetailBo.taem1_sortName{
                        selectedPlayerBo.teamOneCount = selectedPlayerBo.teamOneCount + 1
                    } else {
                        selectedPlayerBo.teamTwoCount = selectedPlayerBo.teamTwoCount + 1
                    }
                } else {
                    //APP_DELEGATE.appDelegate.showErrorTab(withMessage: "Can not choose more than one WK.", andType: NOTIFICATION_TYPE.none)
                }
            }
        case 1:
            playerDetailBO = playerWithTeamBo.arrBATPlayer[indexPath.row]
            if selectedPlayerBo.arrBATPlayer.contains(playerDetailBO){
                selectedPlayerBo.arrBATPlayer.remove(at: selectedPlayerBo.arrBATPlayer.index(of: playerDetailBO)!)
                playerDetailBO.isPlayerSelected = false
                if playerDetailBO.strTeamShortname == self.playerWithTeamBo.matchdetailBo.taem1_sortName{
                    selectedPlayerBo.teamOneCount = selectedPlayerBo.teamOneCount - 1
                } else {
                    selectedPlayerBo.teamTwoCount = selectedPlayerBo.teamTwoCount - 1
                }
            } else {
                if selectedPlayerBo.arrBATPlayer.count < 5 && validation(){
                    selectedPlayerBo.arrBATPlayer.append(playerDetailBO)
                    playerDetailBO.isPlayerSelected = true
                    if playerDetailBO.strTeamShortname == self.playerWithTeamBo.matchdetailBo.taem1_sortName{
                        selectedPlayerBo.teamOneCount = selectedPlayerBo.teamOneCount + 1
                    } else {
                        selectedPlayerBo.teamTwoCount = selectedPlayerBo.teamTwoCount + 1
                    }
                } else {
                    //APP_DELEGATE.appDelegate.showErrorTab(withMessage: "Can not choose more than 5 BAT.", andType: NOTIFICATION_TYPE.none)
                }
                
            }
        case 2:
           
            playerDetailBO = playerWithTeamBo.arrBOWPlayers[indexPath.row]
            if selectedPlayerBo.arrBOWPlayers.contains(playerDetailBO){
                selectedPlayerBo.arrBOWPlayers.remove(at: selectedPlayerBo.arrBOWPlayers.index(of: playerDetailBO)!)
                playerDetailBO.isPlayerSelected = false
                if playerDetailBO.strTeamShortname == self.playerWithTeamBo.matchdetailBo.taem1_sortName{
                    selectedPlayerBo.teamOneCount = selectedPlayerBo.teamOneCount - 1
                } else {
                    selectedPlayerBo.teamTwoCount = selectedPlayerBo.teamTwoCount - 1
                }
            } else {
                if selectedPlayerBo.arrBOWPlayers.count < 5 && validation(){
                    selectedPlayerBo.arrBOWPlayers.append(playerDetailBO)
                    playerDetailBO.isPlayerSelected = true
                    if playerDetailBO.strTeamShortname == self.playerWithTeamBo.matchdetailBo.taem1_sortName{
                        selectedPlayerBo.teamOneCount = selectedPlayerBo.teamOneCount + 1
                    } else {
                        selectedPlayerBo.teamTwoCount = selectedPlayerBo.teamTwoCount + 1
                    }
                } else {
                    //APP_DELEGATE.appDelegate.showErrorTab(withMessage: "Can not choose more than 5 BOW.", andType: NOTIFICATION_TYPE.none)
                }
                
            }
        case 3:
            playerDetailBO = playerWithTeamBo.arrALPlayer[indexPath.row]
            if selectedPlayerBo.arrALPlayer.contains(playerDetailBO){
                selectedPlayerBo.arrALPlayer.remove(at: selectedPlayerBo.arrALPlayer.index(of: playerDetailBO)!)
                playerDetailBO.isPlayerSelected = false
                if playerDetailBO.strTeamShortname == self.playerWithTeamBo.matchdetailBo.taem1_sortName{
                    selectedPlayerBo.teamOneCount = selectedPlayerBo.teamOneCount - 1
                } else {
                    selectedPlayerBo.teamTwoCount = selectedPlayerBo.teamTwoCount - 1
                }
            } else {
                if selectedPlayerBo.arrALPlayer.count < 3 && validation(){
                    selectedPlayerBo.arrALPlayer.append(playerDetailBO)
                    playerDetailBO.isPlayerSelected = true
                    if playerDetailBO.strTeamShortname == self.playerWithTeamBo.matchdetailBo.taem1_sortName{
                        selectedPlayerBo.teamOneCount = selectedPlayerBo.teamOneCount + 1
                    } else {
                        selectedPlayerBo.teamTwoCount = selectedPlayerBo.teamTwoCount + 1
                    }
                } else {
                    //APP_DELEGATE.appDelegate.showErrorTab(withMessage: "Can not choose more than 3 AR.", andType: NOTIFICATION_TYPE.none)
                }
                
            }
        default:
            break
        }
        
        
//        if playerDetailBO.isPlayerSelected! {
//            if playerDetailBO.strTeamShortname == self.playerWithTeamBo.matchdetailBo.taem1_sortName {
//                for i in 0..<self.playerWithTeamBo.arrTeamOnePlayers.count{
//                    if self.playerWithTeamBo.arrTeamOnePlayers[i].uniqueId == playerDetailBO.uniqueId {
//                        self.playerWithTeamBo.arrTeamOnePlayers.remove(at: i)
//
//                        break
//                    }
//                }
//            } else {
//                for i in 0..<self.playerWithTeamBo.arrTeamTwoPlayers.count{
//                    if self.playerWithTeamBo.arrTeamTwoPlayers[i].uniqueId == playerDetailBO.uniqueId {
//                        self.playerWithTeamBo.arrTeamTwoPlayers.remove(at: i)
//                        break
//                    }
//                }
//            }
//            playerDetailBO.isPlayerSelected = !playerDetailBO.isPlayerSelected!
//        } else {
//
//            if Int(self.lblTotalPlayerCount.text!)! < 11 && (self.lblCreditScore.text! as NSString).floatValue < 100 {
//                if playerDetailBO.strTeamShortname == self.playerWithTeamBo.matchdetailBo.taem1_sortName {
//                    self.playerWithTeamBo.arrTeamOnePlayers.append(playerDetailBO)
//                } else {
//                    self.playerWithTeamBo.arrTeamTwoPlayers.append(playerDetailBO)
//                }
//                playerDetailBO.isPlayerSelected = !playerDetailBO.isPlayerSelected!
//            }
//
//        }
        scoreCalculation()
       tableView.reloadData()
    }
    
    func validation() -> Bool{
        if (self.selectedPlayerBo.teamOneCount + self.selectedPlayerBo.teamTwoCount) != 11 &&  (self.lblCreditScore.text! as NSString).floatValue < 100{
            return true
        } else{
            return false
        }
    }
    
    //MARK: - Collection view delegate and datasource -
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case matchPreViewView.collectionViewWK:
            return self.selectedPlayerBo.arrWKPlayer.count
        case matchPreViewView.collectionViewBAT:
            return self.selectedPlayerBo.arrBATPlayer.count
        case matchPreViewView.collectionViewAL:
            return self.selectedPlayerBo.arrALPlayer.count
        case matchPreViewView.collctionViewBL:
            return self.selectedPlayerBo.arrBOWPlayers.count
        default:
            return  0
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var playerDetailBO = PlayerDetailBO()
        var cell : SelectedPlayerCollectionViewCell?
        switch  collectionView{
        case matchPreViewView.collectionViewWK:
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedPlayerCollectionViewCell", for: indexPath) as! SelectedPlayerCollectionViewCell
            playerDetailBO = selectedPlayerBo.arrWKPlayer[indexPath.row]
            cell = cell1
        case matchPreViewView.collectionViewBAT:
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedPlayerCollectionViewCell", for: indexPath) as! SelectedPlayerCollectionViewCell
            playerDetailBO = selectedPlayerBo.arrBATPlayer[indexPath.row]
            cell = cell2
        case matchPreViewView.collectionViewAL:
            let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedPlayerCollectionViewCell", for: indexPath) as! SelectedPlayerCollectionViewCell
            playerDetailBO = selectedPlayerBo.arrALPlayer[indexPath.row]
            
            cell = cell3
        case matchPreViewView.collctionViewBL:
            let cell4 = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedPlayerCollectionViewCell", for: indexPath) as! SelectedPlayerCollectionViewCell
            playerDetailBO = selectedPlayerBo.arrBOWPlayers[indexPath.row]
            cell = cell4
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedPlayerCollectionViewCell", for: indexPath) as! SelectedPlayerCollectionViewCell
            return cell
        }
        
        cell?.lblPlayerName.text = " " + playerDetailBO.name!
        cell?.lblPlayerName.text?.append(" ")
        cell?.lblPlayerName.backgroundColor =  playerDetailBO.strTeamShortname == self.playerWithTeamBo.matchdetailBo.taem1_sortName ? COLOR.COLOR_NAVIGATIONBAR : UIColor.orange
        cell?.lblPlayerName.layer.cornerRadius = 5
        cell?.lblPlayerName.clipsToBounds = true
        if playerDetailBO.credit_point == 0{
            cell?.lblPlayerCreditPoint.text = "0 Cr"
        } else {
            cell?.lblPlayerCreditPoint.text = String(format: "%.2f Cr",playerDetailBO.credit_point!)
        }
        if playerDetailBO.image_url != nil && playerDetailBO.image_url != ""{
            let urlImageLogo = URL(string: playerDetailBO.image_url!)
            let urlRequestLogo = URLRequest(url: urlImageLogo!)
            self.downloader.download(urlRequestLogo) { response in
                if let image = response.result.value {
                    cell?.imgViewPlayerProfile.image = image
                    cell?.imgViewPlayerProfile.contentMode = .scaleAspectFit
                } else {
                    cell?.imgViewPlayerProfile.image = UIImage(named: "cricket-player.PNG")
                }
            }
        } else {
            cell?.imgViewPlayerProfile.image = UIImage(named: "cricket-player.PNG")
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
        case matchPreViewView.collectionViewWK:
            
            return CGSize(width: (self.view.frame.size.width ) / CGFloat(self.selectedPlayerBo.arrWKPlayer.count), height:  collectionView.frame.size.height)
        case matchPreViewView.collectionViewBAT:
            
            return CGSize(width: (self.view.frame.size.width ) / CGFloat(self.selectedPlayerBo.arrBATPlayer.count), height: collectionView.frame.size.height )
        case matchPreViewView.collectionViewAL:
            
            return CGSize(width: (self.view.frame.size.width ) / CGFloat(self.selectedPlayerBo.arrALPlayer.count), height: collectionView.frame.size.height  )
        case matchPreViewView.collctionViewBL:
            
            return CGSize(width: (self.view.frame.size.width ) / CGFloat(self.selectedPlayerBo.arrBOWPlayers.count), height: collectionView.frame.size.height )
        default:
            return CGSize(width: 0, height: collectionView.frame.size.height )
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    //MARK: - Servicecall method -
    func serviceCallForGetPlayerDetails(){
        AppConstant.sharedInstance.showActivityIndicatory(withTitle: "Loader...", andUserInteraction: false)
        let param = ["match_id" : self.strMatchId ?? "" , "team_id" : intTeamId, "user_id" : UserDefaults.standard.value(forKey: STRING_CONSTANT.KEY_USERID) ?? ""] as [String : Any]
        APIManeger.sharedInstance.serviceCallForGetdataInPost(withPath: API_PATH.kGetPlayerDeails, withData: param as NSDictionary, withCompletionHandler: { (withCompletionHandler:AnyObject?) in
            AppConstant.sharedInstance.removeActivityIndicatory()
            print("result : \(String(describing: withCompletionHandler))");
            let dictResponse = withCompletionHandler as! Dictionary<String, Any>
            let isSuccess : Int = dictResponse["stats"] as! Int
            
            if isSuccess == 1{
                print("Success")
                self.playerWithTeamBo = dictResponse["res"] as! PlayerWithTeamDetailBO
                self.tblPlayerDetailList.reloadData()
                self.selectedPlayerBo.matchdetailBo = self.playerWithTeamBo.matchdetailBo
                self.valueSetUp()
            } else {
                print("Error")
                APP_DELEGATE.appDelegate.showErrorTab(withMessage: "No Player Found", andType: NOTIFICATION_TYPE.none)
            }
        })
    }
    
    //MARK: - Segmentcontrol delegate -
    func xmSegmentedControl(_ xmSegmentedControl: XMSegmentedControl, selectedSegment: Int) {
        switch selectedSegment {
        case 0:
            self.imgViewWK.image = UIImage(named:"greenbar_new.png" )
            self.imgViewBAT.image = UIImage(named:"greybar_new.png" )
            self.imgViewBOW.image = UIImage(named:"greybar_new.png" )
            self.imgViewAR.image = UIImage(named:"greybar_new.png" )
        case 1:
            self.imgViewWK.image = UIImage(named:"greybar_new.png" )
            self.imgViewBAT.image = UIImage(named:"greenbar_new.png" )
            self.imgViewBOW.image = UIImage(named:"greybar_new.png" )
            self.imgViewAR.image = UIImage(named:"greybar_new.png" )
        case 2:
            self.imgViewWK.image = UIImage(named:"greybar_new.png" )
            self.imgViewBAT.image = UIImage(named:"greybar_new.png" )
            self.imgViewBOW.image = UIImage(named:"greenbar_new.png" )
            self.imgViewAR.image = UIImage(named:"greybar_new.png" )
        case 3:
            self.imgViewWK.image = UIImage(named:"greybar_new.png" )
            self.imgViewBAT.image = UIImage(named:"greybar_new.png" )
            self.imgViewBOW.image = UIImage(named:"greybar_new.png" )
            self.imgViewAR.image = UIImage(named:"greenbar_new.png" )
        default:
            self.imgViewWK.image = UIImage(named:"greybar_new.png" )
            self.imgViewBAT.image = UIImage(named:"greybar_new.png" )
            self.imgViewBOW.image = UIImage(named:"greybar_new.png" )
            self.imgViewAR.image = UIImage(named:"greybar_new.png" )
        }
        self.tblPlayerDetailList.reloadData()
    }

    //MARK: - Button Action -
    @IBAction func btnCreateTeamDoneClicked(_ sender: Any) {
        let chooseCaptainVC = INITIATE.INITIATE_STORY_BOARD(identifier: "ChooseCaptainViewController") as! ChooseCaptainViewController
        chooseCaptainVC.selectedPlayerBo = self.selectedPlayerBo
        chooseCaptainVC.strMatchId = strMatchId
        self.navigationController?.pushViewController(chooseCaptainVC, animated: true)
    }
    
    @IBAction func btnTeamPreviewClicked(_ sender: Any) {
        self.matchPreViewView.isHidden = false
        if selectedPlayerBo.arrBOWPlayers.count == 0 {
            self.matchPreViewView.collctionViewBL.isHidden = true
            self.matchPreViewView.lblBOW.isHidden = true
        } else  {

        }
        if selectedPlayerBo.arrALPlayer.count == 0 {
            self.matchPreViewView.collectionViewAL.isHidden = true
            self.matchPreViewView.lblAL.isHidden = true
        }
        if selectedPlayerBo.arrWKPlayer.count == 0 {
            self.matchPreViewView.collectionViewWK.isHidden = true
            self.matchPreViewView.lblWK.isHidden = true
        }
        if selectedPlayerBo.arrBATPlayer.count == 0 {
            self.matchPreViewView.collectionViewBAT.isHidden = true
            self.matchPreViewView.lblBAT.isHidden = true
        }
        self.matchPreViewView.collctionViewBL.reloadData()
        self.matchPreViewView.collectionViewAL.reloadData()
        self.matchPreViewView.collectionViewWK.reloadData()
        self.matchPreViewView.collectionViewBAT.reloadData()
        matchPreViewView.frame = CGRect(x: 0, y: self.view.frame.maxY - 110 , width: self.view.frame.size.width, height: 0)
        self.viewShowInAnimation(withViewFrameYPosition: topView.frame.maxY, withSelectedView: matchPreViewView, withEstimatedHeight: self.view.frame.size.height - 150)
//        let teamPreviewVC = INITIATE.INITIATE_STORY_BOARD(identifier: "TeamPreViewViewController") as! TeamPreViewViewController
//        teamPreviewVC.teamDetailBo = self.selectedPlayerBo
//        self.navigationController?.pushViewController(teamPreviewVC, animated: true)
//
    }
    @objc func btnCloseClicked(sender:UIButton){
        self.viewHideInAnimation(withViewFrameYPosition: self.view.frame.maxY , withSelectedView: matchPreViewView , withEstimatedHeight: 0)
    }
    
    @objc func btnBackClicked(sender: UIButton){
        if matchPreViewView.frame.origin.y < self.view.frame.size.height{
            
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - Animation part -
    func viewShowInAnimation(withViewFrameYPosition yPostion : CGFloat, withSelectedView customView: UIView, withEstimatedHeight height : CGFloat){
        UIView.transition(with: customView, duration: 0.2, options: .curveEaseIn,
                          animations: {
                            customView.frame.origin.y = yPostion
                            customView.frame.size.height = height
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
                            self.matchPreViewView.isHidden = true
                            // Compeleted
        })
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

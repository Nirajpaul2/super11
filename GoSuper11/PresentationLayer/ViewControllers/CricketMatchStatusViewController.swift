//
//  CricketMatchStatusViewController.swift
//  GoSuper11
//

import UIKit
import AlamofireImage
import XMSegmentedControl

class CricketMatchStatusViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, XMSegmentedControlDelegate, UICollectionViewDelegateFlowLayout{

    //MARK: - IBOutlets and variable -
    @IBOutlet weak var pageControllerForBanner: UIPageControl!
    @IBOutlet weak var collectionViewMatchListBanner: UICollectionView!
    @IBOutlet weak var tblViewMatchList: UITableView!
    var matchListAndDetailBo = MatchListAndDetailBO()
    let downloader                          = ImageDownloader()
    @IBOutlet weak var segmentCntrol: XMSegmentedControl!
    var format = DateFormatter()
    var countTimer : Timer!
    
    //MARK : -  View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        designAfterStoryBoard()
        setUpNavigationTitle()
        self.serviceCallForGetMatchDetails(withStatus: "1", isCompleteStatus: "1")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        countTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(counter), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        countTimer.invalidate()
    }
    
    //MARK: - Design Part -
    func designAfterStoryBoard(){
        segmentCntrol.segmentTitle = ["UPCOMING" , "LIVE" , "RRESULTS"]
        segmentCntrol.backgroundColor = UIColor.white
        segmentCntrol.highlightColor = UIColor.orange
        segmentCntrol.selectedItemHighlightStyle = .bottomEdge
        segmentCntrol.tint = UIColor.lightGray
        segmentCntrol.highlightTint = COLOR.COLOR_BUTTON_GREEN
        segmentCntrol.edgeHighlightHeight = 3
       // segmentCntrol.font = GLOBAL_CONSTANT.FONT_SEMIBOLD(size: 20)
        segmentCntrol.selectedSegment = 0
        segmentCntrol.delegate = self
        segmentCntrol.addShadow(cornerRadius: 0, opacity: 1, radius: 3, offset: (x: 0, y: 3), color: COLOR.COLOR_BUTTON_LIGHTGRAY)
        
      
    }

    func setUpNavigationTitle(){
        navigationItem.leftBarButtonItems = nil
        var leftAddBarButtonItemBack = UIBarButtonItem()
        leftAddBarButtonItemBack = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.btnBackClicked(sender:)))
        let titel = UIBarButtonItem(title: "Play Cricket Match", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        navigationItem.leftBarButtonItems = [leftAddBarButtonItemBack, titel]
        var leftAddBarButtonItemMenu = UIBarButtonItem()
        leftAddBarButtonItemMenu = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: UIBarButtonItemStyle.plain, target: self, action: nil)
        navigationItem.rightBarButtonItems = [leftAddBarButtonItemMenu]
    }
    
    //MARK: - Tableview delegates and datasource -
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.matchListAndDetailBo.arrMatchList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchListTableViewCell", for: indexPath) as! MatchListTableViewCell
        cell.lblTeamName.text = self.matchListAndDetailBo.arrMatchList[indexPath.section].taem1_sortName! + "  vs  "  + self.matchListAndDetailBo.arrMatchList[indexPath.section].taem2_sortName! + "  " + self.matchListAndDetailBo.arrMatchList[indexPath.section].match_format!
        if self.matchListAndDetailBo.arrMatchList[indexPath.section].taem1_LogoImage != nil && self.matchListAndDetailBo.arrMatchList[indexPath.section].taem1_LogoImage != ""{
            let urlImageLogo = URL(string: self.matchListAndDetailBo.arrMatchList[indexPath.section].taem1_LogoImage!)
            let urlRequestLogo = URLRequest(url: urlImageLogo!)
            self.downloader.download(urlRequestLogo) { response in
                if let image = response.result.value {
                    cell.imgViewTeamOneLogo.image = image
                    cell.imgViewTeamOneLogo.clipsToBounds = true
                    
                } else {
                }
            }
        } else {
        }
        cell.lblLogoTeamOne.text = self.matchListAndDetailBo.arrMatchList[indexPath.section].taem1_sortName
      cell.lblLogoTeamTwoName.text = self.matchListAndDetailBo.arrMatchList[indexPath.section].taem2_sortName
        if self.matchListAndDetailBo.arrMatchList[indexPath.section].taem2_LogoImage != nil && self.matchListAndDetailBo.arrMatchList[indexPath.section].taem2_LogoImage != ""{
            let urlImageLogo2 = URL(string: self.matchListAndDetailBo.arrMatchList[indexPath.section].taem2_LogoImage!)
            let urlRequestLogo2 = URLRequest(url: urlImageLogo2!)
            self.downloader.download(urlRequestLogo2) { response in
                if let image = response.result.value {
                    cell.imgViewTeamTwoLogo.image = image
                    cell.imgViewTeamTwoLogo.clipsToBounds = true
                } else {
                }
            }
        } else {
        }
     // cell.addShadow(cornerRadius: 4, opacity: 1, radius: 5, offset: (x: 0, y: 0), color: COLOR.COLOR_BUTTON_LIGHTGRAY)
        cell.lblMatchTime.text = AppConstant.sharedInstance.time(withDateString: self.matchListAndDetailBo.arrMatchList[indexPath.section].date!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let createMatchVC = INITIATE.INITIATE_STORY_BOARD(identifier: "CreateTeamViewController") as! CreateTeamViewController
//        createMatchVC.strMatchId = matchListAndDetailBo.arrMatchList[indexPath.section].matchid
//        self.navigationController?.pushViewController(createMatchVC, animated: true)
        AppConstant.sharedInstance.strSelectedMatchTeamName = self.matchListAndDetailBo.arrMatchList[indexPath.section].taem1_sortName! + "  vs  "  + self.matchListAndDetailBo.arrMatchList[indexPath.section].taem2_sortName!
        AppConstant.sharedInstance.strMatchStartingTime = self.matchListAndDetailBo.arrMatchList[indexPath.section].date
        let createMatchVC = INITIATE.INITIATE_STORY_BOARD(identifier: "JoinContestViewController") as! JoinContestViewController
        createMatchVC.strMatchId = matchListAndDetailBo.arrMatchList[indexPath.section].matchid
        self.navigationController?.pushViewController(createMatchVC, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
//        let shadowView = UIView(frame: CGRect(x: 0, y: 4, width: tableView.frame.size.width, height: 12))
//        shadowView.backgroundColor =  COLOR.APP_BACKGROUNG_GRAY
//        shadowView.addShadow(cornerRadius: 4, opacity: 1, radius: 5, offset: (x: 0, y: 0), color: COLOR.COLOR_BUTTON_LIGHTGRAY)
//        footerView.addSubview(shadowView)
//        return footerView
//    }
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 5
//    }
    
    //MARK: - Collection view delegate and datasource -
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.pageControllerForBanner.numberOfPages = self.matchListAndDetailBo.arrMatchDetaiB0.count
        self.pageControllerForBanner.isHidden = !(self.matchListAndDetailBo.arrMatchDetaiB0.count > 1)
        return self.matchListAndDetailBo.arrMatchDetaiB0.count
       
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MatchBannerCollectionViewCell", for: indexPath) as! MatchBannerCollectionViewCell
        if self.matchListAndDetailBo.arrMatchDetaiB0[indexPath.item].banner_image != nil && self.matchListAndDetailBo.arrMatchDetaiB0[indexPath.item].banner_image != ""{
            let urlImageLogo2 = URL(string: self.matchListAndDetailBo.arrMatchDetaiB0[indexPath.item].banner_image!)
            let urlRequestLogo2 = URLRequest(url: urlImageLogo2!)
            self.downloader.download(urlRequestLogo2) { response in
                if let image = response.result.value {
                    cell.imgViewBanner.image = image
                    cell.imgViewBanner.clipsToBounds = true
                    cell.imgViewBanner.isHidden = false
                } else {
                    cell.imgViewBanner.isHidden = true
                }
            }
        } else {
            cell.imgViewBanner.isHidden = true
        }
        cell.imgViewBanner.addShadow(cornerRadius: 4, opacity: 1, radius: 3, offset: (x: 0, y: 0), color: COLOR.COLOR_BUTTON_LIGHTGRAY)
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControllerForBanner?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageControllerForBanner?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
                return CGSize(width: (self.view.frame.size.width ) - 20, height: collectionView.frame.size.height )
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       
        
        return 0
    }
    
    
    //MARK: - Servicecall method -
    func serviceCallForGetMatchDetails(withStatus status : String, isCompleteStatus isComplete : String){
//       AppConstant.sharedInstance.showActivityIndicatory(withTitle: "Loader...", andUserInteraction: false)
        let param = ["banner_height" : 125 ,"banner_width" : self.view.frame.size.width - 25
            , "userid": UserDefaults.standard.value(forKey: STRING_CONSTANT.KEY_USERID)! , "status" : status, "iscomplete" : isComplete ] as [String : Any]
        
        APIManeger.sharedInstance.serviceCallForGetdataInPost(withPath: API_PATH.kGetMatchDetails, withData: param as NSDictionary, withCompletionHandler: { (withCompletionHandler:AnyObject?) in
            AppConstant.sharedInstance.removeActivityIndicatory()
            print("result : \(String(describing: withCompletionHandler))");
            let dictResponse = withCompletionHandler as! Dictionary<String, Any>
            let isSuccess : Int = dictResponse["stats"] as! Int
            
            if isSuccess == 1{
                print("Success")
                self.matchListAndDetailBo = dictResponse["res"] as! MatchListAndDetailBO
                self.tblViewMatchList.reloadData()
                self.collectionViewMatchListBanner.reloadData()
            } else {
                print("Error")
                APP_DELEGATE.appDelegate.showErrorTab(withMessage: STRING_CONSTANT.WRONG_MSG, andType: NOTIFICATION_TYPE.error)
            }
        })
    }
    
    //MARK: - Segmentcontrol delegate -
    func xmSegmentedControl(_ xmSegmentedControl: XMSegmentedControl, selectedSegment: Int) {
        
    }
    
    //MARK: - Button Action -
    @objc func btnBackClicked(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func counter(){
        self.tblViewMatchList.reloadData()
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

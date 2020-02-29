//
//  TeamPreViewViewController.swift
//  GoSuper11

import UIKit
import AlamofireImage


class TeamPreViewViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //MARK: - IBOutlets and Variables -
    @IBOutlet weak var collctionViewBL: UICollectionView!
    @IBOutlet weak var collectionViewAL: UICollectionView!
    @IBOutlet weak var collectionViewBAT: UICollectionView!
    @IBOutlet weak var collectionViewWK: UICollectionView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblTeamOneTotalCount: UILabel!
    @IBOutlet weak var lblTeamOneName: UILabel!
    @IBOutlet weak var colorViewTeamOne: UIView!
    @IBOutlet weak var colorViewTeamTwo: UIView!
    @IBOutlet weak var lblTeamTwoTotalCount: UILabel!
    @IBOutlet weak var lblTeamTwoName: UILabel!
    @IBOutlet weak var lblTotalPlayerCount: UILabel!
    @IBOutlet weak var lblTotalCredittedPoint: UILabel!
    let downloader                          = ImageDownloader()

    
    var teamDetailBo = PlayerWithTeamDetailBO()
    
    //MARK: - View LifeCycle -
    override func viewDidLoad() {
        super.viewDidLoad()
       setUpData()
       
        // Do any additional setup after loading the view.
    }
    
    //MARK : - Design part -
    func setUpData(){
        self.lblTeamOneName.text = teamDetailBo.matchdetailBo.taem1_sortName
        self.lblTeamTwoName.text = teamDetailBo.matchdetailBo.taem2_sortName
        self.lblTeamOneTotalCount.text = String(0)
        self.lblTeamTwoTotalCount.text = String(0)
        self.lblTotalPlayerCount.text = String(0)
        self.lblTotalPlayerCount.text = String(0)
        self.lblTotalCredittedPoint.text = String(format: "%.2f",teamDetailBo.totalLeftPoint! )
    }

    //MARK: - Collection view delegate and datasource -
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case collectionViewWK:
            return self.teamDetailBo.arrWKPlayer.count
        case collectionViewBAT:
            return self.teamDetailBo.arrBATPlayer.count
        case collectionViewAL:
            return self.teamDetailBo.arrALPlayer.count
        case collctionViewBL:
           return self.teamDetailBo.arrBOWPlayers.count
        default:
            return  0
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var playerDetailBO = PlayerDetailBO()
        var cell : PlayerDetailCollectionViewCell?
        switch  collectionView{
        case collectionViewWK:
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerDetailCollectionViewCell", for: indexPath) as! PlayerDetailCollectionViewCell
            playerDetailBO = teamDetailBo.arrWKPlayer[indexPath.row]
             cell = cell1
        case collectionViewBAT:
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerDetailCollectionViewCell2", for: indexPath) as! PlayerDetailCollectionViewCell
            playerDetailBO = teamDetailBo.arrBATPlayer[indexPath.row]
            cell = cell2
        case collectionViewAL:
            let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerDetailCollectionViewCell3", for: indexPath) as! PlayerDetailCollectionViewCell
            playerDetailBO = teamDetailBo.arrALPlayer[indexPath.row]

            cell = cell3
        case collctionViewBL:
            let cell4 = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerDetailCollectionViewCell4", for: indexPath) as! PlayerDetailCollectionViewCell
            playerDetailBO = teamDetailBo.arrBOWPlayers[indexPath.row]
            cell = cell4
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerDetailCollectionViewCell", for: indexPath) as! PlayerDetailCollectionViewCell
            return cell
        }
        
         cell?.lblPlayerName.text = playerDetailBO.name
        if playerDetailBO.credit_point == 0{
            cell?.lblPlayerCreditPoint.text = "0"
        } else {
            cell?.lblPlayerCreditPoint.text = String(format: "%.2f",playerDetailBO.credit_point!)
        }
        if playerDetailBO.image_url != nil && playerDetailBO.image_url != ""{
            let urlImageLogo = URL(string: playerDetailBO.image_url!)
            let urlRequestLogo = URLRequest(url: urlImageLogo!)
            self.downloader.download(urlRequestLogo) { response in
                if let image = response.result.value {
                    cell?.imgViewPlayerProfile.image = image
                    cell?.imgViewPlayerProfile.contentMode = .scaleAspectFit
                } else {
                }
            }
        } else {
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
        case collectionViewWK:

            return CGSize(width: (self.view.frame.size.width ) / CGFloat(self.teamDetailBo.arrWKPlayer.count), height: collectionView.frame.size.height )
        case collectionViewBAT:

            return CGSize(width: (self.view.frame.size.width ) / CGFloat(self.teamDetailBo.arrBATPlayer.count), height: collectionView.frame.size.height )
        case collectionViewAL:

            return CGSize(width: (self.view.frame.size.width ) / CGFloat(self.teamDetailBo.arrALPlayer.count), height: collectionView.frame.size.height )
        case collctionViewBL:

            return CGSize(width: (self.view.frame.size.width ) / CGFloat(self.teamDetailBo.arrBOWPlayers.count), height: collectionView.frame.size.height )
        default:
            return CGSize(width: 0, height: collectionView.frame.size.height )
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //MARK: - Button Action -
    @IBAction func btnNextClicked(_ sender: Any) {
        let chooseCaptenVC = INITIATE.INITIATE_STORY_BOARD(identifier: "ChooseCaptainViewController") as! ChooseCaptainViewController
        self.navigationController?.pushViewController(chooseCaptenVC, animated: true)
    }
    
    //MARK:  -  -
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

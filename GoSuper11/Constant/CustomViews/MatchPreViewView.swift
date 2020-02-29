//
//  MatchPreViewView.swift
//  GoSuper11
//
//  Created by Krishna on 05/09/18.
//  Copyright © 2018 Krishna. All rights reserved.
//

import UIKit

class MatchPreViewView: UIView {
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblBOW: UILabel!
    @IBOutlet weak var lblAL: UILabel!
    @IBOutlet weak var lblBAT: UILabel!
    @IBOutlet weak var lblWK: UILabel!
    @IBOutlet weak var collctionViewBL: UICollectionView!
    @IBOutlet weak var collectionViewAL: UICollectionView!
    @IBOutlet weak var collectionViewBAT: UICollectionView!
    @IBOutlet weak var collectionViewWK: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadView()
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "MatchPreViewView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    func loadView() -> Void {
       
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

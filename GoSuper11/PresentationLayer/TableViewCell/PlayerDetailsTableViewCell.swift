//
//  PlayerDetailsTableViewCell.swift
//  GoSuper11

import UIKit

class PlayerDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var imgViewPlayerProfile: UIImageView!
    @IBOutlet weak var imgViewSelected: UIImageView!
    @IBOutlet weak var lblCredittedScore: UILabel!
    @IBOutlet weak var lblPlayerPoint: UILabel!
    @IBOutlet weak var lblPlayerCity: UILabel!
    @IBOutlet weak var lblPlayername: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
//        imgViewPlayerProfile.layer.borderColor = UIColor.lightGray.cgColor
//        imgViewPlayerProfile.layer.borderWidth = 1.0
        
//        outerView.clipsToBounds = false
//        outerView.layer.shadowColor = UIColor.black.cgColor
//        outerView.layer.shadowOpacity = 1
//        outerView.layer.shadowOffset = CGSize.zero
//        outerView.layer.shadowRadius = 10
//        outerView.layer.shadowPath = UIBezierPath(roundedRect: outerView.bounds, cornerRadius: outerView.frame.size.width / 2).cgPath
        outerView.addShadow(cornerRadius: outerView.frame.size.width / 2, opacity: 1, radius: 3, offset: (x: 0, y: 0), color: UIColor.black)

        
        imgViewPlayerProfile.layer.cornerRadius = self.imgViewPlayerProfile.frame.size.width / 2
        imgViewPlayerProfile.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  MatchListTableViewCell.swift
//  GoSuper11


import UIKit

class MatchListTableViewCell: UITableViewCell {

    @IBOutlet weak var lblLogoTeamTwoName: UILabel!
    @IBOutlet weak var lblLogoTeamOne: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var lblMatchTime: UILabel!
    @IBOutlet weak var imgViewTeamTwoLogo: UIImageView!
    @IBOutlet weak var imgViewTeamOneLogo: UIImageView!
    @IBOutlet weak var lblTeamName: UILabel!
    
    @IBInspectable var cornerRadius: CGFloat = 2
    
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.5
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shadowView.addShadow(cornerRadius: 4, opacity: 0.5, radius: 3, offset: (x: 0, y: 0), color: UIColor.lightGray)
//        shadowView.layer.cornerRadius = cornerRadius
//        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
//
//        shadowView.layer.masksToBounds = false
//        shadowView.layer.shadowColor = shadowColor?.cgColor
//        shadowView.layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
//        shadowView.layer.shadowOpacity = shadowOpacity
//        shadowView.layer.shadowPath = shadowPath.cgPath
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

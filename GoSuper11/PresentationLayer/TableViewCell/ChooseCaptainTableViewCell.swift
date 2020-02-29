//
//  ChooseCaptainTableViewCell.swift
//  GoSuper11


import UIKit

class ChooseCaptainTableViewCell: UITableViewCell {

    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var lblPoints: UILabel!
    @IBOutlet weak var lblPlayerTeam: UILabel!
    @IBOutlet weak var lblPlayerName: UILabel!
    @IBOutlet weak var imgViewPoint: UIImageView!
    @IBOutlet weak var btnC: UIButton!
    @IBOutlet weak var btnVC: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        btnC.layer.cornerRadius = btnC.frame.size.width / 2
        btnC.layer.borderColor = UIColor.lightGray.cgColor
        btnC.layer.borderWidth = 1.5
        btnC.clipsToBounds = true
        
        btnVC.layer.cornerRadius = btnC.frame.size.width / 2
        btnVC.layer.borderColor = UIColor.lightGray.cgColor
        btnVC.layer.borderWidth = 1.5
        btnVC.clipsToBounds = true
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

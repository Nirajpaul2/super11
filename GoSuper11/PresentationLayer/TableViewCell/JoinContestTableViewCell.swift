//
//  JoinContestTableViewCell.swift
//  GoSuper11
//
//  Created by Krishna on 08/09/18.
//  Copyright © 2018 Krishna. All rights reserved.
//

import UIKit

class JoinContestTableViewCell: UITableViewCell {

    @IBOutlet weak var lblContestStatus: UILabel!
    @IBOutlet weak var widthConstantofViewlimit: NSLayoutConstraint!
    @IBOutlet weak var ViewLimit: UIView!
    @IBOutlet weak var lblNumberofTeams: UILabel!
    @IBOutlet weak var lblEntryFee: UILabel!
    @IBOutlet weak var lblTotalWinnersPrice: UILabel!
    @IBOutlet weak var lblTotalWinersCount: UILabel!
    @IBOutlet weak var btnJoin: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        btnJoin.layer.cornerRadius = 4.0
        btnJoin.layer.borderColor = COLOR.COLOR_NAVIGATIONBAR.cgColor
        btnJoin.setTitleColor(COLOR.COLOR_NAVIGATIONBAR, for: .normal)
        btnJoin.layer.borderWidth = 1.0
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

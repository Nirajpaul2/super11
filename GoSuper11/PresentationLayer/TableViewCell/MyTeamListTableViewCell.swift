//
//  MyTeamListTableViewCell.swift
//  GoSuper11
//
//  Created by Krishna on 14/09/18.
//  Copyright © 2018 Krishna. All rights reserved.
//

import UIKit

class MyTeamListTableViewCell: UITableViewCell {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var lblTeamName: UILabel!
    @IBOutlet weak var lblCaptainName: UILabel!
    @IBOutlet weak var lblViceCaptainName: UILabel!
    @IBOutlet weak var lblWKCount: UILabel!
    @IBOutlet weak var lblBATCount: UILabel!
    @IBOutlet weak var lblAllCount: UILabel!
    @IBOutlet weak var lblBOWCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shadowView.addShadow(cornerRadius: 4, opacity: 0.5, radius: 3, offset: (x: 0, y: 0), color: UIColor.lightGray)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

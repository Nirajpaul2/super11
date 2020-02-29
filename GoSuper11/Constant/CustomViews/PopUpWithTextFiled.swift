

import UIKit
import SkyFloatingLabelTextField

class PopUpWithTextFiled: UIView {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgViewLogo: UIImageView!
    @IBOutlet weak var txtFldEnterValue: SkyFloatingLabelTextField!
    @IBOutlet weak var btnSubmit: UIButton!
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
        return UINib(nibName: "PopUpWithTextFiled", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    func loadView() -> Void {
        btnSubmit.addShadow(cornerRadius: 6, opacity: 1, radius: 5, offset: (x: 0, y: 0), color: .lightGray)
        btnSubmit.backgroundColor = COLOR.COLOR_NAVIGATIONBAR
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

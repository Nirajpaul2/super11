

import UIKit

class AnnoyingNotification: UIView {
    @IBOutlet var imgType: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblMessage: UILabel!
    var strMessage : String!
    var notifyType : String!
    
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
        return UINib(nibName: "AnnoyingNotification", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
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


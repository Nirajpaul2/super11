

import Foundation
import AVFoundation
import UIKit
import CoreLocation
import TKSubmitTransition
import NVActivityIndicatorView
import Alamofire
import SwiftyGif

class AppConstant: UIView, UIAlertViewDelegate, CLLocationManagerDelegate {
    var loadingView : UIView!
    var lblTitle : UILabel!
    var actInd : UIActivityIndicatorView!
    var noInternetConnectionView : UIView!
    var locationManager = CLLocationManager()
    var backView : UIView!
    var strSelectedMatchTeamName : String?
    var strMatchStartingTime : String?
    var format = DateFormatter()

    // MARK: - Singleton -
    class var sharedInstance:AppConstant {
        
        struct Static{
            static let _instance = AppConstant()
        }
        return Static._instance
    }
    
    //MARK: - Set number formatter -
   
    
    // MARK: - ActivityIndicatorView Show Hide -
    func showActivityIndicatory(withTitle title: String, andUserInteraction interaction: Bool) -> Void {
        backView = UIView()
        backView.frame = CGRect(x: 0, y: 0, width: (APP_DELEGATE.appDelegate.window?.frame.width)!, height: (APP_DELEGATE.appDelegate.window?.frame.height)!)
        backView.center = (APP_DELEGATE.appDelegate.window?.center)!
        backView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        let gif = UIImage(gifName: "loaderRes.gif")
        let imageview = UIImageView(gifImage: gif, loopCount: -1) // Use -1 for infinite loop
        if UIDevice.current.userInterfaceIdiom == .phone {
          imageview.frame = CGRect(x: (backView.frame.size.width / 2) - 50, y: (backView.frame.size.height / 2) - 50, width: 100, height: 100)
        } else{
          imageview.frame = CGRect(x: (backView.frame.size.width / 2) - 100, y: (backView.frame.size.height / 2) - 100, width: 200, height: 200)
        }

        backView.addSubview(imageview)
        APP_DELEGATE.appDelegate.window?.addSubview(backView)
    }
    func removeActivityIndicatory() -> Void {
        if backView != nil {
           backView.removeFromSuperview()
        }
       // NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }

    func UIColorFromHex(_ rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        print(red,green , blue)
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    func addButtonLoader(withButton btn: TKTransitionSubmitButton){
        btn.startLoadingAnimation()
    }
    
    //MARK: - No internet connection view -
    func nointenetConnectionView() {
        APP_DELEGATE.appDelegate.window?.isUserInteractionEnabled = true
        if noInternetConnectionView != nil {
            self.noInternetConnectionView.removeFromSuperview()
        }
        noInternetConnectionView = UIView()
        noInternetConnectionView.frame = CGRect(x: 0, y: 0, width: (APP_DELEGATE.appDelegate.window?.frame.width)!, height: (APP_DELEGATE.appDelegate.window?.frame.height)!)
        noInternetConnectionView.center = (APP_DELEGATE.appDelegate.window?.center)!
        noInternetConnectionView.backgroundColor = COLOR.COLOR_TABLEVIEW_BACKGROUND
        
        let imgviewNoInternet = UIImageView()
        imgviewNoInternet.frame = CGRect(x: (APP_DELEGATE.appDelegate.window?.frame.midX)! - 100, y: (APP_DELEGATE.appDelegate.window?.frame.midY)! - 200, width: 200, height: 200)
        //imgviewNoInternet.image = #imageLiteral(resourceName: "noInternet")
        
        let lblNoInternetTitle = UILabel(frame: CGRect(x: 0, y: imgviewNoInternet.frame.maxY + 20, width: noInternetConnectionView.frame.size.width, height: 20))
        lblNoInternetTitle.textColor = UIColor.darkGray
        lblNoInternetTitle.font = GLOBAL_CONSTANT.FONT_BOLD(size: 20)
        lblNoInternetTitle.text = "No Connection"
        lblNoInternetTitle.textAlignment = NSTextAlignment.center
        
        let lblNointernetDesc = UILabel(frame: CGRect(x: 20, y: lblNoInternetTitle.frame.maxY + 5, width: noInternetConnectionView.frame.size.width - 40, height: 50))
        lblNointernetDesc.textColor = UIColor.darkGray
        lblNointernetDesc.font = GLOBAL_CONSTANT.FONT_SEMIBOLD(size: 18)
        lblNointernetDesc.text = "Please check your internet connectivity and try again."
        lblNointernetDesc.numberOfLines = 0
        lblNointernetDesc.lineBreakMode = .byWordWrapping
        lblNointernetDesc.textAlignment = NSTextAlignment.center
        
        let btnTry = UIButton(frame: CGRect(x: (APP_DELEGATE.appDelegate.window?.frame.midX)! - 75, y: lblNointernetDesc.frame.maxY + 5, width: 150, height: 40))
        btnTry.setTitle("TRY AGAIN", for: .normal)
        btnTry.setTitleColor(UIColor.white, for: .normal)
        btnTry.addTarget(self, action: #selector(btntryClicked(sender:)), for: .touchUpInside)
        btnTry.backgroundColor = COLOR.COLOR_THEME_BLUE
        btnTry.layer.cornerRadius = 5.0
        btnTry.clipsToBounds = true
        
        noInternetConnectionView.addSubview(imgviewNoInternet)
        noInternetConnectionView.addSubview(lblNoInternetTitle)
        noInternetConnectionView.addSubview(lblNointernetDesc)
        noInternetConnectionView.addSubview(btnTry)
        APP_DELEGATE.appDelegate.window?.addSubview(noInternetConnectionView)
    }
    
    func removeNointernetView() -> Void {
        if noInternetConnectionView != nil {
            noInternetConnectionView.removeFromSuperview()
        }
    }
    
    @objc func btntryClicked(sender : Any){
//        if NetworkReachabilityManager()!.isReachable {
//            removeNointernetView()
//        } else {
//            APP_DELEGATE.appDelegate.showErrorTab(withMessage: "No internet", andType: NOTIFICATION_TYPE.error)
//        }

    }
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func time(withDateString strDate:String) -> String{
        // let timecreated = format(date: strDate, fromFormatter: "yyyy-MM-dd'T'HH:mm:ss.SZ", toFormatter: "HH:mm:ss")
        
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDate = format.string(from: Date())
        let dateCreated = format.date(from: strDate)
        let current = format.date(from: currentDate)
        let timeInterval = current?.timeIntervalSince(dateCreated!)
        let hours = Int(timeInterval! / 3600)
        let minutes = Int((timeInterval! - Double(hours) * 3600) / 60)
        let seconds = Int(timeInterval! - Double(hours) * 3600 - Double(minutes) * 60 + 0.5)
        var finalTime : String = ""
        if hours == 0 {
            finalTime = String(format: "%02d:%02d", minutes, seconds)
        } else {
            finalTime =  String(format: "%02dh %02dm %02ds", hours, minutes, seconds)
        }
        return finalTime
    }
}
extension UIView {
    
    func addShadow(cornerRadius: CGFloat, opacity: Float, radius: CGFloat, offset: (x: CGFloat, y: CGFloat), color: UIColor){
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: offset.x, height: offset.y)
        self.layer.shadowRadius = radius
    }
    
    /**
     Simply zooming in of a view: set view scale to 0 and zoom to Identity on 'duration' time interval.
     
     - parameter duration: animation duration
     */
    func zoomIn(duration: TimeInterval = 0.3) {
        self.transform = CGAffineTransform(scaleX: 0, y: 0)
        //self.transform = CGAffineTransform(scaleX: 2, y: 2)
        UIView.animate(withDuration: duration, delay: 0.2, options: [.transitionFlipFromLeft], animations: { () -> Void in
            self.transform = CGAffineTransform.identity
        }) { (animationCompleted: Bool) -> Void in
        }
    }
    
    /**
     Simply zooming out of a view: set view scale to Identity and zoom out to 0 on 'duration' time interval.
     
     - parameter duration: animation duration
     */
    func zoomOut(duration: TimeInterval = 0.3) {
        self.transform = CGAffineTransform.identity
        UIView.animate(withDuration: duration, delay: 0.2, options: [.transitionFlipFromLeft], animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        }) { (animationCompleted: Bool) -> Void in
        }
    }
    
    /**
     Zoom in any view with specified offset magnification.
     
     - parameter duration:     animation duration.
     - parameter easingOffset: easing offset.
     */
    func zoomInWithEasing(duration: TimeInterval = 1.5, easingOffset: CGFloat = 0.5) {
        let easeScale = 1.0 + easingOffset
        let easingDuration = TimeInterval(easingOffset) * duration / TimeInterval(easeScale)
        let scalingDuration = duration - easingDuration
        UIView.animate(withDuration: scalingDuration, delay: 0.0, options: .curveEaseIn, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: easeScale, y: easeScale)
        }, completion: { (completed: Bool) -> Void in
            UIView.animate(withDuration: easingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                self.transform = CGAffineTransform.identity
            }, completion: { (completed: Bool) -> Void in
            })
        })
    }
    
    /**
     Zoom out any view with specified offset magnification.
     
     - parameter duration:     animation duration.
     - parameter easingOffset: easing offset.
     */
    func zoomOutWithEasing(duration: TimeInterval = 0.2, easingOffset: CGFloat = 0.2) {
        let easeScale = 1.0 + easingOffset
        let easingDuration = TimeInterval(easingOffset) * duration / TimeInterval(easeScale)
        let scalingDuration = duration - easingDuration
        UIView.animate(withDuration: easingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: easeScale, y: easeScale)
        }, completion: { (completed: Bool) -> Void in
            UIView.animate(withDuration: scalingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            }, completion: { (completed: Bool) -> Void in
            })
        })
    }
    
  
    func addGradientBackground(firstColor: UIColor, secondColor: UIColor){
        clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.frame = self.bounds
//        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
//        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        //print(gradientLayer.frame)
        self.layer.addSublayer(gradientLayer)
        //self.layer.insertSublayer(gradientLayer, at: 1)
    }
    func addGradientBackgroundFromTop(firstColor: UIColor, secondColor: UIColor, thirdColor:UIColor){
        clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor, thirdColor.cgColor]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.layer.addSublayer(gradientLayer)
    }
}
extension UIButton {
    
    func pulsate() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.2
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: "pulse")
    }
    
    func flash() {
        
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.2
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 1
        
        layer.add(flash, forKey: nil)
    }
    
    
    func shake() {
        
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.05
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: "position")
    }
}

extension UIImage {
    
    func imageWithColor(color: UIColor) -> UIImage? {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}



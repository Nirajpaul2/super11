//
//  AppDelegate.swift
//  GoSuper11
//

import UIKit
import CoreData
import SwiftOverlays
import NVActivityIndicatorView
import FAPanels
import Fabric
import Crashlytics
import FBSDKCoreKit
import GoogleSignIn
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var annoyingNotificationView : AnnoyingNotification!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        UIApplication.shared.statusBarView?.backgroundColor = COLOR.COLOR_NAVIGATIONBAR
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        UINavigationBar.appearance().barTintColor = COLOR.COLOR_NAVIGATIONBAR
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        //Fabric.with([Crashlytics.self])
        
        self.annoyingNotificationView = AnnoyingNotification.instanceFromNib() as! AnnoyingNotification
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            let attrs = [
//                NSAttributedStringKey.foregroundColor: UIColor.white,
//                NSAttributedStringKey.font: UIFont(name: "Lato-Bold", size: 20)!
//            ]
//
//            UINavigationBar.appearance().titleTextAttributes = attrs
//        } else {
//            let attrs = [
//                NSAttributedStringKey.foregroundColor: UIColor.white,
//                NSAttributedStringKey.font: UIFont(name: "Lato-Bold", size: 24)!
//            ]
//
//            UINavigationBar.appearance().titleTextAttributes = attrs
//        }
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance().clientID = "235085579831-u8go5seiro7m8ik9kvuh08umsqu2u3nj.apps.googleusercontent.com"
       // GIDSignIn.sharedInstance().delegate = self

        if UserDefaults.standard.value(forKey: STRING_CONSTANT.KEY_ALREADY_LOGIN) != nil  && UserDefaults.standard.value(forKey: STRING_CONSTANT.KEY_ALREADY_LOGIN) as! Bool == true {
            let rootViewController = self.window!.rootViewController as! UINavigationController
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let matchVC = mainStoryboard.instantiateViewController(withIdentifier: "CricketMatchStatusViewController") as! CricketMatchStatusViewController
            rootViewController.pushViewController(matchVC, animated: true)
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()

    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    //MARK: - FB delegate -
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        // Add any custom logic here.
        return handled
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "GoSuper11")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    //MARK: - Message alert -
    func showErrorTab(withMessage strMessage: String, andType notifType: String) -> Void {
        annoyingNotificationView.frame.size.width = GLOBAL_CONSTANT.SCREEN_SIZE.width
        annoyingNotificationView.strMessage = strMessage
        annoyingNotificationView.notifyType = notifType
        // annoyingNotificationView.lblMessage.font = GLOBAL_CONSTANT.FONT_SEMIBOLD(size: 14)
        //  annoyingNotificationView.lblTitle.font = GLOBAL_CONSTANT.FONT_SEMIBOLD(size: 14)
        
        
        switch notifType {
        case NOTIFICATION_TYPE.error:
            annoyingNotificationView.lblTitle.text = NOTIFICATION_TYPE.error
            annoyingNotificationView.lblTitle.textColor = UIColor.white
            annoyingNotificationView.lblMessage.textColor = UIColor.white
            annoyingNotificationView.lblMessage.text = strMessage
            annoyingNotificationView.backgroundColor = UIColor.red
        case NOTIFICATION_TYPE.success:
            annoyingNotificationView.lblTitle.text = NOTIFICATION_TYPE.success
            annoyingNotificationView.lblTitle.textColor = COLOR.COLOR_BUTTON_GREEN
            annoyingNotificationView.lblMessage.text = strMessage
            annoyingNotificationView.lblMessage.textColor = COLOR.COLOR_BUTTON_GREEN
            annoyingNotificationView.backgroundColor = UIColor.white
        case NOTIFICATION_TYPE.warning:
            annoyingNotificationView.lblTitle.text = NOTIFICATION_TYPE.warning
            annoyingNotificationView.lblMessage.text = strMessage
            annoyingNotificationView.lblTitle.textColor = UIColor.white
            annoyingNotificationView.lblMessage.textColor = UIColor.white
            annoyingNotificationView.backgroundColor = COLOR.COLOR_BUTTON_GREEN
        case NOTIFICATION_TYPE.none:
            annoyingNotificationView.lblTitle.text = ""
            annoyingNotificationView.lblMessage.text = strMessage
            annoyingNotificationView.lblMessage.textColor = UIColor.white
            annoyingNotificationView.backgroundColor = COLOR.COLOR_BUTTON_GREEN
        default:
            break
        }
        
        
        UIViewController.showOnTopOfStatusBar(annoyingNotificationView!, duration: 2)
        //SwiftOverlays.showAnnoyingNotificationOnTopOfStatusBar(annoyingNotificationView, duration: 2)
    }
    
}
extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}
extension UINavigationBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        
        let newSize: CGSize = CGSize(width: self.frame.size.width, height: 80)
        return newSize
    }
}



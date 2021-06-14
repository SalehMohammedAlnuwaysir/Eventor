//
//  AppDelegate.swift
//  Eventor
//
//  Created by Saleh on 19/05/1440 AH.
//  Copyright © 1440 Eventor. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var FirebaseStorage: Storage?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        FirebaseStorage = Storage.storage()
        let scoresRef = Database.database().reference(withPath: "scores")
        scoresRef.keepSynced(true)
        
        //redOranege color for BGStatus , Navegation bar , Tap bar
        let HexColorStatNavAndTap:String = "#ff3600"
        
        //changing the tapBar color
        UITabBar.appearance().tintColor = hexStringToUIColor(HexColorStatNavAndTap)
      
        // #status bar
            //-first get the status from the extention downbelow
            //#fe5427 to avoied the lightnec of the nav bar
        UIApplication.shared.statusBarView?.backgroundColor = hexStringToUIColor(HexColorStatNavAndTap)
        UIApplication.shared.statusBarStyle = .lightContent //to make the tint white
        
        // #the navigation Color
        var navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.white
        navigationBarAppearace.barTintColor = hexStringToUIColor(HexColorStatNavAndTap)
            // removing the white bar behined the navBar
        navigationBarAppearace.barTintColor?.withAlphaComponent(0)
            //changing the nav-title color to white
        navigationBarAppearace.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

  
}


//status bar
extension UIApplication {
    
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
    
}

//
//  AppDelegate.swift
//  NhaTro
//
//  Created by HOANGHUNG on 8/21/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit
import IQKeyboardManager
import FBSDKCoreKit
import Firebase
import GoogleSignIn
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.black], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.white], for: .normal)
//        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        IQKeyboardManager.shared().isEnabled = true
        //Config Facebook SDK
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //Config Google Map
        GMSPlacesClient.provideAPIKey("AIzaSyDoEM53gYja9D3Gjou5nMsWe1MiDbkBHww")
        GMSServices.provideAPIKey("AIzaSyDoEM53gYja9D3Gjou5nMsWe1MiDbkBHww")
    
        checkUserData()
        
        // Override point for customization after application launch.
        return true
    }
    
    
    private func checkUserData() {
        //Check user data để chuyển màn hình
        if let userData = parseUserData() {
            window?.makeKeyAndVisible()
            if userData.email != "" {
                let homeVC = TabBarViewController()
                window?.rootViewController = homeVC
            } else {
                let loginVC = Storyboard.main.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                window?.rootViewController = loginVC
            }
        }
    }
    
    private func parseUserData() -> User? {
        let userData = User.shared
        userData?.parseUserData(dataHandle.getUserData())
        return userData
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication =  options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        let annotation = options[UIApplicationOpenURLOptionsKey.annotation]
        
        let googleHandler = GIDSignIn.sharedInstance().handle(
            url,
            sourceApplication: sourceApplication,
            annotation: annotation )
        
        let facebookHandler = FBSDKApplicationDelegate.sharedInstance().application (
            app,
            open: url,
            sourceApplication: sourceApplication,
            annotation: annotation )
        
        return googleHandler || facebookHandler
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
    }


}




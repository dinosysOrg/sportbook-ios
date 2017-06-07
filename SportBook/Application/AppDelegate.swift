//
//  AppDelegate.swift
//  SportBook
//
//  Created by DucBM on 5/17/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit
import FacebookCore
import Fabric
import Crashlytics
import RxSwift
import RxReachability
import ReachabilitySwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var reachability: Reachability?
    
    let disposeBag = DisposeBag()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        reachability = Reachability()
        try? reachability?.startNotifier()
        
        // Override point for customization after application launch.
        Fabric.with([Answers.self, Crashlytics.self])
        
        //Apply Sportbook Theme
        ThemeManager.applyTheme()
        
        //If authenticated, launch main view
        if AuthManager.sharedInstance.IsAuthenticated {
            let mainViewController = UIStoryboard.loadMainViewController()
            
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = mainViewController
            self.window?.makeKeyAndVisible()
        }
        //Else launch default login view
        
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        Reachability.rx.isConnected
            .subscribe(onNext: {
                print("Is connected")
                 //Handle if network connected
            })
            .addDisposableTo(disposeBag)
        
        Reachability.rx.isDisconnected
            .subscribe(onNext: {
                print("Is disconnected")
                //Handle if network disconnected
            })
            .addDisposableTo(disposeBag)
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return SDKApplicationDelegate.shared.application(application,
                                                         open: url,
                                                         sourceApplication: sourceApplication,
                                                         annotation: annotation)
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        return SDKApplicationDelegate.shared.application(application, open: url, options: options)
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
        AppEventsLogger.activate(application)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        try? reachability?.stopNotifier()
    }


}


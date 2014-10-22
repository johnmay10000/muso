//
//  AppDelegate.swift
//  muso
//
//  Created by John May on 3/10/2014.
//  Copyright (c) 2014 John May. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
//        let splitViewController = self.window!.rootViewController as UISplitViewController
//        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as UINavigationController
//        navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
//        splitViewController.delegate = self
        StartUp().checkOAuth(window, splitViewControllerDelegate: self)
//        StartUp().showDetailsViews(window, splitViewControllerDelegate: self)
//        let d = ["api_key_def":"BD2FKJK9U8FCMFFT3","api_key_name":"api_key"]
//        Resources().addResource("EchoNest", name:"EchoNest", api_key_def: "BD2FKJK9U8FCMFFT3", api_key_name:"api_key", queryTerm: "name", parserResultTerms:["response","artists"], url: "http://developer.echonest.com/api/v4/artist/search")
//        
//        Resources().addResource("Discogs Search", name:"Discogs Search", queryTerm: "q", resultTerm:"results", url: "http://api.discogs.com/database/search")
        
//        println(Resources().all)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Split view

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController!, ontoPrimaryViewController primaryViewController:UIViewController!) -> Bool {
        if let secondaryAsNavController = secondaryViewController as? UINavigationController {
            if let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController {
                if topAsDetailController.detailItem == nil {
                    // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
                    return true
                }
            }
        }
        return false
    }
    
    
    func application(application: UIApplication!, openURL url: NSURL!, sourceApplication: String!, annotation: AnyObject!) -> Bool {
        println(url)
        if (url.host == "oauth-callback") {
            if (url.path!.hasPrefix("/discogs")) {
                OAuth1Swift.handleOpenURL(url)
            }
//            if ( url.path!.hasPrefix("/github" ) || url.path!.hasPrefix("/instagram" ) || url.path!.hasPrefix("/foursquare")) {
//                OAuth2Swift.handleOpenURL(url)
//            }
        }
        return true
    }
    

}


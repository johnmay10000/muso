//
//  StartUp.swift
//  muso
//
//  Created by John May on 19/10/2014.
//  Copyright (c) 2014 John May. All rights reserved.
//

import Foundation
import UIKit
import Realm

class StartUp {
    
    func checkOAuth(window: UIWindow?, splitViewControllerDelegate:UISplitViewControllerDelegate) {
        let creds:RLMResults = OAuthCredentials().all
        
        if creds.count > 0 {
            showDetailsViews(window, splitViewControllerDelegate: splitViewControllerDelegate)
        } else {
          performOAuth(window, splitViewControllerDelegate: splitViewControllerDelegate)
        }
        
    }
    
    
    func showDetailsViews(window: UIWindow?, splitViewControllerDelegate:UISplitViewControllerDelegate) {
        let splitViewController = window!.rootViewController as UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as UINavigationController
        navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        splitViewController.delegate = splitViewControllerDelegate
        
        addResource()
        
    }
    
    func addResource() {
         Resources().addResource("Discogs Search", name:"Discogs Search", queryTerm: "q", resultTerm:"results", url: "http://api.discogs.com/database/search")
    }
    
    func performOAuth(window: UIWindow?, splitViewControllerDelegate:UISplitViewControllerDelegate) {
    
    // OAuth1.0
    let oauthswift = OAuth1Swift(
        consumerKey:    "oTwRJVjNCsbRoQyFGsDS",
        consumerSecret: "hPJQPoeoQqmyVYMRwGAYvsnyHMQXqXkb",
        requestTokenUrl: "http://api.discogs.com/oauth/request_token",
        authorizeUrl:    "http://www.discogs.com/oauth/authorize",
        accessTokenUrl:  "http://api.discogs.com/oauth/access_token"
    )
    
    oauthswift.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/discogs")!, success: {
            credential, response in
            println(credential.oauth_token)
            println(credential.oauth_token_secret)
            self.addCredentials(credential.oauth_token, secret: credential.oauth_token_secret)
        
            self.showDetailsViews(window, splitViewControllerDelegate: splitViewControllerDelegate)
        }, failure: {(error:NSError!) -> Void in
            println(error.localizedDescription)
    })
    }
    
    func addCredentials(token:String, secret:String) {
        OAuthCredentials().addOAuthCredential("Discogs OAuth Credentials", token:token, secret:secret)
    }
}
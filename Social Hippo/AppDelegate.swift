//
//  AppDelegate.swift
//  Social Hippo
//
//  Created by James Gillin on 2/15/16.
//  Copyright © 2016 James Gillin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
  
  var window: UIWindow?
  
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    let splitViewController = self.window!.rootViewController as! UISplitViewController
    let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
    navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
    splitViewController.delegate = self
    
    loadKeys()
    
    return true
  }
  
  func loadKeys() {
    var keys: NSDictionary?
    
    guard let path = NSBundle.mainBundle().pathForResource("keys", ofType: "plist") else { return }
    
    keys = NSDictionary(contentsOfFile: path)
    
    guard let flickrApiKey = keys?["flickrApiKey"] as? String else { return }
    //we're storing a flickr client secret too, but not using it for now as only some API endpoints require auth
        
    Flickr.Router.apiKey = flickrApiKey
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
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
    //If this is the first time becoming active today, reset the count of daily requests made
    DateServices.checkRequestQuota()
  }
  
  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  // MARK: - Split view
  
  func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
    guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
    guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
    if topAsDetailController.detailItem == nil {
      // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
      return true
    }
    return false
  }
  
}
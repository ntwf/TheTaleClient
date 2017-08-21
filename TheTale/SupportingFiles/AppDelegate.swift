//
//  AppDelegate.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 05/05/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    TaleAPI.shared.playerInformationAutorefresh = .stop
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    TaleAPI.shared.getAuthorisationState { (result) in
      switch result {
      case .success(let data):
        TaleAPI.shared.authorisationState = data
        TaleAPI.shared.playerInformationAutorefresh = .start
        
        if !TaleAPI.shared.isSigned {
          TaleAPI.shared.isSigned = true
          
          let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
          let initialViewController = mainStoryboard.instantiateViewController(withIdentifier: "TabbarScreen") as UIViewController
          self.window?.rootViewController = initialViewController
          self.window?.makeKeyAndVisible()
        }
        
      case .failure(let error as NSError):
        debugPrint("checkAuthorisation", error)
      default: break
      }
    }
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }

}

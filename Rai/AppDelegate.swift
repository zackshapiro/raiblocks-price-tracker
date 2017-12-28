//
//  AppDelegate.swift
//  Rai
//
//  Created by Zack Shapiro on 11/11/17.
//  Copyright © 2017 Zack Shapiro. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let window: UIWindow = UIWindow()
    let rootViewController = RaiRootViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window.frame = UIScreen.main.bounds
        self.window.rootViewController = self.rootViewController
        self.window.makeKeyAndVisible()
        
        return true
    }

}


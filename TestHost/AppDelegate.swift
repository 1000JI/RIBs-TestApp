//
//  AppDelegate.swift
//  TestHost
//
//  Created by 천지운 on 11/14/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    public var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        return true
    }
    
}


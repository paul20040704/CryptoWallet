//
//  AppDelegate.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/10.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        //UINavigationBar.appearance().barTintColor = .init(hex: "#1C1C1C")
        return true
    }
    
}


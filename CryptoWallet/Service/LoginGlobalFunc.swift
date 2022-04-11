//
//  LoginGlobalFunc.swift
//  CryptoWallet
//
//  Created by Fanglin Hsu on 2022/4/8.
//

import Foundation
import UIKit

func goMain() {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let sb = UIStoryboard.init(name: "TabBar", bundle: nil)
    let mainTBC = sb.instantiateViewController(withIdentifier: "tabBarNavigationController")
    appDelegate.window?.rootViewController = mainTBC
}

func goLogin() {
    let welcomeNavigationController = UIStoryboard(name: "Welcome", bundle: nil).instantiateViewController(withIdentifier: "welcomeNavigationController")
    
    if let window = UIApplication.shared.keyWindow {
        window.rootViewController = welcomeNavigationController
    }
}

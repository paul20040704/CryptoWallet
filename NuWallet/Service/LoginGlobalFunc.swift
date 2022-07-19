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
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let welcomeNavigationController = UIStoryboard(name: "Welcome", bundle: nil).instantiateViewController(withIdentifier: "welcomeNavigationController")
    
    appDelegate.window?.rootViewController = welcomeNavigationController

}

func loginout() {
    UD.removeObject(forKey: "token")
    UD.removeObject(forKey: "member")
    UD.synchronize()
    print("登出~清除member及token")
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let LunchVC = UIStoryboard(name: "Welcome", bundle: nil).instantiateViewController(withIdentifier: "LunchVC")

    appDelegate.window?.rootViewController = LunchVC
}

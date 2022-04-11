//
//  TabBarController.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/15.
//

import UIKit

class TabBarController: UITabBarController {
    
    var iTabBarMainViewController: TabBarMainViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
        homeViewController.iTabBarController = self
        
        let walletViewController = UIStoryboard(name: "Wallet", bundle: nil).instantiateViewController(withIdentifier: "walletViewController") as! WalletViewController
        walletViewController.iTabBarController = self
        
        let swapViewController = UIStoryboard(name: "Swap", bundle: nil).instantiateViewController(withIdentifier: "swapViewController") as! SwapViewController
        swapViewController.iTabBarController = self
        
        let accountViewController = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "accountViewController") as! AccountViewController
        accountViewController.iTabBarController = self
        
        self.setViewControllers([homeViewController, walletViewController, UIViewController(), swapViewController, accountViewController], animated: false)
        self.tabBar.items?[2].isEnabled = false
        
        self.tabBar.tintColor = UIColor.init(hex: "#0AC41F") // 選中的顏色
        self.tabBar.unselectedItemTintColor = UIColor.init(hex: "#575757") // 沒選中的顏色
        self.tabBar.barTintColor = UIColor.init(hex: "#1C1C1C") // TabBar背景顏色
        
    }

}

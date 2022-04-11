//
//  WalletViewController.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/15.
//

import UIKit

class WalletViewController: UIViewController {

    var iTabBarController: TabBarController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iTabBarController?.iTabBarMainViewController?.navigationItem.title = "Wallet"
        
        
    }

}

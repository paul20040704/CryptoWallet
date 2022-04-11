//
//  AccountViewController.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/15.
//

import UIKit

class AccountViewController: UIViewController {

    var iTabBarController: TabBarController?
    @IBOutlet weak var iAccountTableView: AccountTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iAccountTableView.iAccountViewController = self
        //iTabBarController?.iTabBarMainViewController?.navigationItem.title = "Account"
        
    }

}

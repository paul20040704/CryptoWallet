//
//  NotifyViewController.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/17.
//

import UIKit

class NotifyViewController: UIViewController {
    
    var iTabBarNavigationController: TabBarNavigationController?
    @IBOutlet weak var iNotifyTableView: NotifyTableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if let nc = self.navigationController as? TabBarNavigationController {
            iTabBarNavigationController = nc
        }
        iNotifyTableView.iNotifyViewController = self
        
        self.navigationItem.title = "Notifications"
        
    }

}

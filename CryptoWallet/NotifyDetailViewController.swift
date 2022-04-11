//
//  NotifyDetailViewController.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/17.
//

import UIKit

class NotifyDetailViewController: UIViewController {

    var iTabBarNavigationController: TabBarNavigationController?
    
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let nc = self.navigationController as? TabBarNavigationController {
            iTabBarNavigationController = nc
        }
        
        self.navigationItem.title = "Message Detail"
        
        
        contentTextView.textContainerInset = UIEdgeInsets.init(top: 15, left: 0, bottom: 15, right: 0)
        
    }

}

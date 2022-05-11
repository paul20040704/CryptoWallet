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
        
        setUI()
        
    }
    
    func setUI() {
        self.navigationItem.title = "Notifications"
        self.navigationItem.backButtonTitle = ""
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_navigationbar_edit"), style: .plain, target: self, action: #selector(edit))
    }
    
    @objc func edit() {
        let notifyEditVC = UIStoryboard(name: "Notify", bundle: nil).instantiateViewController(withIdentifier: "NotifyEditVC") as! NotifyEditVC
        self.navigationController?.show(notifyEditVC, sender: nil)
    }

}

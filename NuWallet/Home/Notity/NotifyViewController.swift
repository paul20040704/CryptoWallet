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
    
    var notifyViewModel = NotifyViewModel()
    var unreadKey = Array<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let nc = self.navigationController as? TabBarNavigationController {
            iTabBarNavigationController = nc
        }
        iNotifyTableView.iNotifyViewController = self
        
        setUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        iNotifyTableView.reloadData()
    }
    
    func setUI() {
        self.navigationItem.title = "Notifications"
        self.navigationItem.backButtonTitle = ""
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_navigationbar_edit"), style: .plain, target: self, action: #selector(edit))
    }
    
    @objc func edit() {
        if let readArray = UD.object(forKey: "boardRead") as? Array<Int> {
            self.unreadKey.removeAll()
            for key in notifyViewModel.sortBoardKey {
                if !(readArray.contains(key)) {
                    unreadKey.append(key)
                }
            }
        }

        let notifyEditVC = UIStoryboard(name: "Notify", bundle: nil).instantiateViewController(withIdentifier: "NotifyEditVC") as! NotifyEditVC
        notifyEditVC.unreadKey = unreadKey
        notifyEditVC.notifyViewModel = notifyViewModel
        self.navigationController?.show(notifyEditVC, sender: nil)
        
    }

}

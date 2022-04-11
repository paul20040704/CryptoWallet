//
//  HomeViewController.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/15.
//

import UIKit

class HomeViewController: UIViewController {
    
    var iTabBarController: TabBarController?
    @IBOutlet weak var iHomeTableView: HomeTableView!
    
    @IBOutlet weak var notifyLabel: UILabel!
    @IBOutlet weak var notifyBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iHomeTableView.iHomeViewController = self
        
        //iTabBarController?.iTabBarMainViewController?.navigationItem.title = "Home"

        notifyLabel.layer.cornerRadius = notifyLabel.frame.size.height / 2
        notifyLabel.clipsToBounds = true
        
        notifyBtn.addTarget(self, action: #selector(notifyBtnClick), for: UIControl.Event.touchUpInside)
        
        
    }
    
    @objc func notifyBtnClick() {
        
        let notifyViewController = UIStoryboard(name: "Notify", bundle: nil).instantiateViewController(withIdentifier: "notifyViewController")
        self.iTabBarController?.iTabBarMainViewController?.iTabBarNavigationController?.pushViewController(notifyViewController, animated: true)
        
    }

}

//
//  TabBarMainViewController.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/15.
//

import UIKit

class TabBarMainViewController: UIViewController {

    var iTabBarNavigationController: TabBarNavigationController?
    var iTabBarController: TabBarController?
    
    @IBOutlet weak var centerBtn: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TabBarController {
            iTabBarController = vc
            iTabBarController?.iTabBarMainViewController = self
            let HomeVC = iTabBarController?.viewControllers?.first as? HomeViewController
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let nc = self.navigationController as? TabBarNavigationController {
            iTabBarNavigationController = nc
        }
        
        centerBtn.backgroundColor = UIColor.clear
        centerBtn.setBackgroundImage(getCenterBtnImage64x64(), for: UIControl.State.normal)
        self.navigationItem.backButtonTitle = ""
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}

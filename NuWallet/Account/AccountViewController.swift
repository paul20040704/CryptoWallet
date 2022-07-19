//
//  AccountViewController.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/15.
//

import UIKit
import PKHUD

class AccountViewController: UIViewController {

    var iTabBarController: TabBarController?
    @IBOutlet weak var iAccountTableView: AccountTableView!
    
    var memberInfo: MemberResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iAccountTableView.iAccountViewController = self
        //iTabBarController?.iTabBarMainViewController?.navigationItem.title = "Account"
        self.memberInfo = US.getMemberInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setData()
    }
    
    func setData() {
        BN.getMember { statusCode, dataObj, err in
            self.memberInfo = dataObj
            DispatchQueue.main.async {
                self.iAccountTableView.reloadData()
            }
        }
    }
    
    

}

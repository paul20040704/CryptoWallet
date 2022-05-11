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
    
    var memberInfo: MemberResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iAccountTableView.iAccountViewController = self
        //iTabBarController?.iTabBarMainViewController?.navigationItem.title = "Account"
        setData()
        
    }
    func setData() {
        if let data = UD.data(forKey: "member"), let member = try? PDecoder.decode(MemberResponse.self, from: data){
            self.memberInfo = member
        }
    }
    
    

}

//
//  SwapViewController.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/15.
//

import UIKit

class SwapViewController: UIViewController {

    @IBOutlet weak var historyBtn: UIButton!
    @IBOutlet weak var swapBtn: UIButton!
    
    var iTabBarController: TabBarController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iTabBarController?.iTabBarMainViewController?.navigationItem.title = "Swap"
        setUI()
    }
    
    func setUI() {
        historyBtn.addTarget(self, action: #selector(goHistory), for: .touchUpInside)
        
        swapBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: swapBtn.frame.height / 2)
    }
    
    @objc func goHistory() {
        let historyVC = UIStoryboard(name: "History", bundle: nil).instantiateViewController(withIdentifier: "HistoryVC") as! HistoryVC
        historyVC.type = 2
        self.navigationController?.show(historyVC, sender: nil)
    }
    

}

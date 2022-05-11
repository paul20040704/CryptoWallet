//
//  historyDetailVC.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/25.
//

import UIKit

class HistoryDetailVC: UIViewController {
    
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var shortLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var networkLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var txidLabel: UILabel!
    @IBOutlet weak var copyBtn: UIButton!
    @IBOutlet weak var typeLabel: UILabel!
    
    var type = 0 // 0 Deposit 1 Withdraw
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Detail"
        setUI()
        // Do any additional setup after loading the view.
    }
    

    func setUI() {
        
        copyBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: copyBtn.frame.height / 2)
        if (type == 1) {
            copyBtn.isHidden = true
            typeLabel.text = "To"
        }
    }
    
    

}

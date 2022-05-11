//
//  SwapHistoryVC.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/25.
//

import UIKit

class SwapHistoryDetailVC: UIViewController {

    @IBOutlet weak var swapImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Detail"
        setUI()
    }
    

    func setUI() {
        
        swapImage.transform()
    }

}

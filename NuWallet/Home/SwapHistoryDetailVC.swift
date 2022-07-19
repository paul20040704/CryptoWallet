//
//  SwapHistoryVC.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/25.
//

import UIKit

class SwapHistoryDetailVC: UIViewController {
    @IBOutlet weak var fromImage: UIImageView!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var fromFullLabel: UILabel!
    
    @IBOutlet weak var toImage: UIImageView!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var toFullLabel: UILabel!
    
    @IBOutlet weak var fromAmountLabel: UILabel!
    @IBOutlet weak var toAmountLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var swapImage: UIImageView!
    
    var swapDetail: HistoryData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Detail"
        setUI()
    }
    

    func setUI() {
        swapImage.transform()
        
        fromImage.image = UIImage(named: "coin_\((swapDetail?.fromCoinId ?? "").lowercased())")
        fromLabel.text = swapDetail?.fromCoinId ?? ""
        fromFullLabel.text = swapDetail?.fromCoinFullName ?? ""
        
        toImage.image = UIImage(named: "coin_\((swapDetail?.toCoinId ?? "").lowercased())")
        toLabel.text = swapDetail?.toCoinId ?? ""
        toFullLabel.text = swapDetail?.toCoinFullName ?? ""
        
        fromAmountLabel.text = String(swapDetail?.payQuantity ?? 0) + " "  + (swapDetail?.fromCoinId ?? "")
        toAmountLabel.text = String(swapDetail?.purchaseQuantity ?? 0) + " " + (swapDetail?.toCoinId ?? "")
        rateLabel.text = String(swapDetail?.exchangeRate ?? 0)
        dateLabel.text = US.isoDateToString(iso: swapDetail?.time ?? "")
    }

}

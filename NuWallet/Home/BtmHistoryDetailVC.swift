//
//  BtmHistoryDetailVC.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/6/27.
//

import UIKit
import PKHUD

class BtmHistoryDetailVC: UIViewController {
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var shortLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var type = 0 // 0 Deposit 1 Withdraw
    var transactionId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        self.navigationItem.title = "detail".localized
        // Do any additional setup after loading the view.
    }
    
    func getData() {
        HUD.show(.systemActivity)
        if (type == 0) {
            BN.getBtmDeposit(transactionId: transactionId) { statusCode, dataObj, err in
                HUD.hide()
                if (statusCode == 200) {
                    self.setLabel(data: dataObj)
                }else{
                    FailView.failView.showMe(error: err?.exception ?? "network_fail".localized)
                }
            }
        }else{
            BN.getBtmWithdrawal(transactionId: transactionId) { statusCode, dataObj, err in
                HUD.hide()
                if (statusCode == 200) {
                    self.setLabel(data: dataObj)
                }else{
                    FailView.failView.showMe(error: err?.exception ?? "network_fail".localized)
                }
            }
        }
    }
    
    func setLabel(data: BtmTransactionList?) {
        self.coinImage.image = UIImage(named: "coin_\((data?.coinId ?? "").lowercased())_btm")
        self.shortLabel.text = data?.coinId ?? ""
        self.fullNameLabel.text = data?.coinFullName ?? ""
        
        self.sourceLabel.text = data?.source ?? ""
        
        let type = data?.type ?? 0
        if (type == 0) {
            self.typeLabel.text = "buy".localized
        }else{
            self.typeLabel.text = "sell".localized
        }
        
        self.amountLabel.text = String(data?.amount ?? 0) + " " + (data?.currency ?? "USD")
        self.currencyLabel.text = String(data?.quantity ?? 0) + " " + (data?.coinId ?? "")
        self.rateLabel.text = String(data?.rate ?? 0)
        
        let status = data?.status ?? 0
        switch status {
        case 0:
            self.statusLabel.text = "Created".localized
        case 1:
            self.statusLabel.text = "Success_1".localized
        case 2:
            self.statusLabel.text = "Canceled".localized
        case 3:
            self.statusLabel.text = "Expired".localized
        default:
            break
        }
        
        self.dateLabel.text = US.isoDateToString(iso: data?.time ?? "")
    }
    
    

}

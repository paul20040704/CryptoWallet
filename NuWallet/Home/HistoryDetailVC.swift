//
//  historyDetailVC.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/25.
//

import UIKit
import PKHUD

class HistoryDetailVC: UIViewController {
    
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var shortLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var networkLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var feeStackView: UIStackView!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var receivedStackView: UIStackView!
    @IBOutlet weak var receivedLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var txidLabel: UILabel!
    @IBOutlet weak var copyBtn: UIButton!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var explorerBtn: UIButton!
    
    var type = 0 // 0 Deposit 1 Withdraw
    var transactionId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "detail".localized
        setUI()
        setData()
    }
    

    func setUI() {
        
        copyBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: copyBtn.frame.height / 2)
        copyBtn.addTarget(self, action: #selector(copyClick), for: .touchUpInside)
        
        explorerBtn.addTarget(self, action: #selector(explorerClick(_:)), for: .touchUpInside)
        explorerBtn.titleLabel?.numberOfLines = 0
        
        if (type == 1) {
            //copyBtn.isHidden = true
            typeLabel.text = "to".localized
        }
    }
    
    func setData() {
        HUD.show(.systemActivity)
        if (type == 0) {
            BN.getDepositList(transactionId: transactionId) { statusCode, dataObj, err in
                HUD.hide()
                if (statusCode == 200) {
                    let coin = dataObj?.coinId ?? ""
                    self.coinImage.image = UIImage(named: "coin_\(coin.lowercased())")
                    self.shortLabel.text = coin
                    self.fullNameLabel.text = dataObj?.coinFullName ?? ""
                    self.networkLabel.text = dataObj?.network ?? ""
                    self.amountLabel.text = String(dataObj?.quantity ?? 0) + "  \(coin)"
                    self.feeStackView.isHidden = true
                    self.receivedStackView.isHidden = true
                    self.fromLabel.text = dataObj?.fromAddress ?? ""
                    self.dateLabel.text = US.isoDateToString(iso: dataObj?.time ?? "")
                    var statusStr = ""
                    if (dataObj?.status == 0) {
                        statusStr = "transaction_status_processing".localized
                    }
                    else if (dataObj?.status == 1) {
                        statusStr = "transaction_status_done".localized
                    }
                    else {
                        statusStr = "transaction_status_fail".localized
                    }
                    self.statusLabel.text = statusStr
                    self.txidLabel.text = dataObj?.txid ?? "--------"
                    self.explorerBtn.setTitle(dataObj?.explorerUrl ?? "", for: .normal)
                }
            }
        }else{
            BN.getWithdrawList(transactionId: transactionId) { statusCode, dataObj, err in
                HUD.hide()
                if (statusCode == 200) {
                    let coin = dataObj?.coinId ?? ""
                    self.coinImage.image = UIImage(named: "coin_\(coin.lowercased())")
                    self.shortLabel.text = coin
                    self.fullNameLabel.text = dataObj?.coinFullName ?? ""
                    self.networkLabel.text = dataObj?.network ?? ""
                    self.amountLabel.text = String(dataObj?.quantity ?? 0) + "  \(coin)"
                    self.feeStackView.isHidden = false
                    self.receivedStackView.isHidden = false
                    self.feeLabel.text = String(dataObj?.fee ?? 0) + "  \(coin)"
                    let quantity = dataObj?.quantity ?? 0
                    let fee = dataObj?.fee ?? 0
                    let expect = (quantity - fee).rounding(toDecimal: 5)
                    self.receivedLabel.text = String(expect) + " \(coin)"
                    self.fromLabel.text = dataObj?.destinationAddress ?? ""
                    self.dateLabel.text = US.isoDateToString(iso: dataObj?.time ?? "")
                    var statusStr = ""
                    if (dataObj?.status == 0) {
                        statusStr = "transaction_status_processing".localized
                    }
                    else if (dataObj?.status == 1) {
                        statusStr = "transaction_status_done".localized
                    }
                    else {
                        statusStr = "transaction_status_fail".localized
                    }
                    self.statusLabel.text = statusStr
                    self.txidLabel.text = dataObj?.txid ?? "--------"
                    self.explorerBtn.setTitle(dataObj?.explorerUrl ?? "", for: .normal)
                }
            }
        }
    }
    
    @objc func explorerClick(_ sender: UIButton) {
        let urlStr = sender.titleLabel?.text ?? ""
        if let url = URL(string: urlStr) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    @objc func copyClick() {
        UIPasteboard.general.string = self.txidLabel.text
        HUD.flash(.label("copy_text".localized), delay: 1.0)
    }
    
    

}

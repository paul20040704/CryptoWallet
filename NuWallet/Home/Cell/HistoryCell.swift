//
//  historyCell.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/25.
//

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    var transactionId = ""
    var isBtmTransaction = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(model: TransactionModel) {
        self.transactionId = model.transactionId
        self.isBtmTransaction = model.isBtmTransaction
        if model.isBtmTransaction {
            self.coinImage.image = UIImage(named: "coin_\(model.coinId.lowercased())_btm")
        }else{
            self.coinImage.image = UIImage(named: "coin_\(model.coinId.lowercased())")
        }
        self.idLabel.text = model.coinId
        self.timeLabel.text = US.isoDateToString(iso: model.time)
        self.amountLabel.text = String(model.quantity)
        var statusStr = ""
        if (model.status == 0) {
            statusStr = "transaction_status_processing".localized
        }
        else if (model.status == 1) {
            statusStr = "transaction_status_done".localized
        }
        else {
            statusStr = "transaction_status_fail".localized
        }
        self.statusLabel.text = statusStr
    }
    
}

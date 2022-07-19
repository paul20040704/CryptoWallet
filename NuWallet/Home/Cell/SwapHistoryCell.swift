//
//  SwapHistoryCell.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/25.
//

import UIKit

class SwapHistoryCell: UITableViewCell {
    
    @IBOutlet weak var fromCoinImage: UIImageView!
    @IBOutlet weak var toCoinImage: UIImageView!
    @IBOutlet weak var fromCoinLabel: UILabel!
    @IBOutlet weak var toCoinLabel: UILabel!
    @IBOutlet weak var payLabel: UILabel!
    @IBOutlet weak var purchaseLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var swapImage: UIImageView!
    
    var transactionId = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUI() {
        swapImage.transform()
    }
    
    func setup(model: HistoryData) {
        self.transactionId = model.transactionId ?? ""
        self.fromCoinImage.image = UIImage(named: "coin_\(model.fromCoinId?.lowercased() ?? "")")
        self.toCoinImage.image = UIImage(named: "coin_\(model.toCoinId?.lowercased() ?? "")")
        self.fromCoinLabel.text = model.fromCoinId ?? ""
        self.toCoinLabel.text = model.toCoinId ?? ""
        self.payLabel.text = String(model.payQuantity ?? 0)
        self.purchaseLabel.text = String(model.purchaseQuantity ?? 0)
        self.timeLabel.text = US.isoDateToString(iso: model.time ?? "")
    }
}

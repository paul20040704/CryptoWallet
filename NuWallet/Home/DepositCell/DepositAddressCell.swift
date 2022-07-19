//
//  DepositAddressCell.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/5/16.
//

import UIKit
import PKHUD

class DepositAddressCell: UITableViewCell {

    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var copyBtn: UIButton!
    @IBOutlet weak var qrcodeBtn: UIButton!
    
    var depositDetailVC: DepositDetailVC?
    var coin = ""
    var key = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        copyBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: copyBtn.frame.height / 2)
        copyBtn.addTarget(self, action: #selector(copyClick), for: .touchUpInside)
        
        qrcodeBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: qrcodeBtn.frame.height / 2)
        qrcodeBtn.addTarget(self, action: #selector(qrcodeClick), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func copyClick() {
        UIPasteboard.general.string = self.addressLabel.text
        HUD.flash(.label("copy_text".localized), delay: 1.0)
    }
    
    @objc func qrcodeClick() {
        QrcodeView.qrcodeView.showMe(qrStr: self.addressLabel.text ?? "",coin: coin ,key: key)
    }
    
    
    

}

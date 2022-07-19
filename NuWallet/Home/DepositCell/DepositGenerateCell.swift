//
//  DepositGenerateCell.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/5/16.
//

import UIKit

class DepositGenerateCell: UITableViewCell {

    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var coinLable: UILabel!
    @IBOutlet weak var generateBtn: UIButton!
    
    var depositDetailVC: DepositDetailVC?
    var key = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        generateBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: 10)
        generateBtn.addTarget(self, action: #selector(generateClick), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func generateClick() {
//        generateBtn.isUserInteractionEnabled = false
//        print("generateClick")
//        depositDetailVC?.postAddress(key: key, response: {
//            self.generateBtn.isUserInteractionEnabled = true
//        })
        depositDetailVC?.postAddress(key: key)
    }

}

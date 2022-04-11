//
//  AccountTableViewCellLabel.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/21.
//

import UIKit

class AccountTableViewCellLabel: UITableViewCell {

    var iAccountTableView: AccountTableView?
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

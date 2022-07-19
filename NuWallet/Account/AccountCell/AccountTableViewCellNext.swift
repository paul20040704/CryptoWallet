//
//  AccountTableViewCellNext.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/21.
//

import UIKit

class AccountTableViewCellNext: UITableViewCell {

    var iAccountTableView: AccountTableView?
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nextImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellView.layer.cornerRadius = 10
        cellView.clipsToBounds = true
        
    }
    
    override func prepareForReuse() {
        //cellView.backgroundColor = UIColor.init(hex: "#242424")
        titleLabel.textColor = UIColor.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

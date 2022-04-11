//
//  HomeTableViewCellCoin.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/16.
//

import UIKit

class HomeTableViewCellCoin: UITableViewCell {

    var iHomeTableView: HomeTableView?
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cellCoinImageView: UIImageView!
    @IBOutlet weak var cellCoinShortNameLabel: UILabel!
    @IBOutlet weak var cellCoinFullNameLabel: UILabel!
    @IBOutlet weak var cellCoinGraphImageView: UIImageView!
    @IBOutlet weak var cellCoinValueLabel: UILabel!
    @IBOutlet weak var cellCoinPercentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellCoinGraphImageView.contentMode = .scaleToFill
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

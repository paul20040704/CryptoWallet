//
//  SecurityNextCell1.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/12.
//

import UIKit

class SecurityNextCell1: UITableViewCell {
    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var nextImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellView.layer.cornerRadius = 10
        cellView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

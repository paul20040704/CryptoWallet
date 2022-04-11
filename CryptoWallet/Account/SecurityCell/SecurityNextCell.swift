//
//  SecurityNextCell.swift
//  CryptoWallet
//
//  Created by Fanglin Hsu on 2022/4/8.
//

import UIKit

class SecurityNextCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var conLab: UILabel!
    @IBOutlet weak var nextImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.cornerRadius = 10
        cellView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}

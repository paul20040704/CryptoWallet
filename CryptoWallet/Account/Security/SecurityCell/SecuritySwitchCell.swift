//
//  SecuritySwitchCell.swift
//  CryptoWallet
//
//  Created by Fanglin Hsu on 2022/4/10.
//

import UIKit

class SecuritySwitchCell: UITableViewCell {
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var switchBtn: UISwitch!
    @IBOutlet weak var conTextView: UITextView!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
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
    
    func changeHeight(height: Int) {
        if tag == 1 {
            viewHeightConstraint.constant = CGFloat(height)
        }
    }
    
}

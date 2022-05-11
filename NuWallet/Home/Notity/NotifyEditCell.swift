//
//  NotifyEditCell.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/5/5.
//

import UIKit

class NotifyEditCell: UITableViewCell {

    @IBOutlet weak var editBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        editBtn.setBackgroundImage(UIImage(named: "button_main_check1b"), for: .normal)
        editBtn.setBackgroundImage(UIImage(named: "button_main_check2"), for: .selected)
        editBtn.addTarget(self, action: #selector(editClick(_:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @objc func editClick(_ btn: UIButton) {
        btn.isSelected = !(btn.isSelected)
    }
    
}

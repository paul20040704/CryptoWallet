//
//  SecuritySwitchCell.swift
//  CryptoWallet
//
//  Created by Fanglin Hsu on 2022/4/10.
//

import UIKit

protocol UpdateDelegate {
    func updateTwoAuthOption(type: Int, enable: Bool)
}

class SecuritySwitchCell: UITableViewCell {
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var switchBtn: UISwitch!
    @IBOutlet weak var conTextView: UITextView!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    var delegate: UpdateDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.cornerRadius = 10
        cellView.clipsToBounds = true
        switchBtn.addTarget(self, action: #selector(onChange(sender:)), for: .valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func changeHeight(height: Int) {
        viewHeightConstraint.constant = CGFloat(height)
    }
    
    @objc func onChange(sender: UISwitch) {
        switch sender.tag {
        case 0:
            if (sender.isOn) {
                US.setFaceID(enable: true)
            }else{
                US.setFaceID(enable: false)
            }
        case 1:
            if (sender.isOn) {
                self.delegate?.updateTwoAuthOption(type: 0, enable: true)
            }else{
                self.delegate?.updateTwoAuthOption(type: 0, enable: false)
            }
        default:
            if (sender.isOn) {
                self.delegate?.updateTwoAuthOption(type: 1, enable: true)
            }else{
                self.delegate?.updateTwoAuthOption(type: 1, enable: false)
            }
        }
    }
    
    
    
}

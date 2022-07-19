//
//  NotifyEditCell.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/5/5.
//

import UIKit

class NotifyEditCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    
    var updateSelect: ((_ id: Int, _ type: Int) -> ())?
    
    var id = Int()
    var selectKey = Array<Int>()
    
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
        if !(btn.isSelected) {
            btn.isSelected = !(btn.isSelected)
            self.updateSelect?(id, 0)
        }else{
            btn.isSelected = !(btn.isSelected)
            self.updateSelect?(id, 1)
        }
        
    }
    
    func setup(vm: BoardModel) {
        self.id = vm.id
        self.titleLabel.text = vm.title
        self.timeLabel.text = US.isoDateToString(iso: vm.postOn)
        if selectKey.contains(vm.id) {
            editBtn.isSelected = true
        }else{
            editBtn.isSelected = false
        }
    }
    
}

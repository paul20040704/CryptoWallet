//
//  NotifyTableViewCell.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/17.
//

import UIKit

class NotifyTableViewCell: UITableViewCell {

    @IBOutlet weak var redPointView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var iNotifyTableView: NotifyTableView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        redPointView.isHidden = true
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(vm: BoardModel) {
        self.titleLabel.text = vm.title
        self.timeLabel.text = US.isoDateToString(iso: vm.postOn)
        judgeRead(id: vm.id)
    }
    
    func judgeRead(id: Int) {
        if let readArray = UD.array(forKey: "boardRead") as? Array<Int> {
            if !(readArray.contains(id)) {
                self.redPointView.isHidden = false
            }
        }
    }

}

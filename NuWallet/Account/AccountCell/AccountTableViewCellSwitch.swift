//
//  AccountTableViewCellSwitch.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/21.
//

import UIKit
import Observable

enum NotificationStatusType {
    case authorized
    case denied
    case notDetermined
}

class AccountTableViewCellSwitch: UITableViewCell {

    var iAccountTableView: AccountTableView?
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchBtn: UISwitch!
    @IBOutlet weak var pushBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellView.layer.cornerRadius = 10
        cellView.clipsToBounds = true
        pushBtn.addTarget(self, action: #selector(changePush), for: .touchUpInside)
        
        notificationStatus.afterChange += { oldStatus,newStatus in
              if newStatus == NotificationStatusType.authorized {
                  self.switchBtn.isOn = true
              } else if newStatus == NotificationStatusType.denied {
                  self.switchBtn.isOn = false
              }
           }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func changePush() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { setting in
                DispatchQueue.main.async {

                    let alertVC = UIAlertController(title: "設定通知", message: "如果您要設定是否通知，請前往系統設置。", preferredStyle: .alert)
                    let settingAction = UIAlertAction(title: "前往設定", style: .destructive) { action in
                        if let bundleId = Bundle.main.bundleIdentifier, let url = URL(string: UIApplication.openSettingsURLString + bundleId) {
                            UIApplication.shared.open(url)
                        }
                    }
                    let okAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                    alertVC.addAction(settingAction)
                    alertVC.addAction(okAction)
                    self.iAccountTableView?.iAccountViewController?.present(alertVC, animated: true)
                }
            }
        }
    }
    
    func checkNotification() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { setting in
                DispatchQueue.main.async {
                    if setting.authorizationStatus == .authorized {
                        self.switchBtn.isOn = true
                    }else if setting.authorizationStatus == .denied {
                        self.switchBtn.isOn = false
                    }else if setting.authorizationStatus == .notDetermined {

                    }
                }
            }
        }
    }

}

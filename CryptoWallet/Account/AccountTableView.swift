//
//  AccountTableView.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/21.
//

import UIKit

class AccountTableView: UITableView, UITableViewDataSource, UITableViewDelegate {

    var iAccountViewController: AccountViewController?
    
    override func awakeFromNib() {
        self.dataSource = self
        self.delegate = self
        self.contentInset = UIEdgeInsets.init(top: 15, left: 0, bottom: 15, right: 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 13
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "accountTableViewCellTitle", for: indexPath) as? AccountTableViewCellTitle {
                
                cell.iAccountTableView = self
                
                cell.titleLabel.text = "+886-123-456-789"
                
                return cell
            } else {
                return UITableViewCell()
            }
        } else if (indexPath.row == 1) {
            // Account
            if let cell = tableView.dequeueReusableCell(withIdentifier: "accountTableViewCellLabel", for: indexPath) as? AccountTableViewCellLabel {
                
                cell.iAccountTableView = self
                
                cell.titleLabel.text = "Account"
                
                return cell
            } else {
                return UITableViewCell()
            }
        } else if (indexPath.row == 2) {
            // Account Verification
            if let cell = tableView.dequeueReusableCell(withIdentifier: "accountTableViewCellNext", for: indexPath) as? AccountTableViewCellNext {
                
                cell.iAccountTableView = self
                
                cell.titleImageView.image = UIImage.init(named: "icon_toolbar_accountverification")
                cell.titleLabel.text = "Account Verification"
                
                
                return cell
            } else {
                return UITableViewCell()
            }
        } else if (indexPath.row == 3) {
            // Referral & Reward
            if let cell = tableView.dequeueReusableCell(withIdentifier: "accountTableViewCellNext", for: indexPath) as? AccountTableViewCellNext {
                
                cell.iAccountTableView = self
                
                cell.titleImageView.image = UIImage.init(named: "icon_toolbar_referralreward")
                cell.titleLabel.text = "Referral & Reward"
                
                
                return cell
            } else {
                return UITableViewCell()
            }
        } else if (indexPath.row == 4) {
            // Security
            if let cell = tableView.dequeueReusableCell(withIdentifier: "accountTableViewCellNext", for: indexPath) as? AccountTableViewCellNext {
                
                cell.iAccountTableView = self
                
                cell.titleImageView.image = UIImage.init(named: "icon_toolbar_security")
                cell.titleLabel.text = "Security"
                
                
                return cell
            } else {
                return UITableViewCell()
            }
        } else if (indexPath.row == 5) {
            // Setting
            if let cell = tableView.dequeueReusableCell(withIdentifier: "accountTableViewCellLabel", for: indexPath) as? AccountTableViewCellLabel {
                
                cell.iAccountTableView = self
                
                cell.titleLabel.text = "Setting"
                
                
                return cell
            } else {
                return UITableViewCell()
            }
        } else if (indexPath.row == 6) {
            // Notification
            if let cell = tableView.dequeueReusableCell(withIdentifier: "accountTableViewCellSwitch", for: indexPath) as? AccountTableViewCellSwitch {
                
                cell.iAccountTableView = self
                
                cell.titleImageView.image = UIImage.init(named: "icon_toolbar_notification")
                cell.titleLabel.text = "Notification"
                
                
                return cell
            } else {
                return UITableViewCell()
            }
        } else if (indexPath.row == 7) {
            // Language
            if let cell = tableView.dequeueReusableCell(withIdentifier: "accountTableViewCellNext", for: indexPath) as? AccountTableViewCellNext {
                
                cell.iAccountTableView = self
                
                cell.titleImageView.image = UIImage.init(named: "icon_toolbar_language")
                cell.titleLabel.text = "Language"
                
                
                return cell
            } else {
                return UITableViewCell()
            }
        } else if (indexPath.row == 8) {
            // Support
            if let cell = tableView.dequeueReusableCell(withIdentifier: "accountTableViewCellLabel", for: indexPath) as? AccountTableViewCellLabel {
                
                cell.iAccountTableView = self
                
                cell.titleLabel.text = "Support"
                
                
                return cell
            } else {
                return UITableViewCell()
            }
        } else if (indexPath.row == 9) {
            // FAQ
            if let cell = tableView.dequeueReusableCell(withIdentifier: "accountTableViewCellNext", for: indexPath) as? AccountTableViewCellNext {
                
                cell.iAccountTableView = self
                
                cell.titleImageView.image = UIImage.init(named: "icon_toolbar_faq")
                cell.titleLabel.text = "FAQ"
                
                
                return cell
            } else {
                return UITableViewCell()
            }
        } else if (indexPath.row == 10) {
            // Contact us
            if let cell = tableView.dequeueReusableCell(withIdentifier: "accountTableViewCellNext", for: indexPath) as? AccountTableViewCellNext {
                
                cell.iAccountTableView = self
                
                cell.titleImageView.image = UIImage.init(named: "icon_toolbar_contact")
                cell.titleLabel.text = "Contact us"
                
                
                return cell
            } else {
                return UITableViewCell()
            }
        } else if (indexPath.row == 11) {
            // Logout none title
            if let cell = tableView.dequeueReusableCell(withIdentifier: "accountTableViewCellLabel", for: indexPath) as? AccountTableViewCellLabel {
                
                cell.iAccountTableView = self
                
                cell.titleLabel.text = ""
                
                
                return cell
            } else {
                return UITableViewCell()
            }
        } else if (indexPath.row == 12) {
            // Logout
            if let cell = tableView.dequeueReusableCell(withIdentifier: "accountTableViewCellNext", for: indexPath) as? AccountTableViewCellNext {
                
                cell.iAccountTableView = self
                
                cell.titleImageView.image = UIImage.init(named: "icon_toolbar_logout")
                cell.titleLabel.text = "Logout"
                cell.titleLabel.textColor = UIColor.init(hex: "575757")
                cell.nextImageView.isHidden = true
                
                return cell
            } else {
                return UITableViewCell()
            }
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 4:
            let SecurityVC = UIStoryboard(name: "Security", bundle: nil).instantiateViewController(withIdentifier: "SecurityVC")
            SecurityVC.hidesBottomBarWhenPushed = true
            iAccountViewController?.navigationController?.show(SecurityVC, sender: nil)
        default:
            break
        }
    }
    
    
    @objc func logoutClick(_ btn: UIButton) {
        
        let alert = UIAlertController(title: "Logout", message: "Are you sure want to logout?", preferredStyle: .alert)
        
        let comfirmAction = UIAlertAction(title: "Confirm", style: .default) { action in
            let welcomeNavigationController = UIStoryboard(name: "Welcome", bundle: nil).instantiateViewController(withIdentifier: "welcomeNavigationController")
            
            if let window = UIApplication.shared.keyWindow {
                window.rootViewController = welcomeNavigationController
            }
        }
        alert.addAction(comfirmAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        iAccountViewController?.present(alert, animated: true, completion: nil)
    }

}

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
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "accountTableViewCellTitle", for: indexPath) as? AccountTableViewCellTitle {
                
                cell.iAccountTableView = self
                cell.titleLabel.text = mobileStrFormat(id: iAccountViewController?.memberInfo?.countryCode ?? "", number:iAccountViewController?.memberInfo?.mobileNumber ?? "", type: 0)
                
                return cell
            } else {
                return UITableViewCell()
            }
        } else if (indexPath.row == 1) {
            // Account
            if let cell = tableView.dequeueReusableCell(withIdentifier: "accountTableViewCellLabel", for: indexPath) as? AccountTableViewCellLabel {
                
                cell.iAccountTableView = self
                cell.titleLabel.text = "account".localized
                
                return cell
            } else {
                return UITableViewCell()
            }
        } else if (indexPath.row == 2) {
            // Account Verification
            if let cell = tableView.dequeueReusableCell(withIdentifier: "accountTableViewCellNext", for: indexPath) as? AccountTableViewCellNext {
                
                cell.iAccountTableView = self
                cell.nextImageView.isHidden = false
                cell.titleImageView.image = UIImage.init(named: "icon_toolbar_accountverification")
                cell.titleLabel.text = "account_verification".localized
                
                return cell
            } else {
                return UITableViewCell()
            }
        } else if (indexPath.row == 3) {
            // Referral & Reward
            if let cell = tableView.dequeueReusableCell(withIdentifier: "accountTableViewCellNext", for: indexPath) as? AccountTableViewCellNext {
                
                cell.iAccountTableView = self
                cell.nextImageView.isHidden = false
                cell.titleImageView.image = UIImage.init(named: "icon_toolbar_referralreward")
                cell.titleLabel.text = "referral_reward".localized
                
                return cell
            } else {
                return UITableViewCell()
            }
        } else if (indexPath.row == 4) {
            // Security
            if let cell = tableView.dequeueReusableCell(withIdentifier: "accountTableViewCellNext", for: indexPath) as? AccountTableViewCellNext {
                
                cell.iAccountTableView = self
                cell.nextImageView.isHidden = false
                cell.titleImageView.image = UIImage.init(named: "icon_toolbar_security")
                cell.titleLabel.text = "security".localized
                
                return cell
            } else {
                return UITableViewCell()
            }
        } else if (indexPath.row == 5) {
            // Setting
            if let cell = tableView.dequeueReusableCell(withIdentifier: "accountTableViewCellLabel", for: indexPath) as? AccountTableViewCellLabel {
                
                cell.iAccountTableView = self
                cell.titleLabel.text = "setting".localized
                
                return cell
            } else {
                return UITableViewCell()
            }
        } else if (indexPath.row == 6) {
            // Notification
            if let cell = tableView.dequeueReusableCell(withIdentifier: "accountTableViewCellSwitch", for: indexPath) as? AccountTableViewCellSwitch {
                
                cell.iAccountTableView = self
                cell.checkNotification()
                cell.titleImageView.image = UIImage.init(named: "icon_toolbar_notification")
                cell.titleLabel.text = "notifications".localized
                
                return cell
            } else {
                return UITableViewCell()
            }
        } else if (indexPath.row == 7) {
            // Language
            if let cell = tableView.dequeueReusableCell(withIdentifier: "accountTableViewCellNext", for: indexPath) as? AccountTableViewCellNext {
                
                cell.iAccountTableView = self
                cell.nextImageView.isHidden = false
                cell.titleImageView.image = UIImage.init(named: "icon_toolbar_language")
                cell.titleLabel.text = "language".localized
                
                return cell
            } else {
                return UITableViewCell()
            }
        } else if (indexPath.row == 8) {
            // Support
            if let cell = tableView.dequeueReusableCell(withIdentifier: "accountTableViewCellLabel", for: indexPath) as? AccountTableViewCellLabel {
                
                cell.iAccountTableView = self
                cell.titleLabel.text = "support".localized
                
                return cell
            } else {
                return UITableViewCell()
            }
        } else if (indexPath.row == 9) {
            // FAQ
            if let cell = tableView.dequeueReusableCell(withIdentifier: "accountTableViewCellNext", for: indexPath) as? AccountTableViewCellNext {
                
                cell.iAccountTableView = self
                cell.nextImageView.isHidden = false
                cell.titleImageView.image = UIImage.init(named: "icon_toolbar_faq")
                cell.titleLabel.text = "faq".localized
                
                
                return cell
            } else {
                return UITableViewCell()
            }
        } else if (indexPath.row == 10) {
            // Contact us
            if let cell = tableView.dequeueReusableCell(withIdentifier: "accountTableViewCellNext", for: indexPath) as? AccountTableViewCellNext {
                
                cell.iAccountTableView = self
                cell.nextImageView.isHidden = false
                cell.titleImageView.image = UIImage.init(named: "icon_toolbar_contact")
                cell.titleLabel.text = "contact_us".localized
                
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
                cell.titleLabel.text = "logout".localized
                //cell.titleLabel.textColor = UIColor.init(hex: "575757")
                cell.nextImageView.isHidden = true
                
                return cell
            } else {
                return UITableViewCell()
            }
        } else if (indexPath.row == 13) {
            // Logout
            if let cell = tableView.dequeueReusableCell(withIdentifier: "accountTableViewCellNext", for: indexPath) as? AccountTableViewCellNext {
                
                cell.iAccountTableView = self
                cell.titleImageView.image = UIImage.init(named: "icon_toolbar_deleteaccount")
                cell.titleLabel.text = "delete_account".localized
                cell.titleLabel.textColor = UIColor.init(hex: "#D93F3F")
                cell.nextImageView.isHidden = true
                
                return cell
            } else {
                return UITableViewCell()
            }
        } else if (indexPath.row == 14) {
            // Logout
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AccountVersionCell", for: indexPath) as? AccountVersionCell {
                cell.versionLabel.text = "v" + localVersion
                
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
        case 2:
            let status = iAccountViewController?.memberInfo?.memberKycStatus ?? 0
            //let status = 0
            switch status {
            case 0:
                //let KYCTermsVC = UIStoryboard(name: "KYC", bundle: nil).instantiateViewController(withIdentifier: "KYCVerification3VC")
                let KYCTermsVC = UIStoryboard(name: "KYC", bundle: nil).instantiateViewController(withIdentifier: "KYCTermsVC")
                KYCTermsVC.hidesBottomBarWhenPushed = true
                iAccountViewController?.navigationController?.show(KYCTermsVC, sender: nil)
            case 1:
                let KYCVerifyingVC = UIStoryboard(name: "KYCStatus", bundle: nil).instantiateViewController(withIdentifier: "KYCVerifyingVC")
                KYCVerifyingVC.hidesBottomBarWhenPushed = true
                iAccountViewController?.navigationController?.show(KYCVerifyingVC, sender: nil)
            case 2:
                let KYCPassVC = UIStoryboard(name: "KYCStatus", bundle: nil).instantiateViewController(withIdentifier: "KYCPassVC")
                KYCPassVC.hidesBottomBarWhenPushed = true
                iAccountViewController?.navigationController?.show(KYCPassVC, sender: nil)
            default:
                let KYCVerifyFailVC = UIStoryboard(name: "KYCStatus", bundle: nil).instantiateViewController(withIdentifier: "KYCVerifyFailVC") as! KYCVerifyFailVC
                KYCVerifyFailVC.hidesBottomBarWhenPushed = true
                KYCVerifyFailVC.status = status
                iAccountViewController?.navigationController?.show(KYCVerifyFailVC, sender: nil)
            }
        case 3:
            let referralVC = UIStoryboard(name: "Referral", bundle: nil).instantiateViewController(withIdentifier: "ReferralVC") as! ReferralVC
            referralVC.invitationCode = iAccountViewController?.memberInfo?.invitationCode ?? ""
            iAccountViewController?.navigationController?.show(referralVC, sender: nil)
        case 4:
            let SecurityVC = UIStoryboard(name: "SecurityVC", bundle: nil).instantiateViewController(withIdentifier: "SecurityVC")
            SecurityVC.hidesBottomBarWhenPushed = true
            iAccountViewController?.navigationController?.show(SecurityVC, sender: nil)
        case 7:
            let languageVC = UIStoryboard(name: "LanguageVC", bundle: nil).instantiateViewController(withIdentifier: "LanguageVC") as! LanguageVC
            languageVC.accountViewController = iAccountViewController
            iAccountViewController?.navigationController?.show(languageVC, sender: nil)
        case 9:
            openUrlStr(urlStr: "https://numiner.zendesk.com/hc/en-001/sections/5319628035097-Common")
        case 10:
            let contactListVC = UIStoryboard(name: "Contact", bundle: nil).instantiateViewController(withIdentifier: "ContactListVC")
            iAccountViewController?.navigationController?.show(contactListVC, sender: nil)
        case 12:
            LogoutView.logoutView.showMe()
        case 13:
            let deleteVC = UIStoryboard(name: "DeleteVC", bundle: nil).instantiateViewController(withIdentifier: "DeleteVC")
            deleteVC.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
            iAccountViewController?.present(deleteVC, animated: true, completion: nil)
        default:
            break
        }
    }
    
    

}

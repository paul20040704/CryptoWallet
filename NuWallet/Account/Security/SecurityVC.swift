//
//  SecurityVC.swift
//  CryptoWallet
//
//  Created by Fanglin Hsu on 2022/4/8.
//

import UIKit
import PKHUD

class SecurityVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var memberInfo: MemberResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "security".localized
        self.navigationItem.backButtonTitle = ""
        // Do any additional setup after loading the view.
        setData()
        initTV()
    }
    
    func initTV() {
        let nib = UINib(nibName: "SecurityNextCell", bundle: nil)
        let nib1 = UINib(nibName: "SecuritySwitchCell", bundle: nil)
        let nib2 = UINib(nibName: "SecurityNextCell1", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SecurityNextCell")
        tableView.register(nib1, forCellReuseIdentifier: "SecuritySwitchCell")
        tableView.register(nib2, forCellReuseIdentifier: "SecurityNextCell1")
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        tableView.autoresizesSubviews = false

    }
    
    func setData() {
        BN.getMember { statusCode, dataObj, err in
            self.memberInfo = dataObj
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let data = UD.data(forKey: "member"), let member = try? PDecoder.decode(MemberResponse.self, from: data){
            self.memberInfo = member
        }
        
    }
    
    
}


extension SecurityVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 5
        case 1:
            return 3
        default:
            return 2
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nextCell = tableView.dequeueReusableCell(withIdentifier: "SecurityNextCell", for: indexPath) as! SecurityNextCell
        let nextCell1 = tableView.dequeueReusableCell(withIdentifier: "SecurityNextCell1", for: indexPath) as! SecurityNextCell1
        let switchCell = tableView.dequeueReusableCell(withIdentifier: "SecuritySwitchCell", for: indexPath) as! SecuritySwitchCell
        switch indexPath.section{
        case 0:
            if (indexPath.row == 0) {
                nextCell.titleLab.text = "sms".localized
                if memberInfo?.mobileNumber != nil {
                    nextCell.titleImage.image = UIImage(named: "icon_toolbar_state_finish")
                    nextCell.conLab.text = mobileStrFormat(id: memberInfo?.countryCode ?? "", number: memberInfo?.mobileNumber ?? "", type: 1)
                }else{
                    nextCell.titleImage.image = UIImage(named: "icon_toolbar_state_unfinish")
                    nextCell.conLab.text = ""
                }
                return nextCell
            }
            else if (indexPath.row == 1) {
                nextCell.titleLab.text = "email".localized
                if memberInfo?.verifiedEmail != nil {
                    nextCell.titleImage.image = UIImage(named: "icon_toolbar_state_finish")
                    nextCell.conLab.text = emailStrFormat(email: memberInfo?.verifiedEmail ?? "")
                }else{
                    nextCell.titleImage.image = UIImage(named: "icon_toolbar_state_unfinish")
                    nextCell.conLab.text = ""
                }
                return nextCell
            }
            else if (indexPath.row == 2) {
                nextCell.titleLab.text = "authenticator".localized
                if let bound = memberInfo?.authenticatorBound {
                    if bound {
                        nextCell.titleImage.image = UIImage(named: "icon_toolbar_state_finish")
                        nextCell.conLab.text = ""
                    }else{
                        nextCell.titleImage.image = UIImage(named: "icon_toolbar_state_unfinish")
                        nextCell.conLab.text = ""
                    }
                }
                return nextCell
            }
            else if (indexPath.row == 3) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "normalCell", for: indexPath) as! normalCell
                return cell
            }
            else if (indexPath.row == 4) {
                nextCell.titleImage.image = UIImage(named: "icon_toolbar_twofactor")
                nextCell.titleLab.text = "twofa".localized
                nextCell.conLab.text = ""
                return nextCell
            }
        case 1:
            if (indexPath.row == 0) {
                nextCell1.titleLab.text = "login_password".localized
                return nextCell1
            }
            if (indexPath.row == 1) {
                switchCell.titleLab.text = "unlock_type".localized
                switchCell.conTextView.text = "unlock_type_text".localized
                switchCell.changeHeight(height: 110)
                let enable = UD.bool(forKey: "faceId")
                if (enable) {
                    switchCell.switchBtn.isOn = true
                }else{
                    switchCell.switchBtn.isOn = false
                }
                switchCell.switchBtn.tag = 0
                return switchCell
            }
            if (indexPath.row == 2) {
                switchCell.titleLab.text = "twofa".localized
                switchCell.conTextView.text = "twofa_text_two".localized
                switchCell.changeHeight(height: 125)
                if let auth = memberInfo?.loginTwoFactorAuthEnabled {
                    if (auth) {
                        switchCell.switchBtn.isOn = true
                    }else{
                        switchCell.switchBtn.isOn = false
                    }
                }
                switchCell.switchBtn.tag = 1
                switchCell.delegate = self
                return switchCell
            }
        default:
            if (indexPath.row == 0) {
                nextCell1.titleLab.text = "transaction_password".localized
                return nextCell1
            }
            if (indexPath.row == 1) {
                switchCell.titleLab.text = "twofa".localized
                switchCell.conTextView.text = "twofa_text_two".localized
                switchCell.changeHeight(height: 125)
                if let auth = memberInfo?.operatingTwoFactorAuthEnabled {
                    if (auth) {
                        switchCell.switchBtn.isOn = true
                    }else{
                        switchCell.switchBtn.isOn = false
                    }
                }
                switchCell.switchBtn.tag = 2
                switchCell.delegate = self
                return switchCell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return nil
        case 1:
            return "login".localized
        default:
            return "transaction".localized
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = .init(hex: "#1C1C1C")
        (view as! UITableViewHeaderFooterView).textLabel?.font = UIFont.systemFont(ofSize: 13)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            switch indexPath.row {
            case 0:
                let ChangeMobileVC = UIStoryboard(name: "ChangeMobileVC", bundle: nil).instantiateViewController(withIdentifier: "ChangeMobileVC") as! ChangeMobileVC
                ChangeMobileVC.mobileNumber = mobileStrFormat(id: memberInfo?.countryCode ?? "", number: memberInfo?.mobileNumber ?? "", type: 1)
                self.navigationController?.show(ChangeMobileVC, sender: nil)
            case 1:
                if (memberInfo?.verifiedEmail != nil){
                    let ChangeEmailVC = UIStoryboard(name: "ChangeEmailVC", bundle: nil).instantiateViewController(withIdentifier: "ChangeEmailVC") as! ChangeEmailVC
                    ChangeEmailVC.userEmail = emailStrFormat(email: memberInfo?.verifiedEmail ?? "")
                    self.navigationController?.show(ChangeEmailVC, sender: nil)
                }else{
                    let BindEmailVC = UIStoryboard(name: "BindEmailVC", bundle: nil).instantiateViewController(withIdentifier: "BindEmailVC") as! BindEmailVC
                    self.navigationController?.show(BindEmailVC, sender: nil)
                }
            case 2:
                if let bound = memberInfo?.authenticatorBound {
                    if !(bound) {
                        let GoogleAuthVC = UIStoryboard(name: "GoogleAuth", bundle: nil).instantiateViewController(withIdentifier: "GoogleAuthVC") as! GoogleAuthVC
                        self.navigationController?.show(GoogleAuthVC, sender: nil)
                    }
                }
            case 4:
                let TwoFactorAuthVC = UIStoryboard(name: "TwoFactorAuth", bundle: nil).instantiateViewController(withIdentifier: "TwoFactorAuthVC") as! TwoFactorAuthVC
                TwoFactorAuthVC.memeberInfo = memberInfo
                self.navigationController?.show(TwoFactorAuthVC, sender: nil)
            default:
                break
            }
        }
        else if (indexPath.section == 1 && indexPath.row == 0) {
            let ChangeLoginPwVC = UIStoryboard(name: "ChangeLoginPw", bundle: nil).instantiateViewController(withIdentifier: "ChangeLoginPwVC") as! ChangeLoginPwVC
            ChangeLoginPwVC.mobileNumber = memberInfo?.mobileNumber
            self.navigationController?.show(ChangeLoginPwVC, sender: nil)
        }
        else if (indexPath.section == 2 && indexPath.row == 0) {
            if let setted = memberInfo?.wasTransactionPasswordSetted {
                if (setted) {
                    let ChangeTransactionPwVC = UIStoryboard(name: "ChangeTransactionPw", bundle: nil).instantiateViewController(withIdentifier: "ChangeTransactionPwVC") as! ChangeTransactionPwVC
                    ChangeTransactionPwVC.mobileNumber = memberInfo?.mobileNumber
                    self.navigationController?.show(ChangeTransactionPwVC, sender: nil)
                }else{
                    let SetTransactionPwVC = UIStoryboard(name: "SetTransactionPw", bundle: nil).instantiateViewController(withIdentifier: "SetTransactionPwVC") as! SetTransactionPwVC
                    SetTransactionPwVC.mobileNumber = memberInfo?.mobileNumber
                    self.navigationController?.show(SetTransactionPwVC, sender: nil)
                }
            }
        }
    }
    
}

extension SecurityVC: UpdateDelegate {
    
    func updateTwoAuthOption(type: Int, enable: Bool) {
        HUD.show(.systemActivity)
        BN.setTwoAuthLogin(type: type, enabled: enable) { statusCode, dataObj, err in
            DispatchQueue.main.async {
                HUD.hide()
            }
            self.setData()
        }
    }
    
    
}

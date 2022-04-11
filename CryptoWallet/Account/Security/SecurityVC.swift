//
//  SecurityVC.swift
//  CryptoWallet
//
//  Created by Fanglin Hsu on 2022/4/8.
//

import UIKit

class SecurityVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var memberInfo: MemberResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Security"
        self.navigationItem.backButtonTitle = ""
        // Do any additional setup after loading the view.
        setData()
        initTV()
    }
    
    func initTV() {
        let nib = UINib(nibName: "SecurityNextCell", bundle: nil)
        let nib1 = UINib(nibName: "SecuritySwitchCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SecurityNextCell")
        tableView.register(nib1, forCellReuseIdentifier: "SecuritySwitchCell")
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        tableView.autoresizesSubviews = false

    }
    
    func setData() {
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
        let switchCell = tableView.dequeueReusableCell(withIdentifier: "SecuritySwitchCell", for: indexPath) as! SecuritySwitchCell
        switch indexPath.section{
        case 0:
            if (indexPath.row == 0) {
                nextCell.titleLab.text = "SMS"
                if memberInfo?.mobileNumber != nil {
                    nextCell.titleImage.image = UIImage(named: "icon_toolbar_state_finish")
                    nextCell.conLab.text = memberInfo?.mobileNumber
                }else{
                    nextCell.titleImage.image = UIImage(named: "icon_toolbar_state_unfinish")
                }
                return nextCell
            }
            else if (indexPath.row == 1) {
                nextCell.titleLab.text = "Email"
                if memberInfo?.verifiedEmail != nil {
                    nextCell.titleImage.image = UIImage(named: "icon_toolbar_state_finish")
                    nextCell.conLab.text = memberInfo?.verifiedEmail
                }else{
                    nextCell.titleImage.image = UIImage(named: "icon_toolbar_state_unfinish")
                }
                return nextCell
            }
            else if (indexPath.row == 2) {
                nextCell.titleLab.text = "Authenticator"
                if let bound = memberInfo?.authenticatorBound {
                    if bound {
                        nextCell.titleImage.image = UIImage(named: "icon_toolbar_state_finish")
                    }else{
                        nextCell.titleImage.image = UIImage(named: "icon_toolbar_state_unfinish")
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
                nextCell.titleLab.text = "Two-Factor Authentication"
                return nextCell
            }
        case 1:
            if (indexPath.row == 0) {
                nextCell.titleImage.isHidden = true
                nextCell.titleLab.text = "Login password"
                nextCell.titleLab.bounds.origin.x = 15
                return nextCell
            }
            if (indexPath.row == 1) {
                switchCell.titleLab.text = "FaceID / Touch ID"
                switchCell.conTextView.text = "Using face ID / Touch Id to unlock the app without password."
                switchCell.changeHeight(height: 80)
                return switchCell
            }
            if (indexPath.row == 2) {
                switchCell.titleLab.text = "Two-Factor Authentication"
                switchCell.conTextView.text = "Using Two-Factor Authentication to strengthen access security by requiring password and Google Authenticator to verify your identity."
                switchCell.changeHeight(height: 100)
                return switchCell
            }
        default:
            if (indexPath.row == 0) {
                nextCell.titleImage.isHidden = true
                nextCell.titleLab.text = "Transaction password"
                nextCell.titleLab.bounds.origin.x = 15
                return nextCell
            }
            if (indexPath.row == 1) {
                switchCell.titleLab.text = "Two-Factor Authentication"
                switchCell.conTextView.text = "Using Two-Factor Authentication to strengthen access security by requiring password and Google Authenticator to verify your identity."
                switchCell.changeHeight(height: 100)
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
            return "Login"
        default:
            return "Transaction"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            switch indexPath.row {
            case 0:
                let ChangeMobileVC = UIStoryboard(name: "ChangeMobileVC", bundle: nil).instantiateViewController(withIdentifier: "ChangeMobileVC") as! ChangeMobileVC
                ChangeMobileVC.mobileNumber = (memberInfo?.mobileNumber)!
                self.navigationController?.show(ChangeMobileVC, sender: nil)
            case 1:
                break
            case 2:
                break
            default:
                break
            }
        }
    }
    
}

//
//  ChangeMobile3VC.swift
//  CryptoWallet
//
//  Created by Fanglin Hsu on 2022/4/12.
//

import UIKit

class FinishVC: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet var BGView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var finishBtn: UIButton!
    
    var changeMobile2VC: ChangeMobile2VC?
    var bindEmailVC: BindEmailVC?
    var changeEmailVC: ChangeEmailVC?
    var googleAuth2VC: GoogleAuth2VC?
    var changeLoginPwVC: ChangeLoginPwVC?
    var setTransactionPwVC: SetTransactionPwVC?
    var changeTransactionPwVC: ChangeTransactionPwVC?
    var kycVerification3VC: KYCVerification3VC?
    var sellingOrderVC: SellingOrderVC?
    var tag: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLabel()
        // Do any additional setup after loading the view.
    }
    
    func setUI() {

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = alertView.bounds
        gradientLayer.colors = [UIColor(hex: "#1E361A")?.cgColor, UIColor(hex: "#071505")?.cgColor]
        //alertView.layer.addSublayer(gradientLayer)
        alertView.layer.insertSublayer(gradientLayer, at: 0)
        
        finishBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: finishBtn.frame.height / 2)
        finishBtn.addTarget(self, action: #selector(finishBtnClick), for: UIControl.Event.touchUpInside)
    }
    
    func setLabel(){
        switch tag {
        case 0:
            self.titleLabel.text = "success_change".localized
            self.contentLabel.text = "cellphone_changed".localized
        case 1:
            self.titleLabel.text = "success_bound".localized
            self.contentLabel.text = "email_bound".localized
        case 2:
            self.titleLabel.text = "success_change".localized
            self.contentLabel.text = "email_changed".localized
        case 3:
            self.titleLabel.text = "success".localized
            self.contentLabel.text = "authenticator_bound".localized
        case 4:
            self.titleLabel.text = "success_change".localized
            self.contentLabel.text = "success_login_password_changed".localized
        case 5:
            self.titleLabel.text = "success".localized
            self.contentLabel.text = "transaction_pwd_setting".localized
        case 6:
            self.titleLabel.text = "success_change".localized
            self.contentLabel.text = "success_transaction_password_change".localized
        case 7:
            self.titleLabel.text = "success_send".localized
            self.contentLabel.text = "account_verification_send_text".localized
        case 8:
            self.titleLabel.text = "You already rejected this transaction"
        case 9:
            self.titleLabel.text = "success_order".localized
        default:
            break
        }
        
    }

    @objc func finishBtnClick() {
        
        self.dismiss(animated: true, completion: nil)
        switch tag {
        case 0:
            let arr = changeMobile2VC?.navigationController?.viewControllers
            changeMobile2VC?.navigationController?.popToViewController(arr![1], animated: true)
        case 1:
            let arr = bindEmailVC?.navigationController?.viewControllers
            bindEmailVC?.navigationController?.popToViewController(arr![1], animated: true)
        case 2:
            let arr = changeEmailVC?.navigationController?.viewControllers
            changeEmailVC?.navigationController?.popToViewController(arr![1], animated: true)
        case 3:
            let arr = googleAuth2VC?.navigationController?.viewControllers
            googleAuth2VC?.navigationController?.popToViewController(arr![1], animated: true)
        case 4:
            loginout()
        case 5:
            let arr = setTransactionPwVC?.navigationController?.viewControllers
            setTransactionPwVC?.navigationController?.popToViewController(arr![1], animated: true)
        case 6:
            let arr = changeTransactionPwVC?.navigationController?.viewControllers
            changeTransactionPwVC?.navigationController?.popToViewController(arr![1], animated: true)
        case 7:
            let arr = kycVerification3VC?.navigationController?.viewControllers
            kycVerification3VC?.navigationController?.popToViewController(arr![0], animated: true)
        case 8:
            let arr = sellingOrderVC?.navigationController?.viewControllers
            sellingOrderVC?.navigationController?.popToViewController(arr![0], animated: true)
        case 9:
            let arr = sellingOrderVC?.navigationController?.viewControllers
            sellingOrderVC?.navigationController?.popToViewController(arr![0], animated: true)
        default:
            break
        }
        
    }

}

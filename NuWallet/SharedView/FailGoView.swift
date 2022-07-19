//
//  FailGoView.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/7/13.
//

import UIKit

class FailGoView: UIView {
    static let failGoView = FailGoView()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var goBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var superVC: UIViewController?
    var type = Int()
    var kycStatus = Int()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        Bundle.main.loadNibNamed("FailGoView", owner: self)
        commitInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commitInit() {
        parentView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        parentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = alertView.bounds
        gradientLayer.colors = [UIColor(hex: "#1E361A")?.cgColor, UIColor(hex: "#071505")?.cgColor]
        alertView.layer.insertSublayer(gradientLayer, at: 0)
        
        goBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: goBtn.frame.height / 2)
        goBtn.addTarget(self, action: #selector(goVC), for: .touchUpInside)
        
        cancelBtn.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
    }
    
    func showMe(type: Int, status: Int, vc: UIViewController?) {
        self.type = type
        self.kycStatus = status
        self.superVC = vc
        switch type {
        case 0:
            errorLabel.text = "member_level_hint".localized
            goBtn.setTitle("go_kyc_btn".localized, for: .normal)
            cancelBtn.isHidden = false
        case 1:
            errorLabel.text = "withdraw_prohibit".localized
            goBtn.setTitle("yes".localized, for: .normal)
            cancelBtn.isHidden = true
        case 2:
            errorLabel.text = "set_transaction_password_hint".localized
            goBtn.setTitle("go_set_transaction_pwd_btn".localized, for: .normal)
            cancelBtn.isHidden = false
        case 3:
            errorLabel.text = "not_support_withdraw".localized
            goBtn.setTitle("yes".localized, for: .normal)
            cancelBtn.isHidden = true
        default:
            break
        }
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(parentView)
    }
    
    @objc func goVC() {
        parentView.removeFromSuperview()
        switch type {
        case 0:
            switch kycStatus {
            case 0:
                let KYCTermsVC = UIStoryboard(name: "KYC", bundle: nil).instantiateViewController(withIdentifier: "KYCTermsVC")
                superVC?.navigationController?.show(KYCTermsVC, sender: nil)
            case 1:
                let KYCVerifyingVC = UIStoryboard(name: "KYCStatus", bundle: nil).instantiateViewController(withIdentifier: "KYCVerifyingVC")
                superVC?.navigationController?.show(KYCVerifyingVC, sender: nil)
            case 2:
                let KYCPassVC = UIStoryboard(name: "KYCStatus", bundle: nil).instantiateViewController(withIdentifier: "KYCPassVC")
                superVC?.navigationController?.show(KYCPassVC, sender: nil)
            case 3:
                let KYCVerifyFailVC = UIStoryboard(name: "KYCStatus", bundle: nil).instantiateViewController(withIdentifier: "KYCVerifyFailVC") as! KYCVerifyFailVC
                KYCVerifyFailVC.status = 3
                superVC?.navigationController?.show(KYCVerifyFailVC, sender: nil)
            case 4:
                let KYCVerifyFailVC = UIStoryboard(name: "KYCStatus", bundle: nil).instantiateViewController(withIdentifier: "KYCVerifyFailVC") as! KYCVerifyFailVC
                KYCVerifyFailVC.status = 4
                superVC?.navigationController?.show(KYCVerifyFailVC, sender: nil)
            default:
                break
            }
        case 1:
            break
        case 2:
            let KYCTermsVC = UIStoryboard(name: "SetTransactionPw", bundle: nil).instantiateViewController(withIdentifier: "SetTransactionPwVC")
            superVC?.navigationController?.show(KYCTermsVC, sender: nil)
        case 3:
            break
        default:
            break
        }
    }
    
    @objc func cancelClick() {
        
        parentView.removeFromSuperview()
    }

}

//
//  KYCTermsVC.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/15.
//

import UIKit

class KYCTermsVC: UIViewController{
    @IBOutlet weak var policyTwoBtn: UIButton!
    @IBOutlet weak var policyThreeBtn: UIButton!
    
    @IBOutlet var checkBtns: [UIButton]!
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    var isCanNext = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "account_verification".localized
        self.navigationItem.backButtonTitle = ""
        setButton()
        setUI()
    }
    
    func setButton() {
        for btn in checkBtns {
            btn.setBackgroundImage(UIImage(named: "button_main_check1b"), for: .normal)
            btn.setBackgroundImage(UIImage(named: "button_main_check2"), for: .selected)
            btn.addTarget(self, action: #selector(checkBtnClick(_:)), for: .touchUpInside)
        }
        
        self.nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.nextBtn.frame.height / 2)
        nextBtn.addTarget(self, action: #selector(nextBtnClick), for: UIControl.Event.touchUpInside)
    }
    
    func setUI() {
        policyTwoBtn.addTarget(self, action: #selector(openUrl(_:)), for: UIControl.Event.touchUpInside)
        policyTwoBtn.tag = 0
        let yourAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.init(hex: "#1F892B") as Any, .underlineStyle: NSUnderlineStyle.single.rawValue]
        policyTwoBtn.setAttributedTitle(NSAttributedString(string: "account_verification_statement_one_paragraph_two".localized, attributes: yourAttributes), for: .normal)
        
        policyThreeBtn.addTarget(self, action: #selector(openUrl(_:)), for: UIControl.Event.touchUpInside)
        policyThreeBtn.tag = 1
        policyThreeBtn.setAttributedTitle(NSAttributedString(string: "account_verification_statement_one_paragraph_three".localized, attributes: yourAttributes), for: .normal)
    }
    
    @objc func openUrl (_ btn: UIButton) {
        if btn.tag == 0 {
            openUrlStr(urlStr: "https://jpeaststorage.blob.core.windows.net/nuwallet-public/terms_of_service.html")
        }else{
            openUrlStr(urlStr: "https://jpeaststorage.blob.core.windows.net/nuwallet-public/privacy_policy.html")
        }
    }
    
    @objc func checkBtnClick (_ btn: UIButton) {
        btn.isUserInteractionEnabled = false
        if (btn.isSelected) {
            btn.isSelected = false
        }else{
            btn.isSelected = true
        }
        
        judgeCanNext()
        
        if (isCanNext) {
            self.nextBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.nextBtn.frame.height / 2)
        } else {
            self.nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.nextBtn.frame.height / 2)
        }
        btn.isUserInteractionEnabled = true
    }
    
    func judgeCanNext() {
        isCanNext = true
        nextLabel.isHidden = true
        for btn in checkBtns {
            if !(btn.isSelected) {
                isCanNext = false
                nextLabel.isHidden = false
                break
            }
        }
    }
    
    @objc func nextBtnClick() {
        judgeCanNext()
        if (isCanNext) {
            let KYCVerificationVC = UIStoryboard(name: "KYC", bundle: nil).instantiateViewController(withIdentifier: "KYCVerificationVC") as! KYCVerificationVC
            self.navigationController?.show(KYCVerificationVC, sender: nil)
        }

    }
    

}

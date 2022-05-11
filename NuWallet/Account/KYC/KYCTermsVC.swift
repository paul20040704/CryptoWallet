//
//  KYCTermsVC.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/15.
//

import UIKit

class KYCTermsVC: UIViewController{
    
    @IBOutlet var checkBtns: [UIButton]!
    @IBOutlet weak var nextBtn: UIButton!
    
    var isCanNext = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "account_verification".localized
        self.navigationItem.backButtonTitle = ""
        setButton()
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
    
    @objc func checkBtnClick (_ btn: UIButton) {
        btn.isUserInteractionEnabled = false
        if (btn.isSelected) {
            btn.isSelected = false
        }else{
            btn.isSelected = true
        }
        
        isCanNext = true
        for btn in checkBtns {
            if !(btn.isSelected) {
                isCanNext = false
                break
            }
        }
        
        if (isCanNext) {
            self.nextBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.nextBtn.frame.height / 2)
        } else {
            self.nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.nextBtn.frame.height / 2)
        }
        btn.isUserInteractionEnabled = true
    }
    
    @objc func nextBtnClick() {
        
        if (isCanNext) {
            let KYCVerificationVC = UIStoryboard(name: "KYC", bundle: nil).instantiateViewController(withIdentifier: "KYCVerificationVC") as! KYCVerificationVC
            self.navigationController?.show(KYCVerificationVC, sender: nil)
        }

    }
    

}

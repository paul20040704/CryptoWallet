//
//  GoogleAuth2VC.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/13.
//

import UIKit
import PKHUD

class GoogleAuth2VC: UIViewController {

    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    
    var isCanNext = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "authenticator".localized
        setUI()
        // Do any additional setup after loading the view.
    }
    
    func setUI() {
        
        codeTextField.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "authenticator_verification_code".localized, placeholderColorHex: "393939")
        codeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
        nextBtn.addTarget(self, action: #selector(nextBtnClick), for: UIControl.Event.touchUpInside)
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        codeTextField.judgeRemind()
        var isVerCodeFilled = false
        if let verCode = self.codeTextField.text {
            if (verCode.count > 0) {
                isVerCodeFilled = true
            }
        }
        if (isVerCodeFilled) {
            isCanNext = true
            self.nextBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.nextBtn.frame.height / 2)
        } else {
            isCanNext = false
            self.nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.nextBtn.frame.height / 2)
        }
        
    }
    
    @objc func nextBtnClick() {
        if (isCanNext) {
            HUD.show(.systemActivity)
            BN.bindAuthenticator(verificationCode: self.codeTextField.text ?? "") { statusCode, dataObj, err in
                if (statusCode == 200) {
                    HUD.hide()
                    let FinishVC = UIStoryboard(name: "FinishVC", bundle: nil).instantiateViewController(withIdentifier: "FinishVC") as! FinishVC
                    FinishVC.googleAuth2VC = self
                    FinishVC.tag = 3
                    FinishVC.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
                    self.present(FinishVC, animated: true, completion: nil)
                }else{
                    HUD.hide()
                    FailView.failView.showMe(error: err?.exception ?? "Bind Authenticator Fail.")
                }
            }
        }
    }


}

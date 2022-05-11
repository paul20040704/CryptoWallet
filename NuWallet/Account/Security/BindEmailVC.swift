//
//  BindEmailVC.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/12.
//

import UIKit
import PKHUD

class BindEmailVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var smsTextField: UITextField!
    @IBOutlet weak var smsBtn: UIButton!
   
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    var timer: Timer?
    var counter: Int = 0
    var isCanNext = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "bind_email".localized
        setUI()
    }

    func setUI() {
        
        emailTextField.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "email_placeholder".localized, placeholderColorHex: "393939")
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        smsBtn.setTitle("send_btn".localized, for: UIControl.State.normal)
        smsBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        smsBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: smsBtn.frame.height / 2)
        smsBtn.addTarget(self, action: #selector(sendBtnClick(_:)), for: UIControl.Event.touchUpInside)
        
        smsTextField.resetCustom(cornerRadius: nil, paddingLeft: 15, paddingRight: 15, placeholderText: "verification_code_placeholder".localized, placeholderColorHex: "393939")
        smsTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
        nextBtn.addTarget(self, action: #selector(nextBtnClick), for: UIControl.Event.touchUpInside)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        judgeCanNext()
    }
    
    @objc func sendBtnClick(_ btn: UIButton) {
        
        if (timer == nil) {
            BN.sendVerificationCode(countryId: "", phoneNumber: "", email: self.emailTextField.text ?? "", verificationMethod: 1, verificationType: 6) { statusCode, dataObj, err in
                if (statusCode == 200) {
                    
                    self.counter = 120
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDownHandler), userInfo: nil, repeats: true)
                    self.bottomLabel.text = "sms_verification_code_hint_text_paragraph_one".localized +  "\(self.emailTextField.text ?? "your email"). " + "verification_code_placeholder".localized
                }else{
                    self.bottomLabel.text = "Sned verification code Fail."
                }
            }
        }

    }
    
    @objc func countDownHandler() {
        counter = counter - 1
        if (counter <= 0) {
            bottomLabel.text = "sms_verification_code_hint".localized
            smsBtn.setTitle("send_btn", for: UIControl.State.normal)
            smsBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
            smsBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: smsBtn.frame.height / 2)
            timer?.invalidate()
            timer = nil
        } else {
            smsBtn.setTitle("(\(counter)s)", for: UIControl.State.normal)
            smsBtn.setTitleColor(UIColor.init(hex: "FFFF79"), for: UIControl.State.normal)
            smsBtn.setBackgroundImage(nil, for: UIControl.State.normal)
        }
    }
    
    func validateEmail(email: String) -> Bool {
            if email.count == 0 {
                return false
            }
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailTest.evaluate(with: email)
        }
    
    func judgeCanNext() {
        emailTextField.judgeRemind()
        smsTextField.judgeRemind()
        var isEmailCorrect = false
        if let email = self.emailTextField.text {
            if (email.count > 0) {
                isEmailCorrect = true
            }
        }
        
        var isSmsCodeFilled = false
        if let smsCode = self.smsTextField.text {
            if (smsCode.count > 0) {
                isSmsCodeFilled = true
            }
        }
        
        if (isEmailCorrect && isSmsCodeFilled) {
            isCanNext = true
            self.nextBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.nextBtn.frame.height / 2)
        } else {
            isCanNext = false
            self.nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.nextBtn.frame.height / 2)
        }
        
    }
    
    @objc func nextBtnClick() {
        judgeCanNext()
        if isCanNext {
            if (validateEmail(email: self.emailTextField.text ?? "")) {
                HUD.show(.systemActivity)
                BN.bindEmail(email: self.emailTextField.text ?? "", verificationCode: self.smsTextField.text ?? "") { statusCode, dataObj, err in
                    if (statusCode == 200) {
                        BN.getMember { statusCode, dataObj, err in
                            HUD.hide()
                            let FinishVC = UIStoryboard(name: "FinishVC", bundle: nil).instantiateViewController(withIdentifier: "FinishVC") as! FinishVC
                            FinishVC.bindEmailVC = self
                            FinishVC.tag = 1
                            self.present(FinishVC, animated: true, completion: nil)
                        }
                    }else{
                        HUD.hide()
                        FailView.failView.showMe(error: err?.exception ?? "Bind Email Fail.")
                    }
                }
            }else{
                self.bottomLabel.text = "Email could not be verified."
            }
        }
    }

}

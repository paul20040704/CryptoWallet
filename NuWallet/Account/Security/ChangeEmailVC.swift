//
//  ChangeEmailVC.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/13.
//

import UIKit
import PKHUD

class ChangeEmailVC: UIViewController {
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var smsTextField: UITextField!
    @IBOutlet weak var smsBtn: UIButton!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var newEmailTextField: UITextField!
    @IBOutlet weak var newSmsTextField: UITextField!
    @IBOutlet weak var newSmsBtn: UIButton!
    @IBOutlet weak var newBottomLabel: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    var timer: Timer?
    var counter: Int = 0
    var timer1: Timer?
    var counter1: Int = 0
    var isCanNext = false
    var userEmail: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "change_email".localized
        setUI()
    }
    

    func setUI() {
        emailLabel.text = "  \(userEmail ?? "")"
        
        smsTextField.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "verification_code_placeholder".localized, placeholderColorHex: "393939")
        smsTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        smsBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: smsBtn.frame.height / 2)
        smsBtn.tag = 0
        smsBtn.addTarget(self, action: #selector(sendBtnClick(_:)), for: UIControl.Event.touchUpInside)
        
        newEmailTextField.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "new_email_placeholder".localized, placeholderColorHex: "393939")
        newEmailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        newSmsTextField.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "verification_code_placeholder".localized, placeholderColorHex: "393939")
        newSmsTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        newSmsBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: smsBtn.frame.height / 2)
        newSmsBtn.tag = 1
        newSmsBtn.addTarget(self, action: #selector(sendBtnClick(_:)), for: UIControl.Event.touchUpInside)
        
        nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
        nextBtn.addTarget(self, action: #selector(nextBtnClick), for: UIControl.Event.touchUpInside)
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        judgeCanNext()
    }
    
    @objc func sendBtnClick(_ btn: UIButton) {
        if (btn.tag == 0) {
            if (timer == nil) {
                BN.getVerificationCode(verificationMethod: 1, verificationType: 7) { statusCode, dataObj, err in
                    if (statusCode == 200) {
                        self.counter = 120
                        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDownHandler), userInfo: nil, repeats: true)
                        self.bottomLabel.text = "sms_verification_code_hint_text_paragraph_one".localized +  "\(self.emailLabel.text ?? "your email"). " + "verification_code_placeholder".localized
                    }else{
                        self.bottomLabel.text = "Send verification code fail."
                    }
                }
            }
        }else{
            if (timer1 == nil) {
                BN.sendVerificationCode(countryId: "", phoneNumber: "", email: self.newEmailTextField.text ?? "", verificationMethod: 1, verificationType: 7) { statusCode, dataObj, err in
                    
                    if (statusCode == 200) {
                        
                        self.counter1 = 120
                        self.timer1 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDownHandler1), userInfo: nil, repeats: true)
                        self.newBottomLabel.text = "sms_verification_code_hint_text_paragraph_one".localized +  "\(self.newEmailTextField.text ?? "your email"). " + "verification_code_placeholder".localized
                    }else{
                        self.newBottomLabel.text = "Send verification code fail."
                    }
                }
            }
        }
    }
    
    @objc func countDownHandler() {
        counter = counter - 1
        if (counter <= 0) {
            bottomLabel.text = "sms_verification_code_hint".localized
            smsBtn.setTitle("send_btn".localized, for: UIControl.State.normal)
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
    
    @objc func countDownHandler1() {
        counter1 = counter1 - 1
        if (counter1 <= 0) {
            newBottomLabel.text = "sms_verification_code_hint".localized
            newSmsBtn.setTitle("send_btn".localized, for: UIControl.State.normal)
            newSmsBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
            newSmsBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: newSmsBtn.frame.height / 2)
            timer1?.invalidate()
            timer1 = nil
        } else {
            newSmsBtn.setTitle("(\(counter1)s)", for: UIControl.State.normal)
            newSmsBtn.setTitleColor(UIColor.init(hex: "FFFF79"), for: UIControl.State.normal)
            newSmsBtn.setBackgroundImage(nil, for: UIControl.State.normal)
        }
    }
    
    func judgeCanNext() {
        smsTextField.judgeRemind()
        newEmailTextField.judgeRemind()
        newSmsTextField.judgeRemind()
        
        var isSmsCodeFilled = false
        if let smsCode = self.smsTextField.text {
            if (smsCode.count > 0) {
                isSmsCodeFilled = true
            }
        }
        
        var isEmailFilled = false
        if let email = self.newEmailTextField.text {
            if (email.count > 0) {
                isEmailFilled = true
            }
        }
        
        var isNewCodeFilled = false
        if let newCode = self.newSmsTextField.text {
            if (newCode.count > 0) {
                isNewCodeFilled = true
            }
        }
        
        if (isSmsCodeFilled && isEmailFilled && isNewCodeFilled) {
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
            if (validateEmail(email: self.newEmailTextField.text ?? "")) {
                HUD.show(.systemActivity)
                BN.changeEmail(email: self.newEmailTextField.text ?? "", verificationCode: self.smsTextField.text ?? "", newVerificationCode: self.newSmsTextField.text ?? "") { statusCode, obj, err in
                    if (statusCode == 200) {
                        BN.getMember { statusCode, dataObj, err in
                            HUD.hide()
                            let FinishVC = UIStoryboard(name: "FinishVC", bundle: nil).instantiateViewController(withIdentifier: "FinishVC") as! FinishVC
                            FinishVC.changeEmailVC = self
                            FinishVC.tag = 2
                            self.present(FinishVC, animated: true, completion: nil)
                        }
                    }else{
                        HUD.hide()
                        FailView.failView.showMe(error: err?.exception ?? "Change email fail.")
                    }
                }
            }else{
                FailView.failView.showMe(error: "New email address could not be verified.")
            }
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
    
    
    
    
    

}

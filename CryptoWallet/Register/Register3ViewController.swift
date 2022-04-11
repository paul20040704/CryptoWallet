//
//  Register3ViewController.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/15.
//

import UIKit

class Register3ViewController: UIViewController {
    
    @IBOutlet weak var topDescLabel: UILabel!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordVisibleBtn: UIButton!
    @IBOutlet weak var repasswordView: UIView!
    @IBOutlet weak var repasswordTextField: UITextField!
    @IBOutlet weak var repasswordVisibleBtn: UIButton!
    @IBOutlet weak var referralTextField: UITextField!
    
    @IBOutlet weak var smsView: UIView!
    @IBOutlet weak var smsTextField: UITextField!
    @IBOutlet weak var smsBtn: UIButton!
    @IBOutlet weak var bottomDescLabel: UILabel!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    var timer: Timer?
    var counter: Int = 0
    
    public var countryCode: CountryCodeItem?
    public var phoneNumber: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordView.layer.cornerRadius = 10
        passwordView.clipsToBounds = true
        
        passwordTextField.resetCustom(cornerRadius: nil, paddingLeft: 15, paddingRight: 15, placeholderText: "Please set your password", placeholderColorHex: "393939")
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        repasswordView.layer.cornerRadius = 10
        repasswordView.clipsToBounds = true
        
        repasswordTextField.resetCustom(cornerRadius: nil, paddingLeft: 15, paddingRight: 15, placeholderText: "Please set your password again", placeholderColorHex: "393939")
        repasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        referralTextField.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "Please input referral code", placeholderColorHex: "393939")
        
        passwordVisibleBtn.addTarget(self, action: #selector(passwordVisibleBtnClick(_:)), for: UIControl.Event.touchUpInside)
        repasswordVisibleBtn.addTarget(self, action: #selector(repasswordVisibleBtnClick(_:)), for: UIControl.Event.touchUpInside)
        
        smsView.layer.cornerRadius = 10
        smsView.clipsToBounds = true
        
        smsTextField.resetCustom(cornerRadius: nil, paddingLeft: 15, paddingRight: 15, placeholderText: "Please click the send button first", placeholderColorHex: "393939")
        
        smsTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        smsBtn.setTitle("Send", for: UIControl.State.normal)
        smsBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        smsBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: smsBtn.frame.height / 2)
        smsBtn.addTarget(self, action: #selector(sendBtnClick(_:)), for: UIControl.Event.touchUpInside)
        
        bottomDescLabel.text = "Click send button to received SMS verification code."
        
        nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
        nextBtn.addTarget(self, action: #selector(nextBtnClick), for: UIControl.Event.touchUpInside)
    
    }
    
    @objc func passwordVisibleBtnClick(_ btn: UIButton) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        passwordVisibleBtn.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        if (passwordTextField.isSecureTextEntry) {
            passwordVisibleBtn.setImage(UIImage(named: "icon_eye_close"), for: UIControl.State.normal)
        } else {
            passwordVisibleBtn.setImage(UIImage(named: "icon_eye_open"), for: UIControl.State.normal)
        }
    }
    
    @objc func repasswordVisibleBtnClick(_ btn: UIButton) {
        repasswordTextField.isSecureTextEntry = !repasswordTextField.isSecureTextEntry
        repasswordVisibleBtn.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        if (repasswordTextField.isSecureTextEntry) {
            repasswordVisibleBtn.setImage(UIImage(named: "icon_eye_close"), for: UIControl.State.normal)
        } else {
            repasswordVisibleBtn.setImage(UIImage(named: "icon_eye_open"), for: UIControl.State.normal)
        }
    }
    
    @objc func sendBtnClick(_ btn: UIButton) {
        if (timer == nil) {
            
            sendVerificationCode(countryId: self.countryCode?.countryId ?? "", phoneNumber: self.phoneNumber ?? phoneNumber, email: nil, verificationMethod: 2, verificationType: 1) { statusCode, dataObj, err in
                
                if (statusCode == 200) {
                    
                    self.counter = 120
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDownHandler), userInfo: nil, repeats: true)
                    self.bottomDescLabel.text = "Verification code has been sent to \(self.phoneNumber ?? "your phone number"). Please input SMS verification code."
                }
                
            }
        }
    }
    
    @objc func countDownHandler() {
        counter = counter - 1
        if (counter <= 0) {
            bottomDescLabel.text = "Click send button to received SMS verification code."
            smsBtn.setTitle("Send", for: UIControl.State.normal)
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        var isPasswordCorrect = true // 正則檢查
        var isRepasswordSame = false
        if let password = self.passwordTextField.text {
            if let repassword = self.repasswordTextField.text {
                if (password == repassword) {
                    isRepasswordSame = true
                }
            }
        }
        var isSmsCodeFilled = false
        if let smsCode = self.smsTextField.text {
            if (smsCode.count > 0) {
                isSmsCodeFilled = true
            }
        }
        
        if (isPasswordCorrect && isRepasswordSame && isSmsCodeFilled) {
            nextBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
        } else {
            nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
        }
    }
    
    @objc func nextBtnClick() {
        
        var isPasswordCorrect = true // 正則檢查
        var isRepasswordSame = false
        if let password = self.passwordTextField.text {
            if let repassword = self.repasswordTextField.text {
                if (password == repassword) {
                    isRepasswordSame = true
                }
            }
        }
        var isSmsCodeFilled = false
        if let smsCode = self.smsTextField.text {
            if (smsCode.count > 0) {
                isSmsCodeFilled = true
            }
        }
        
        if (isPasswordCorrect && isRepasswordSame && isSmsCodeFilled) {
            
            registMember(countryId: self.countryCode?.countryId ?? "", phoneNumber: self.phoneNumber ?? "", verificationCode: self.smsTextField.text ?? "", password: self.passwordTextField.text ?? "", repassword: self.repasswordTextField.text ?? "", invitationCode: self.referralTextField.text ?? "") { statusCode, dataObj, err in
                
                if (statusCode == 200) {
                    
                    let register4ViewController = UIStoryboard(name: "Register4", bundle: nil).instantiateViewController(withIdentifier: "register4ViewController")
                    self.navigationController?.pushViewController(register4ViewController, animated: true)
                    
                }
                
            }
        }
        
    }
    
}

//
//  ForgotViewController.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/15.
//

import UIKit
import PKHUD

class ForgotViewController: UIViewController {
    
    @IBOutlet weak var areaView: UIView!
    @IBOutlet weak var areaLabel: PaddingLabel!
    @IBOutlet weak var areaBtn: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var smsTF: UITextField!
    @IBOutlet weak var smsBtn: UIButton!
    @IBOutlet weak var smsLabel: UILabel!
    @IBOutlet weak var newPwTF: UITextField!
    @IBOutlet weak var newPwBtn: UIButton!
    @IBOutlet weak var confirmPwTF: UITextField!
    @IBOutlet weak var confirmPwBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    var countryCodesResponse: CountryCodesResponse?
    var countryCodesSelectIndex: Int = -1
    public var countryCode: CountryCodeItem?
    
    var timer: Timer?
    var counter: Int = 0
    var isCanNext = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
    }
    
    func setUI() {
        areaView.layer.cornerRadius = 10
        areaView.clipsToBounds = true
        
        areaBtn.setBackgroundVerticalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nil)
        downloadCountryCodesAndInitAreaBtn()
        
        phoneTextField.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "cellphone_placeholder".localized, placeholderColorHex: "393939")
        phoneTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        smsTF.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "verification_code_placeholder".localized, placeholderColorHex: "393939")
        smsTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        smsBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: smsBtn.frame.height / 2)
        smsBtn.addTarget(self, action: #selector(sendBtnClick(_:)), for: UIControl.Event.touchUpInside)
        
        newPwTF.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "pwd_set_new_placeholder".localized, placeholderColorHex: "393939")
        newPwTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        newPwBtn.tag = 0
        newPwBtn.addTarget(self, action: #selector(passwordVisibleBtnClick(_:)), for: UIControl.Event.touchUpInside)
        
        confirmPwTF.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "pwd_set_new_confirm_placeholder".localized, placeholderColorHex: "393939")
        confirmPwTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        confirmPwBtn.tag = 1
        confirmPwBtn.addTarget(self, action: #selector(passwordVisibleBtnClick(_:)), for: UIControl.Event.touchUpInside)
        
        nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
        nextBtn.addTarget(self, action: #selector(nextBtnClick), for: UIControl.Event.touchUpInside)
    }
    
    func downloadCountryCodesAndInitAreaBtn() {
        
        getCountryCodes(headers: nil) { statusCode, dataObj, err in
            if (statusCode == 200) {
                self.countryCodesResponse = dataObj
            }else{
                FailView.failView.showMe(error: err?.exception ?? "network_fail".localized)
            }
            self.areaBtn.addTarget(self, action: #selector(self.showSelectAreaDialog), for: UIControl.Event.touchUpInside)
        }
    }
    
    @objc func showSelectAreaDialog() {
        
        var areaNames: [String] = [String]()
        if let countryCodeItems = countryCodesResponse?.data {
            for countryCode in countryCodeItems {
                if let displayName = countryCode.displayName {
                    if let countryCode = countryCode.countryCode {
                        areaNames.append("\(displayName) ( \(countryCode) )")
                    }
                }
            }
        }else{
            downloadCountryCodesAndInitAreaBtn()
        }
        
        let selectVC = UIStoryboard(name: "SelectVC", bundle: nil).instantiateViewController(withIdentifier: "SelectVC") as! SelectVC
        selectVC.page = 6
        selectVC.selectArr = areaNames
        selectVC.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        selectVC.delegate = self
        self.present(selectVC, animated: true, completion: nil)
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        judgeCanNext()
    }
    
    func judgeCanNext() {
        areaLabel.judgeRemind()
        phoneTextField.judgeRemind()
        newPwTF.judgePassword()
        confirmPwTF.judgePassword()
        smsTF.judgeRemind()
        
        var isAreaFilled = false
        if let label = areaLabel.text, let number = phoneTextField.text {
            if (label.count > 0 && number.count > 0) {
                isAreaFilled = true
            }
        }
        
        var isPasswordCorrect = false
        if (isPassword(text: newPwTF.text ?? "") && isPassword(text: confirmPwTF.text ?? "") && (newPwTF.text == confirmPwTF.text)) {
            isPasswordCorrect = true
        }
        
        var isSmsCodeFilled = false
        if let smsCode = self.smsTF.text {
            if (smsCode.count > 0) {
                isSmsCodeFilled = true
            }
        }
        
        if (isPasswordCorrect && isSmsCodeFilled && isAreaFilled) {
            isCanNext = true
            self.nextBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.nextBtn.frame.height / 2)
        } else {
            isCanNext = false
            self.nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.nextBtn.frame.height / 2)
        }
        
    }
    
    @objc func sendBtnClick(_ btn: UIButton) {
        btn.isUserInteractionEnabled = false
        if (timer == nil) {
            BN.sendVerificationCode(countryId: countryCode?.countryId ?? "" , phoneNumber: phoneTextField.text ?? "", email: nil, verificationMethod: 2, verificationType: 3) { statusCode, dataObj, err in
                btn.isUserInteractionEnabled = true
                if (statusCode == 200) {
                    self.counter = 120
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDownHandler), userInfo: nil, repeats: true)
                    self.smsLabel.text = "sms_verification_code_hint_text_paragraph_one".localized +  " \(self.phoneTextField.text ?? "your phone number"). " + "verification_code_placeholder".localized
                }else{
                    self.smsLabel.text = err?.exception ?? "send_fail".localized
                }
            }
        }
        
    }
    
    @objc func countDownHandler() {
        counter = counter - 1
        if (counter <= 0) {
            smsLabel.text = "sms_verification_code_hint".localized
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
    
    @objc func passwordVisibleBtnClick(_ btn: UIButton) {
        switch btn.tag {
        case 0:
            newPwTF.isSecureTextEntry = !newPwTF.isSecureTextEntry
            newPwBtn.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
            if (newPwTF.isSecureTextEntry) {
                newPwBtn.setImage(UIImage(named: "icon_eye_close"), for: UIControl.State.normal)
            } else {
                newPwBtn.setImage(UIImage(named: "icon_eye_open"), for: UIControl.State.normal)
            }
        default:
            confirmPwTF.isSecureTextEntry = !confirmPwTF.isSecureTextEntry
            confirmPwBtn.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
            if (confirmPwTF.isSecureTextEntry) {
                confirmPwBtn.setImage(UIImage(named: "icon_eye_close"), for: UIControl.State.normal)
            } else {
                confirmPwBtn.setImage(UIImage(named: "icon_eye_open"), for: UIControl.State.normal)
            }
        }
    }
    
    @objc func nextBtnClick() {
        judgeCanNext()
        if isCanNext {
            HUD.show(.systemActivity)
            BN.resetPassword(countryId: countryCode?.countryId ?? "", mobileNumber: phoneTextField.text ?? "", verificationCode: smsTF.text ?? "", password: newPwTF.text ?? "", confirmPassword: confirmPwTF.text ?? "") { statusCode, dataObj, err in
                HUD.hide()
                if (statusCode == 200) {
                    let forgot2ViewController = UIStoryboard(name: "Forgot2", bundle: nil).instantiateViewController(withIdentifier: "Forgot2ViewController") as! Forgot2ViewController
                    self.navigationController?.pushViewController(forgot2ViewController, animated: true)
                }else{
                    FailView.failView.showMe(error: err?.exception ?? "Fail to set new password")
                }
            }
        }
    }

}


extension ForgotViewController: SelectDelegate {
    
    func updateOption(tag: Int, condition: String) {
        self.areaLabel.text = condition
        if let countryCodes = self.countryCodesResponse?.data {
            self.countryCode = countryCodes[tag]
        }
    }
    
}

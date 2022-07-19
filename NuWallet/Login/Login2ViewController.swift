//
//  Login2ViewController.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/15.
//

import UIKit
import PKHUD

class Login2ViewController: UIViewController {
    
    @IBOutlet weak var topDescLabel: UILabel!
    @IBOutlet weak var smsView: UIView!
    @IBOutlet weak var smsTextField: UITextField!
    @IBOutlet weak var smsBtn: UIButton!
    @IBOutlet weak var bottomDescLabel: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    var timer: Timer?
    var counter: Int = 0
    var countryId: String?
    var mobileNumber: String?
    var password: String?
    var twoAuthResponse: TwoAuthResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        smsView.layer.cornerRadius = 10
        smsView.clipsToBounds = true
        
        smsTextField.resetCustom(cornerRadius: nil, paddingLeft: 15, paddingRight: 15, placeholderText: "verification_code_placeholder".localized, placeholderColorHex: "393939")
        smsTextField.addTarget(self, action: #selector(smsTextFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        smsBtn.setTitle("send_btn".localized, for: UIControl.State.normal)
        smsBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        smsBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: smsBtn.frame.height / 2)
        smsBtn.addTarget(self, action: #selector(sendBtnClick(_:)), for: UIControl.Event.touchUpInside)
        
        nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
        nextBtn.addTarget(self, action: #selector(nextBtnClick), for: UIControl.Event.touchUpInside)
        
        
    }
    
    @objc func sendBtnClick(_ btn: UIButton) {
        btn.isUserInteractionEnabled = false
        if (timer == nil) {
            BN.sendLoginVerCode(countryId: countryId ?? "", mobileNumber: mobileNumber ?? "") { statusCode, dataObj, err in
                btn.isUserInteractionEnabled = true
                if (statusCode == 200) {
                    self.counter = 120
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDownHandler), userInfo: nil, repeats: true)
                    self.bottomDescLabel.text = "sms_verification_code_hint_text_paragraph_one".localized +  " \(self.mobileNumber ?? "your phone number"). " + "verification_code_placeholder".localized
                }else{
                    self.bottomDescLabel.text = err?.exception ?? "send_fail".localized
                }
            }
        }
    }
    
    @objc func countDownHandler() {
        counter = counter - 1
        if (counter <= 0) {
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

    @objc func smsTextFieldDidChange(_ textField: UITextField) {
        if let num = textField.text?.count {
            if (num > 0) {
                nextBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
            } else {
                nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
            }
        }
    }
    
    @objc func nextBtnClick() {
        if let num = smsTextField.text?.count {
            if (num > 0) {
                HUD.show(.systemActivity)
                BN.firstGetToken(countryId: countryId ?? "", mobileNumber: mobileNumber ?? "", password: password ?? "", verificationCode: smsTextField.text ?? "", verificationMethod: twoAuthResponse?.verificationMethod ?? 0) { statusCode, dataObj, err in
                    if (statusCode == 200) {
                        if let data = dataObj {
                            US.updateToken(token: data)
                        }
                        HUD.hide()
                        goMain()
                    }else{
                        HUD.hide()
                        FailView.failView.showMe(error: err?.exception ?? "Fail to login")
                    }
                }
            }
        }
    }
    

}

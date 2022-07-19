//
//  ChangeTransactionPwVC.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/15.
//

import UIKit
import PKHUD

class ChangeTransactionPwVC: UIViewController {
    
    @IBOutlet weak var currentTranPwTF: UITextField!
    @IBOutlet weak var currentTranPwBtn: UIButton!
    @IBOutlet weak var smsTF: UITextField!
    @IBOutlet weak var smsBtn: UIButton!
    @IBOutlet weak var smsLabel: UILabel!
    @IBOutlet weak var newTranPwTF: UITextField!
    @IBOutlet weak var newTranPwBtn: UIButton!
    @IBOutlet weak var confirmPwTF: UITextField!
    @IBOutlet weak var confirmPwBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    var timer: Timer?
    var counter: Int = 0
    var mobileNumber: String?
    var isCanNext = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "change_transaction_password".localized
        // Do any additional setup after loading the view.
        setUI()
    }
    

    func setUI() {
        
        currentTranPwTF.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "current_transaction_pwd_placeholder".localized, placeholderColorHex: "393939")
        currentTranPwTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        currentTranPwBtn.tag = 0
        currentTranPwBtn.addTarget(self, action: #selector(passwordVisibleBtnClick(_:)), for: UIControl.Event.touchUpInside)
        
        smsTF.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "verification_code_placeholder".localized, placeholderColorHex: "393939")
        smsTF.tag = 1
        smsTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        smsBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: smsBtn.frame.height / 2)
        smsBtn.addTarget(self, action: #selector(sendBtnClick(_:)), for: UIControl.Event.touchUpInside)
        
        newTranPwTF.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "new_transaction_pwd_placeholder".localized, placeholderColorHex: "393939")
        newTranPwTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        newTranPwBtn.tag = 1
        newTranPwBtn.addTarget(self, action: #selector(passwordVisibleBtnClick(_:)), for: UIControl.Event.touchUpInside)
        
        confirmPwTF.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "confirm_new_transaction_pwd_placeholder".localized, placeholderColorHex: "393939")
        confirmPwTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        confirmPwBtn.tag = 2
        confirmPwBtn.addTarget(self, action: #selector(passwordVisibleBtnClick(_:)), for: UIControl.Event.touchUpInside)
        
        nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
        nextBtn.addTarget(self, action: #selector(nextBtnClick), for: UIControl.Event.touchUpInside)
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        judgeCanNext()
    }
    
    func judgeCanNext() {
        
        currentTranPwTF.judgePassword()
        newTranPwTF.judgePassword()
        confirmPwTF.judgePassword()
        smsTF.judgeRemind()
        
        var isPasswordCorrect = false
        if (isPassword(text: currentTranPwTF.text ?? "") && isPassword(text: newTranPwTF.text ?? "") && isPassword(text: confirmPwTF.text ?? "")) {
            isPasswordCorrect = true
        }
        
        var isSmsCodeFilled = false
        if let smsCode = self.smsTF.text {
            if (smsCode.count > 0) {
                isSmsCodeFilled = true
            }
        }
        
        if (isPasswordCorrect && isSmsCodeFilled) {
            isCanNext = true
            self.nextBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.nextBtn.frame.height / 2)
        } else {
            isCanNext = false
            self.nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.nextBtn.frame.height / 2)
        }
    }

    @objc func passwordVisibleBtnClick(_ btn: UIButton) {
        switch btn.tag {
        case 0:
            currentTranPwTF.isSecureTextEntry = !currentTranPwTF.isSecureTextEntry
            currentTranPwBtn.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
            if (currentTranPwTF.isSecureTextEntry) {
                currentTranPwBtn.setImage(UIImage(named: "icon_eye_close"), for: UIControl.State.normal)
            } else {
                currentTranPwBtn.setImage(UIImage(named: "icon_eye_open"), for: UIControl.State.normal)
            }
        case 1:
            newTranPwTF.isSecureTextEntry = !newTranPwTF.isSecureTextEntry
            newTranPwBtn.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
            if (newTranPwTF.isSecureTextEntry) {
                newTranPwBtn.setImage(UIImage(named: "icon_eye_close"), for: UIControl.State.normal)
            } else {
                newTranPwBtn.setImage(UIImage(named: "icon_eye_open"), for: UIControl.State.normal)
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
    
    @objc func sendBtnClick(_ btn: UIButton) {
        btn.isUserInteractionEnabled = false
        if (timer == nil) {
            BN.getVerificationCode(verificationMethod: 2, verificationType: 9) { statusCode, dataObj, err in
                btn.isUserInteractionEnabled = true
                if (statusCode == 200) {
                    self.counter = 120
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDownHandler), userInfo: nil, repeats: true)
                    self.smsLabel.text = "sms_verification_code_hint_text_paragraph_one".localized +  " \(self.mobileNumber ?? "your phone number").  " + "verification_code_placeholder".localized
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
    
    @objc func nextBtnClick() {
        judgeCanNext()
        if isCanNext {
            HUD.show(.systemActivity)
            BN.changeTranPassword(verificationCode: smsTF.text ?? "", currentPassword: currentTranPwTF.text ?? "", newPassword: newTranPwTF.text ?? "", newConfirmPassword: confirmPwTF.text ?? "") { statusCode, dataObj, err in
                if (statusCode == 200) {
                    HUD.hide()
                    let FinishVC = UIStoryboard(name: "FinishVC", bundle: nil).instantiateViewController(withIdentifier: "FinishVC") as! FinishVC
                    FinishVC.changeTransactionPwVC = self
                    FinishVC.tag = 6
                    FinishVC.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
                    self.present(FinishVC, animated: true, completion: nil)
                }else{
                    HUD.hide()
                    FailView.failView.showMe(error: err?.exception ?? "Change login password api fail.")
                }
            }
        }
    }
    
    
}

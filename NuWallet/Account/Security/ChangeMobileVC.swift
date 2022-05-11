//
//  ChangeMobileVC.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/11.
//

import UIKit

class ChangeMobileVC: UIViewController {
    @IBOutlet weak var mobileText: UILabel!
    @IBOutlet weak var smsTextField: UITextField!
    @IBOutlet weak var smsBtn: UIButton!
    @IBOutlet weak var bottomLab: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    var timer: Timer?
    var counter: Int = 0
    
    public var mobileNumber: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "change_phone_number".localized
        self.navigationItem.backButtonTitle = ""
        setUI()
        
    }
    
    func setUI() {
        smsBtn.setTitle("Send", for: UIControl.State.normal)
        smsBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        smsBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: smsBtn.frame.height / 2)
        smsBtn.addTarget(self, action: #selector(sendBtnClick(_:)), for: UIControl.Event.touchUpInside)
        
        nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
        nextBtn.addTarget(self, action: #selector(nextBtnClick), for: .touchUpInside)
        
        mobileText.text = "  +\(mobileNumber)"
        
        smsTextField.resetCustom(cornerRadius: nil, paddingLeft: 15, paddingRight: 15, placeholderText: "verification_code_placeholder".localized, placeholderColorHex: "393939")
        smsTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func sendBtnClick(_ btn: UIButton) {
        if (timer == nil) {
            BN.getVerificationCode(verificationMethod: 2, verificationType: 4) { statusCode, dataObj, err in
                if (statusCode == 200) {
                    
                    self.counter = 120
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDownHandler), userInfo: nil, repeats: true)
                    self.bottomLab.text = "sms_verification_code_hint_text_paragraph_one".localized +  "\(self.mobileNumber ?? "your phone number"). " + "verification_code_placeholder".localized
                }
            }
        }
    }
    
    @objc func countDownHandler() {
        counter = counter - 1
        if (counter <= 0) {
            bottomLab.text = "verification_code_placeholder".localized
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        textField.judgeRemind()

        var isSmsCodeFilled = false
        if let smsCode = self.smsTextField.text {
            if (smsCode.count > 0) {
                isSmsCodeFilled = true
            }
        }
        
        if (isSmsCodeFilled) {
            nextBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
        } else {
            nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
        }
    }
    
    @objc func nextBtnClick() {
        
        smsTextField.judgeRemind()
        
        var isSmsCodeFilled = false
        if let smsCode = self.smsTextField.text {
            if (smsCode.count > 0) {
                isSmsCodeFilled = true
            }
        }
        
        if (isSmsCodeFilled) {
            let ChangeMobile2VC = UIStoryboard(name: "ChangeMobile2VC", bundle: nil).instantiateViewController(withIdentifier: "ChangeMobile2VC") as! ChangeMobile2VC
            ChangeMobile2VC.oldVerCode = self.smsTextField.text!
            self.navigationController?.show(ChangeMobile2VC, sender: nil)
        }
    }
    
    
    

}

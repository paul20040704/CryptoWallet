//
//  MainSmsVC.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/22.
//

import UIKit

class MainSmsVC: UIViewController {

    @IBOutlet weak var smsTF: UITextField!
    @IBOutlet weak var smsBtn: UIButton!
    @IBOutlet weak var smsLabel: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    var timer: Timer?
    var counter: Int = 0
    var mobileNumber = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "BTM"
        // Do any additional setup after loading the view.
    }
    
    func setUI() {
        smsTF.resetCustom(cornerRadius: nil, paddingLeft: 15, paddingRight: 15, placeholderText: "Please click the send button first", placeholderColorHex: "393939")
        smsTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        smsBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        smsBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: smsBtn.frame.height / 2)
        smsBtn.addTarget(self, action: #selector(sendBtnClick(_:)), for: UIControl.Event.touchUpInside)
        
        nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
        nextBtn.addTarget(self, action: #selector(nextBtnClick), for: .touchUpInside)
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        smsTF.judgeRemind()

        var isSmsCodeFilled = false
        if let smsCode = self.smsTF.text {
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
    
    @objc func sendBtnClick(_ btn: UIButton) {
        if (timer == nil) {
            BN.getVerificationCode(verificationMethod: 2, verificationType: 4) { statusCode, dataObj, err in
                if (statusCode == 200) {
                    
                    self.counter = 120
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDownHandler), userInfo: nil, repeats: true)
                    self.smsLabel.text = "Verification code has been sent to \(self.mobileNumber ?? "your phone number"). Please input SMS verification code."
                }
            }
        }
    }
    
    @objc func countDownHandler() {
        counter = counter - 1
        if (counter <= 0) {
            smsLabel.text = "Click send button to received SMS verification code."
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
    
    @objc func nextBtnClick() {
        
    }
    

}

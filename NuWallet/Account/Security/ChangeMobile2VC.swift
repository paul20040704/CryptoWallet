//
//  ChangeMobileVC2.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/11.
//

import UIKit
import PKHUD

class ChangeMobile2VC: UIViewController {
    
    @IBOutlet weak var areaContentView: UIView!
    @IBOutlet weak var areaLabel: PaddingLabel!
    @IBOutlet weak var areaBtn: UIButton!
    @IBOutlet weak var phoneNumberText: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var smsTextField: UITextField!
    @IBOutlet weak var smsBtn: UIButton!
    @IBOutlet weak var bottomLabel: UILabel!
    
    var oldVerCode: String = ""
    var timer: Timer?
    var counter: Int = 0
    
    var countryCode: CountryCodeItem?
    var countryCodesResponse: CountryCodesResponse?
    var countryCodesSelectIndex: Int = -1
    
    var isCanNext = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "change_phone_number".localized
        setUI()
    }
    
    func setUI() {
        areaContentView.layer.cornerRadius = 10
        areaContentView.clipsToBounds = true
        
        areaBtn.setBackgroundVerticalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nil)
        downloadCountryCodesAndInitAreaBtn()
        
        phoneNumberText.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "cellphone_placeholder".localized, placeholderColorHex: "393939")
        
        phoneNumberText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        smsBtn.setTitle("send_btn".localized , for: UIControl.State.normal)
        smsBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        smsBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: smsBtn.frame.height / 2)
        smsBtn.addTarget(self, action: #selector(sendBtnClick(_:)), for: UIControl.Event.touchUpInside)
        
        smsTextField.resetCustom(cornerRadius: nil, paddingLeft: 15, paddingRight: 15, placeholderText: "verification_code_placeholder".localized, placeholderColorHex: "393939")
        smsTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
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
    
    @objc func sendBtnClick(_ btn: UIButton) {
        btn.isUserInteractionEnabled = false
        if (timer == nil) {
            BN.sendVerificationCode(countryId: self.countryCode?.countryId ?? "", phoneNumber: self.phoneNumberText.text ?? "", email: nil, verificationMethod: 2, verificationType: 4) { statusCode, dataObj, err in
                btn.isUserInteractionEnabled = true
                if (statusCode == 200) {
                    self.counter = 120
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDownHandler), userInfo: nil, repeats: true)
                    self.bottomLabel.text = "sms_verification_code_hint_text_paragraph_one".localized +  " \(self.phoneNumberText.text ?? "your phone number"). " + "verification_code_placeholder".localized
                }else{
                    self.bottomLabel.text = err?.exception ?? "send_fail".localized
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
    
    func judgeCanNext() {
        areaLabel.judgeRemind()
        phoneNumberText.judgeRemind()
        smsTextField.judgeRemind()
        
        var isAreaFilled = false
        if let label = areaLabel.text, let number = phoneNumberText.text {
            if (label.count > 0 && number.count > 0) {
                isAreaFilled = true
            }
        }
        
        var isSmsCodeFilled = false
        if let smsCode = self.smsTextField.text {
            if (smsCode.count > 0) {
                isSmsCodeFilled = true
            }
        }
        if (isAreaFilled && isSmsCodeFilled) {
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
            BN.changeMobile(countryId: self.countryCode?.countryId ?? "", mobileNumber: self.phoneNumberText.text ?? "", verificationCode: oldVerCode, newVerificationCode: self.smsTextField.text ?? "") { statusCode, dataObj, err in
                if (statusCode == 200) {
                    HUD.hide()
                    let FinishVC = UIStoryboard(name: "FinishVC", bundle: nil).instantiateViewController(withIdentifier: "FinishVC") as! FinishVC
                    FinishVC.changeMobile2VC = self
                    FinishVC.tag = 0
                    FinishVC.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
                    self.present(FinishVC, animated: true, completion: nil)
                }else{
                    FailView.failView.showMe(error: err?.exception ?? "Change mobile number fail.")
                    HUD.hide()
                }
            }
        }
        
    }
    
    
    
    
    
}



extension ChangeMobile2VC: SelectDelegate {
    
    func updateOption(tag: Int, condition: String) {
        self.areaLabel.text = condition
        if let countryCodes = self.countryCodesResponse?.data {
            self.countryCode = countryCodes[tag]
        }
    }
    
}

//
//  ChangeMobileVC2.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/11.
//

import UIKit

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
    
    var countryCodesResponse: CountryCodesResponse?
    var countryCodesSelectIndex: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Change mobile phone number"
        setUI()
    }
    
    func setUI() {
        areaContentView.layer.cornerRadius = 10
        areaContentView.clipsToBounds = true
        
        areaBtn.setBackgroundVerticalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nil)
        downloadCountryCodesAndInitAreaBtn()
        
        phoneNumberText.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "Please input cell phone number", placeholderColorHex: "393939")
        
        phoneNumberText.addTarget(self, action: #selector(phoneNumberTextFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
        nextBtn.addTarget(self, action: #selector(nextBtnClick), for: UIControl.Event.touchUpInside)
    }

    func downloadCountryCodesAndInitAreaBtn() {
        
        getCountryCodes(headers: nil) { statusCode, dataObj, err in
            if (statusCode == 200) {
                self.countryCodesResponse = dataObj
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
        }
    }
    
    @objc func phoneNumberTextFieldDidChange(_ textField: UITextField) {
        
        var isCountryCodeSelectd = false
        if (self.countryCodesSelectIndex >= 0) {
            isCountryCodeSelectd = true
        }
        var isPhoneNumberCorrect = false
        if let phoneNumber = self.phoneNumberText.text {
            if (phoneNumber.hasPrefix("0")) {
                let finalPhone = phoneNumber.dropFirst()
                if (finalPhone.count > 0) {
                    isPhoneNumberCorrect = true
                }
            } else {
                if (phoneNumber.count > 0) {
                    isPhoneNumberCorrect = true
                }
            }
        }
        var isSmsCodeFilled = false
        if let smsCode = self.smsTextField.text {
            if (smsCode.count > 0) {
                isSmsCodeFilled = true
            }
        }
        if (isCountryCodeSelectd && isPhoneNumberCorrect && isSmsCodeFilled) {
            self.nextBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.nextBtn.frame.height / 2)
        } else {
            self.nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.nextBtn.frame.height / 2)
        }
        
    }
    
    
    
    
    
    
}

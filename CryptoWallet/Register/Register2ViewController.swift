//
//  Register2ViewController.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/14.
//

import UIKit

class Register2ViewController: UIViewController {
    
    @IBOutlet weak var areaContentView: UIView!
    @IBOutlet weak var areaLabel: PaddingLabel!
    @IBOutlet weak var areaBtn: UIButton!
    @IBOutlet weak var phoneNumberText: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    
    var countryCodesResponse: CountryCodesResponse?
    var countryCodesSelectIndex: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        
        let alert = UIAlertController(title: "Choose your area code", message: "", preferredStyle: .actionSheet)
        for i in 0..<areaNames.count {
            let itemAction = UIAlertAction(title: areaNames[i], style: .default) { action in
                self.areaLabel.text = action.title
                self.countryCodesSelectIndex = i
                
                
                
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
                if (isCountryCodeSelectd && isPhoneNumberCorrect) {
                    self.nextBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.nextBtn.frame.height / 2)
                } else {
                    self.nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.nextBtn.frame.height / 2)
                }
                
                
            }
            alert.addAction(itemAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { action in
            
        }
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
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
        if (isCountryCodeSelectd && isPhoneNumberCorrect) {
            self.nextBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.nextBtn.frame.height / 2)
        } else {
            self.nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.nextBtn.frame.height / 2)
        }
        
    }
    
    @objc func nextBtnClick() {
        
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
        if (isCountryCodeSelectd && isPhoneNumberCorrect) {
            if let register3ViewController = UIStoryboard(name: "Register3", bundle: nil).instantiateViewController(withIdentifier: "register3ViewController") as? Register3ViewController {
                
                if let countryCodes = self.countryCodesResponse?.data {
                    register3ViewController.countryCode = countryCodes[self.countryCodesSelectIndex]
                }
                
                if let phoneNumber = self.phoneNumberText.text {
                    if (phoneNumber.hasPrefix("0")) {
                        let finalPhone = phoneNumber.dropFirst()
                        if (finalPhone.count > 0) {
                            register3ViewController.phoneNumber = String(finalPhone)
                        }
                    } else {
                        if (phoneNumber.count > 0) {
                            register3ViewController.phoneNumber = phoneNumber
                        }
                    }
                }
                
                register3ViewController.phoneNumber = self.phoneNumberText.text
                
                self.navigationController?.pushViewController(register3ViewController, animated: true)
                
            }
        }
        
    }

}

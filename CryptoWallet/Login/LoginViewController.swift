//
//  LoginViewController.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/15.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var areaView: UIView!
    @IBOutlet weak var areaLabel: PaddingLabel!
    @IBOutlet weak var areaBtn: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordVisibleBtn: UIButton!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    var countryCodesResponse: CountryCodesResponse?
    var countryCode: CountryCodeItem?
    var countryCodesSelectIndex: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        areaView.layer.cornerRadius = 10
        areaView.clipsToBounds = true
        
        areaBtn.setBackgroundVerticalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nil)
        downloadCountryCodesAndInitAreaBtn()
        
        phoneTextField.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "Please input cell phone number", placeholderColorHex: "393939")
        
        phoneTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        
        passwordView.layer.cornerRadius = 10
        passwordView.clipsToBounds = true
        
        passwordTextField.resetCustom(cornerRadius: nil, paddingLeft: 15, paddingRight: 15, placeholderText: "Please set your password", placeholderColorHex: "393939")
        
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        
        passwordVisibleBtn.addTarget(self, action: #selector(passwordVisibleBtnClick(_:)), for: UIControl.Event.touchUpInside)
        
        forgotPasswordBtn.addTarget(self, action: #selector(forgotPasswordBtnClick), for: UIControl.Event.touchUpInside)
        
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
                if let countryCodes = self.countryCodesResponse?.data {
                    self.countryCode = countryCodes[self.countryCodesSelectIndex]
                }
            }
            alert.addAction(itemAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    @objc func textFieldDidChange() {
        if let num = phoneTextField.text?.count {
            if (num > 0) {
                if let num2 = passwordTextField.text?.count {
                    if (num2 > 0) {
                        nextBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
                    } else {
                        nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
                    }
                } else {
                    nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
                }
            } else {
                nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
            }
        } else {
            nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
        }
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
    
    @objc func forgotPasswordBtnClick() {
        let forgotViewController = UIStoryboard(name: "Forgot", bundle: nil).instantiateViewController(withIdentifier: "forgotViewController")
        self.navigationController?.pushViewController(forgotViewController, animated: true)
    }
    
    @objc func nextBtnClick() {
        if let num = phoneTextField.text?.count {
            if (num > 0) {
                if let num2 = passwordTextField.text?.count {
                    if (num2 > 0) {
                        BN.loginTwoFactorAuth(countryId: self.countryCode?.countryId ?? "", mobileNumber: self.phoneTextField.text ?? "") { statusCode, dataObj, err in
                            if (statusCode == 200) {
                                if let isTwoAuth = dataObj?.loginTwoFactorAuthEnabled {
                                    if (isTwoAuth){
                                        let login2ViewController = UIStoryboard(name: "Login2", bundle: nil).instantiateViewController(withIdentifier: "login2ViewController")
                                        self.navigationController?.pushViewController(login2ViewController, animated: true)
                                    }else{
                                        BN.getToken(countryId: self.countryCode?.countryId ?? "", mobileNumber: self.phoneTextField.text ?? "", password: self.passwordTextField.text ?? "", verificationCode: "", verificationMethod: 0) { statusCode, dataObj, err in
                                                if (statusCode == 200){
                                                    if let data = dataObj {
                                                        US.updateToken(token: data)
                                                    }
                                                    getToken { success, token in
                                                        if (success) {
                                                            BN.getMember(token: token) { statusCode, dataObj, err in
                                                                if (statusCode == 200) {
                                                                    if let data = dataObj {
                                                                        US.updateMember(info: data)
                                                                        goMain()
                                                                    }
                                                                }
                                                            }
                                                        }else{
                                                            //退回登入頁
                                                            
                                                        }
                                                    }
                                                }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

}

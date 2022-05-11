//
//  LoginViewController.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/15.
//

import UIKit
import PKHUD

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
    
    var isCanNext = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadCountryCodesAndInitAreaBtn()
        setUI()
    }
    
    func setUI() {
        self.navigationItem.backButtonTitle = ""
        self.navigationItem.title = "login".localized
        
        areaBtn.setBackgroundVerticalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nil)
        
        phoneTextField.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "cellphone_placeholder".localized, placeholderColorHex: "393939")
        phoneTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        
        passwordTextField.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "pwd_placeholder".localized, placeholderColorHex: "393939")
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        
        passwordVisibleBtn.addTarget(self, action: #selector(passwordVisibleBtnClick(_:)), for: UIControl.Event.touchUpInside)
        
        forgotPasswordBtn.addTarget(self, action: #selector(forgotPasswordBtnClick), for: UIControl.Event.touchUpInside)
        let yourAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white, .underlineStyle: NSUnderlineStyle.single.rawValue]
        forgotPasswordBtn.setAttributedTitle(NSAttributedString(string: "forget_pwd".localized, attributes: yourAttributes), for: .normal)
        
        nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
        nextBtn.setTitle("next_btn".localized, for: .normal)
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
        
        let selectVC = UIStoryboard(name: "SelectVC", bundle: nil).instantiateViewController(withIdentifier: "SelectVC") as! SelectVC
        selectVC.page = 6
        selectVC.selectArr = areaNames
        selectVC.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        selectVC.delegate = self
        self.present(selectVC, animated: true, completion: nil)
        
    }
    
    @objc func textFieldDidChange() {
        judgeCanNext()
    }
    
    func judgeCanNext() {
        areaLabel.judgeRemind()
        phoneTextField.judgeRemind()
        passwordTextField.judgeRemind()
        
        var isFilled = false
        if let label = areaLabel.text, let number = phoneTextField.text, let password = passwordTextField.text {
            if (label.count > 0 && number.count > 0 && password.count > 0) {
                isFilled = true
            }
        }
        
        if (isFilled) {
            isCanNext = true
            nextBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
        }else{
            isCanNext = false
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
        let forgotViewController = UIStoryboard(name: "Forgot", bundle: nil).instantiateViewController(withIdentifier: "ForgotViewController")
        self.navigationController?.pushViewController(forgotViewController, animated: true)
    }
    
    @objc func nextBtnClick() {
        judgeCanNext()
        if (isCanNext) {
            HUD.show(.systemActivity)
            BN.loginTwoFactorAuth(countryId: countryCode?.countryId ?? "", mobileNumber: phoneTextField.text ?? "") { statusCode, dataObj, err in
                if let isTwoAuth = dataObj?.loginTwoFactorAuthEnabled {
                    if (isTwoAuth) {
                        HUD.hide()
                        let login2ViewController = UIStoryboard(name: "Login2", bundle: nil).instantiateViewController(withIdentifier: "login2ViewController") as! Login2ViewController
                        login2ViewController.countryId = self.countryCode?.countryId ?? ""
                        login2ViewController.mobileNumber = self.phoneTextField.text ?? ""
                        login2ViewController.password = self.passwordTextField.text ?? ""
                        login2ViewController.twoAuthResponse = dataObj
                        self.navigationController?.pushViewController(login2ViewController, animated: true)
                    }else{
                        self.login()
                    }
                }else{
                    self.login()
                }
            }
        }
    }
    
    func login() {
        BN.firstGetToken(countryId: countryCode?.countryId ?? "", mobileNumber: phoneTextField.text ?? "", password: passwordTextField.text ?? "", verificationCode: "", verificationMethod: 0) { statusCode, dataObj, err in
            if (statusCode == 200) {
                if let data = dataObj {
                    US.updateToken(token: data)
                }
                BN.getMember { statusCode, dataObj, err in
                    HUD.hide()
                    goMain()
                }
            }else{
                HUD.hide()
                FailView.failView.showMe(error: err?.exception ?? "Fail to login")
            }
        }
    }
    
    

}

extension LoginViewController: SelectDelegate {
    
    func updateOption(tag: Int, condition: String) {
        self.areaLabel.text = condition
        if let countryCodes = self.countryCodesResponse?.data {
            self.countryCode = countryCodes[tag]
        }
    }
    
    
}

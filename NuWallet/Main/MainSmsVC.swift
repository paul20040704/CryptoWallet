//
//  MainSmsVC.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/22.
//

import UIKit
import PKHUD

class MainSmsVC: UIViewController {

    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var passwordBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    var orderId = ""
    var isCanNext = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "BTM"
        // Do any additional setup after loading the view.
        setUI()
    }
    
    func setUI() {
        
        passwordTF.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "setting_transaction_pwd_palceholder".localized, placeholderColorHex: "393939")
        passwordTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        passwordBtn.addTarget(self, action: #selector(passwordVisibleBtnClick(_:)), for: UIControl.Event.touchUpInside)
        
        nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
        nextBtn.addTarget(self, action: #selector(nextBtnClick), for: .touchUpInside)
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        judgeCanNext()

    }
    
    func judgeCanNext() {
        
        passwordTF.judgeRemind()
        
        isCanNext = false
        if let text = passwordTF.text {
            if (text.count > 0) {
                isCanNext = true
            }
        }
        
        if (isCanNext) {
            self.nextBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.nextBtn.frame.height / 2)
        } else {
            self.nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.nextBtn.frame.height / 2)
        }
        
    }
    
    @objc func passwordVisibleBtnClick(_ btn: UIButton) {
        passwordTF.isSecureTextEntry = !passwordTF.isSecureTextEntry
        passwordBtn.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        if (passwordTF.isSecureTextEntry) {
            passwordBtn.setImage(UIImage(named: "icon_eye_close"), for: UIControl.State.normal)
        } else {
            passwordBtn.setImage(UIImage(named: "icon_eye_open"), for: UIControl.State.normal)
        }
    }
    
   
    
    
    @objc func nextBtnClick() {
        if isCanNext {
            HUD.show(.systemActivity)
            BN.putSellingOrder(orderId: orderId, transactionPassword: passwordTF.text ?? "") { statusCode, dataObj, err in
                HUD.hide()
                if (statusCode == 200) {
                    let FinishVC = UIStoryboard(name: "FinishVC", bundle: nil).instantiateViewController(withIdentifier: "FinishVC") as! FinishVC
                    FinishVC.mainSmsVC = self
                    FinishVC.tag = 9
                    FinishVC.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
                    self.present(FinishVC, animated: true, completion: nil)
                }else{
                    FailView.failView.showMe(error: err?.exception ?? "Fail To Selling Order.")
                }
            }
        }
    }
    

}

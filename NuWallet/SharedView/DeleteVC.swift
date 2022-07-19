//
//  DeleteVC.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/7/18.
//

import UIKit
import PKHUD

class DeleteVC: UIViewController {
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalPresentationStyle = .custom
        setUI()
    }
    

    func setUI() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = alertView.bounds
        gradientLayer.colors = [UIColor(hex: "#8D1D1D")?.cgColor, UIColor(hex: "#1D0606")?.cgColor]
        alertView.layer.insertSublayer(gradientLayer, at: 0)
        
        passwordTF.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "current_login_password_placeholder".localized, placeholderColorHex: "393939")
        cancelBtn.addTarget(self, action: #selector(leave), for: .touchUpInside)
        deleteBtn.addTarget(self, action: #selector(deleteClick), for: .touchUpInside)
    }
    
    @objc func deleteClick() {
        if let text = passwordTF.text {
//            if text.count > 0 {
                HUD.show(.systemActivity)
                BN.postDeleteMember(loginPassword: text) { statusCode, dataObj, err in
                    HUD.hide()
                    if (statusCode == 200) {
                        loginout()
                    }else{
                        FailView.failView.showMe(error: err?.exception ?? "")
                    }
                }
//            }else{
//                FailView.failView.showMe(error: "密碼不能為空")
//            }
        }
    }
    
    @objc func leave() {
        self.dismiss(animated: true)
    }
    
}

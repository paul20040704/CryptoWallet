//
//  Forgot3ViewController.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/15.
//

import UIKit

class Forgot3ViewController: UIViewController {
    
    @IBOutlet weak var topDescLabel: UILabel!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordVisibleBtn: UIButton!
    @IBOutlet weak var repasswordView: UIView!
    @IBOutlet weak var repasswordTextField: UITextField!
    @IBOutlet weak var repasswordVisibleBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordView.layer.cornerRadius = 10
        passwordView.clipsToBounds = true
        
        passwordTextField.resetCustom(cornerRadius: nil, paddingLeft: 15, paddingRight: 15, placeholderText: "Please set your password", placeholderColorHex: "393939")
        
        repasswordView.layer.cornerRadius = 10
        repasswordView.clipsToBounds = true
        
        repasswordTextField.resetCustom(cornerRadius: nil, paddingLeft: 15, paddingRight: 15, placeholderText: "Please set your password again", placeholderColorHex: "393939")
        
        passwordVisibleBtn.addTarget(self, action: #selector(passwordVisibleBtnClick(_:)), for: UIControl.Event.touchUpInside)
        repasswordVisibleBtn.addTarget(self, action: #selector(repasswordVisibleBtnClick(_:)), for: UIControl.Event.touchUpInside)
        
        nextBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
        nextBtn.addTarget(self, action: #selector(nextBtnClick), for: UIControl.Event.touchUpInside)
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
    
    @objc func repasswordVisibleBtnClick(_ btn: UIButton) {
        repasswordTextField.isSecureTextEntry = !repasswordTextField.isSecureTextEntry
        repasswordVisibleBtn.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        if (repasswordTextField.isSecureTextEntry) {
            repasswordVisibleBtn.setImage(UIImage(named: "icon_eye_close"), for: UIControl.State.normal)
        } else {
            repasswordVisibleBtn.setImage(UIImage(named: "icon_eye_open"), for: UIControl.State.normal)
        }
    }
    
    @objc func nextBtnClick() {
        let forgot4ViewController = UIStoryboard(name: "Forgot4", bundle: nil).instantiateViewController(withIdentifier: "forgot4ViewController")
        self.navigationController?.pushViewController(forgot4ViewController, animated: true)
    }

}

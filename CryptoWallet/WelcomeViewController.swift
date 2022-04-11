//
//  ViewController.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/10.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var languageBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginBtn.setBackgroundHorizontalGradient("133C18", "0A1D0B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: 2, borderColorHex: "1B7228", cornerRadius: loginBtn.frame.height / 2)
        
        registerBtn.setBackgroundHorizontalGradient("133C18", "0A1D0B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: 2, borderColorHex: "1B7228", cornerRadius: registerBtn.frame.height / 2)
        
        loginBtn.addTarget(self, action: #selector(presentToLogin), for: UIControl.Event.touchUpInside)
        
        registerBtn.addTarget(self, action: #selector(presentToRegister), for: UIControl.Event.touchUpInside)
        
        languageBtn.addTarget(self, action: #selector(showChangeLanguageDialog), for: UIControl.Event.touchUpInside)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc func presentToLogin() {
        
        let loginViewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "loginViewController")
        self.navigationController?.pushViewController(loginViewController, animated: true)
        
    }
    
    @objc func presentToRegister() {
        
        let registerViewController = UIStoryboard(name: "Register", bundle: nil).instantiateViewController(withIdentifier: "registerViewController")
        self.navigationController?.pushViewController(registerViewController, animated: true)
        
    }
    
    @objc func showChangeLanguageDialog() {
        
        let languageNames = ["English", "中文", "日本語"]
        
        let alert = UIAlertController(title: "Choose your language", message: "", preferredStyle: .actionSheet)
        for name in languageNames {
           let itemAction = UIAlertAction(title: name, style: .default) { action in
//              print(action.title)
           }
            alert.addAction(itemAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
    }

}



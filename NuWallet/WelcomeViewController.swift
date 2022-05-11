//
//  ViewController.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/10.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var languageBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        
        loginBtn.setBackgroundHorizontalGradient("133C18", "0A1D0B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: 2, borderColorHex: "1B7228", cornerRadius: loginBtn.frame.height / 2)
        registerBtn.setBackgroundHorizontalGradient("133C18", "0A1D0B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: 2, borderColorHex: "1B7228", cornerRadius: registerBtn.frame.height / 2)
        
        loginBtn.addTarget(self, action: #selector(presentToLogin), for: UIControl.Event.touchUpInside)
        registerBtn.addTarget(self, action: #selector(presentToRegister), for: UIControl.Event.touchUpInside)
        languageBtn.addTarget(self, action: #selector(showChangeLanguageDialog), for: UIControl.Event.touchUpInside)
    
    }
    
    func setUI(){
        self.navigationItem.backButtonTitle = ""
        
        helloLabel.text = "greet".localized
        loginBtn.setTitle("login".localized, for: .normal)
        registerBtn.setTitle("register".localized, for: .normal)
        
        changeLanguageBtn()
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
        
        let languageNames = ["English", "繁體中文", "简体中文", "日本語"]
        
        let selectVC = UIStoryboard(name: "SelectVC", bundle: nil).instantiateViewController(withIdentifier: "SelectVC") as! SelectVC
        selectVC.page = 5
        selectVC.selectArr = languageNames
        selectVC.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        selectVC.delegate = self
        self.present(selectVC, animated: true, completion: nil)
        
    }
    
    func changeLanguageBtn() {
        let lang = UD.string(forKey: "lang") ?? "en"
        switch lang {
        case "en":
            languageBtn.setTitle("English", for: .normal)
        case "zh-Hant":
            languageBtn.setTitle("繁體中文", for: .normal)
        case "zh-Hans":
            languageBtn.setTitle("简体中文", for: .normal)
        default:
            languageBtn.setTitle("日本語", for: .normal)
        }
    }
    
    

}

extension WelcomeViewController: SelectDelegate {
    
    func updateOption(tag: Int, condition: String) {
        
        switch condition {
        case "English":
            UD.set("en", forKey: "lang")
        case "繁體中文":
            UD.set("zh-Hant", forKey: "lang")
        case "简体中文":
            UD.set("zh-Hans", forKey: "lang")
        default:
            UD.set("ja", forKey: "lang")
        }
        self.setUI()
        
    }
    
    
}


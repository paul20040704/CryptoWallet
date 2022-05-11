//
//  TwoFactorAuthVC.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/14.
//

import UIKit
import PKHUD

class TwoFactorAuthVC: UIViewController {
    
    @IBOutlet weak var smsView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var authView: UIView!
    
    @IBOutlet weak var smsImage: UIImageView!
    @IBOutlet weak var emailImage: UIImageView!
    @IBOutlet weak var authImage: UIImageView!
    
    @IBOutlet weak var smsBtn: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var authBtn: UIButton!
    
    var memeberInfo: MemberResponse?
    var select = 0 //0 = Undefined, 1 = Email, 2 = SMS, 3 = GoogleAuthenticator
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "twofa".localized
        setUI()
        // Do any additional setup after loading the view.
    }
    

    func setUI() {
        smsBtn.tag = 2
        smsBtn.addTarget(self, action: #selector(btnClick(_:)), for: UIControl.Event.touchUpInside)
        emailBtn.tag = 1
        emailBtn.addTarget(self, action: #selector(btnClick(_:)), for: UIControl.Event.touchUpInside)
        authBtn.tag = 3
        authBtn.addTarget(self, action: #selector(btnClick(_:)), for: UIControl.Event.touchUpInside)
        
        if memeberInfo?.verifiedEmail == nil {
            emailView.isHidden = true
        }
        if let bound = memeberInfo?.authenticatorBound {
            if !(bound) {
                authView.isHidden = true
            }
        }
        if let type = memeberInfo?.twoFactorAuthType {
            if (type == 0) {
                select = 2
            }else{
                select = type
            }
        }
        changeImage()
    }
    
    @objc func btnClick(_ btn: UIButton) {
        if (btn.tag != select) {
            HUD.show(.systemActivity)
            BN.changeTwoAuth(verificationMethod: btn.tag) { statusCode, dataObj, err in
                if (statusCode == 200) {
                    BN.getMember { statusCode, dataObj, err in
                        HUD.hide()
                        self.select = btn.tag
                        self.changeImage()
                    }
                }else{
                    HUD.hide()
                    FailView.failView.showMe(error: err?.exception ?? "Change authentication fail.")
                }
            }
        }
    }
    
    func changeImage() {
        switch select {
        case 1:
            smsImage.isHidden = true
            emailImage.isHidden = false
            authImage.isHidden = true
        case 3:
            smsImage.isHidden = true
            emailImage.isHidden = true
            authImage.isHidden = false
        default:
            smsImage.isHidden = false
            emailImage.isHidden = true
            authImage.isHidden = true
            
        }
    }

}

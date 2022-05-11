//
//  Forgot4ViewController.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/15.
//

import UIKit

class Forgot2ViewController: UIViewController {
    
    @IBOutlet weak var closeBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        closeBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: closeBtn.frame.height / 2)
        closeBtn.addTarget(self, action: #selector(closeBtnClick), for: UIControl.Event.touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc func closeBtnClick() {
        var targetVC: UIViewController? = nil
        if let viewControllers = self.navigationController?.viewControllers {
            for vc in viewControllers {
                if vc is LoginViewController {
                    targetVC = vc
                    break
                }
            }
        }
        if let targetVC = targetVC {
            self.navigationController?.popToViewController(targetVC, animated: true)
        }
    }

}

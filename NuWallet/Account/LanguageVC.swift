//
//  LanguageVC.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/5/4.
//

import UIKit

class LanguageVC: UIViewController {
    @IBOutlet weak var enBtn: UIButton!
    @IBOutlet weak var hantBtn: UIButton!
    @IBOutlet weak var hansBtn: UIButton!
    @IBOutlet weak var jaBtn: UIButton!
    
    @IBOutlet weak var enImage: UIImageView!
    @IBOutlet weak var hantImage: UIImageView!
    @IBOutlet weak var hansImage: UIImageView!
    @IBOutlet weak var jaImage: UIImageView!
    
    var accountViewController: AccountViewController?
    
    var select = 0 // 0En 1Hant 2Hans 3Ja
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    

    func setUI() {
        self.navigationItem.title = "language".localized
        
        let lang = UD.string(forKey: "lang") ?? "en"
        switch lang {
        case "en":
            select = 0
        case "zh-Hant":
            select = 1
        case "zh-Hans":
            select = 2
        default:
            select = 3
        }
        
        enBtn.addTarget(self, action: #selector(selectClick(_:)), for: .touchUpInside)
        hantBtn.addTarget(self, action: #selector(selectClick(_:)), for: .touchUpInside)
        hansBtn.addTarget(self, action: #selector(selectClick(_:)), for: .touchUpInside)
        jaBtn.addTarget(self, action: #selector(selectClick(_:)), for: .touchUpInside)
        
        changeImage()
    }
    
    @objc func selectClick(_ btn: UIButton) {
        if (btn.tag != select) {
            select = btn.tag
            switch select {
            case 0:
                UD.set("en", forKey: "lang")
            case 1:
                UD.set("zh-Hant", forKey: "lang")
            case 2:
                UD.set("zh-Hans", forKey: "lang")
            default:
                UD.set("ja", forKey: "lang")
            }
            accountViewController?.iAccountTableView.reloadData()
            self.setUI()
            changeImage()
            goMain()
        }
    }
    
    func changeImage() {
        
        enImage.isHidden = true
        hantImage.isHidden = true
        hansImage.isHidden = true
        jaImage.isHidden = true
        switch select {
        case 0:
            enImage.isHidden = false
        case 1:
            hantImage.isHidden = false
        case 2:
            hansImage.isHidden = false
        default:
            jaImage.isHidden = false
        }
        
    }

}

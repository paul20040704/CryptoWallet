//
//  KYCVerifyFailVC.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/21.
//

import UIKit

class KYCVerifyFailVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    var status = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    func setUI() {
        if status == 3 {
            titleLabel.text = "refused".localized
            contentLabel.text = "refused_text".localized
        }else{
            titleLabel.text = "revoked".localized
            contentLabel.text = "revoked_text".localized
        }
        
        nextBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
        nextBtn.addTarget(self, action: #selector(nextClick), for: UIControl.Event.touchUpInside)
        
    }
    
    @objc func nextClick() {
        let arr = self.navigationController?.viewControllers
        let accountVC = arr![0]
        self.navigationController?.popToViewController(accountVC, animated: false)
        let KYCTermsVC = UIStoryboard(name: "KYC", bundle: nil).instantiateViewController(withIdentifier: "KYCTermsVC")
        KYCTermsVC.hidesBottomBarWhenPushed = true
        accountVC.navigationController?.show(KYCTermsVC, sender: nil)
        
    }

}

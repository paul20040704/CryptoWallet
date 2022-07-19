//
//  KYCVerifyFailVC.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/21.
//

import UIKit
import PKHUD

class KYCVerifyFailVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!

    @IBOutlet weak var reasonLabel: UILabel!
    
    @IBOutlet weak var faqView: UIView!
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var nextBtn: UIButton!
    
    var status = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        getReason()
        setTapView()
    }
    
    func setUI() {
        if status == 3 {
            titleLabel.text = "refused".localized
            //contentLabel.text = "refused_text".localized
        }else{
            titleLabel.text = "revoked".localized
            //contentLabel.text = "revoked_text".localized
        }
        
        nextBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
        nextBtn.addTarget(self, action: #selector(nextClick), for: UIControl.Event.touchUpInside)
        
    }
    
    func getReason() {
        HUD.show(.systemActivity)
        BN.getKYCSummary { statusCode, dataObj, err in
            HUD.hide()
            if (statusCode == 200) {
                if let data = dataObj {
                    self.reasonLabel.text = data.reasonsForRejection ?? ""
                    self.setContentLabel(type: data.typeOfRejection ?? 0)
                    //self.setContentLabel(type: 1)
                }
            }
        }
    }
    
    func setTapView() {
        let contactTap = UITapGestureRecognizer(target: self, action: #selector(contact))
        let faqTap = UITapGestureRecognizer(target: self, action: #selector(faq))
        contactView.addGestureRecognizer(contactTap)
        faqView.addGestureRecognizer(faqTap)
    }
    
    @objc func contact() {
        let arr = self.navigationController?.viewControllers
        let accountVC = arr![0]
        self.navigationController?.popToViewController(accountVC, animated: false)
        let KYCTermsVC = UIStoryboard(name: "Contact", bundle: nil).instantiateViewController(withIdentifier: "ContactListVC")
        KYCTermsVC.hidesBottomBarWhenPushed = true
        accountVC.navigationController?.show(KYCTermsVC, sender: nil)
    }
    
    @objc func faq() {
        openUrlStr(urlStr: "https://numiner.zendesk.com/hc/en-001/sections/5319628035097-Common")
    }
    
    
    @objc func nextClick() {
        let arr = self.navigationController?.viewControllers
        let accountVC = arr![0]
        self.navigationController?.popToViewController(accountVC, animated: false)
        let KYCTermsVC = UIStoryboard(name: "KYC", bundle: nil).instantiateViewController(withIdentifier: "KYCTermsVC")
        accountVC.navigationController?.show(KYCTermsVC, sender: nil)
        
    }
    
    func setContentLabel(type: Int) {
        switch type {
        case 1:
            self.contentLabel.text = "kyc_document_invalid".localized
        case 2:
            self.contentLabel.text = "kyc_blurry_image".localized
        case 3:
            self.contentLabel.text = "kyc_name_not_match".localized
        case 4:
            self.contentLabel.text = "kyc_number_not_match".localized
        case 5:
            self.contentLabel.text = "kyc_face_not_match".localized
        case 6:
            self.contentLabel.text = "kyc_identiy_verification_failed".localized
        default:
            break
        }
    }

}

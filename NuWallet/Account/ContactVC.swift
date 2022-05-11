//
//  ContactVC.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/5/5.
//

import UIKit

class ContactVC: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var typeLabel: PaddingLabel!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descriptionTV: UITextView!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    

    func setUI() {
        self.navigationItem.title = "contact_us".localized
        
        emailTF.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "passport_idcard_number_placeholder".localized, placeholderColorHex: "393939")
        emailTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        selectBtn.setBackgroundVerticalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nil)
        selectBtn.addTarget(self, action: #selector(selectBtnClick(_:)), for: .touchUpInside)
        
        titleTF.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "passport_idcard_number_placeholder".localized, placeholderColorHex: "393939")
        titleTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        descriptionTV.placeholder = "Please input your questions and our support staff will reply as soon as posible."
        
        uploadBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.uploadBtn.frame.height / 2)
        uploadBtn.addTarget(self, action: #selector(uploadBtnClick(_:)), for: UIControl.Event.touchUpInside)
        
        sendBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.sendBtn.frame.height / 2)
        sendBtn.addTarget(self, action: #selector(nextBtnClick), for: UIControl.Event.touchUpInside)
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
    }

    @objc func selectBtnClick(_ btn: UIButton) {
        
    }

    @objc func uploadBtnClick(_ btn: UIButton) {
        
    }
    
    @objc func nextBtnClick() {
        
    }
    
}

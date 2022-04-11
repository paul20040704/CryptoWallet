//
//  ForgotViewController.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/15.
//

import UIKit

class ForgotViewController: UIViewController {
    
    @IBOutlet weak var areaView: UIView!
    @IBOutlet weak var areaLabel: PaddingLabel!
    @IBOutlet weak var areaBtn: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        areaView.layer.cornerRadius = 10
        areaView.clipsToBounds = true
        
        areaBtn.setBackgroundVerticalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nil)
        areaBtn.addTarget(self, action: #selector(showSelectAreaDialog), for: UIControl.Event.touchUpInside)
        
        phoneTextField.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "Please input cell phone number", placeholderColorHex: "393939")
        
        phoneTextField.addTarget(self, action: #selector(phoneTextFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
        nextBtn.addTarget(self, action: #selector(nextBtnClick), for: UIControl.Event.touchUpInside)
        
    }
    
    @objc func showSelectAreaDialog() {
        
        let areaNames = ["United States (+1)", "China (+86)", "Taiwai (+886)"]
        
        let alert = UIAlertController(title: "Choose your area code", message: "", preferredStyle: .actionSheet)
        for area in areaNames {
           let itemAction = UIAlertAction(title: area, style: .default) { action in
               self.areaLabel.text = action.title
           }
            alert.addAction(itemAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    @objc func phoneTextFieldDidChange(_ textField: UITextField) {
        if let num = textField.text?.count {
            if (num > 0) {
                nextBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
            } else {
                nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
            }
        }
    }
    
    @objc func nextBtnClick() {
        if let num = phoneTextField.text?.count {
            if (num > 0) {
                let forgot2ViewController = UIStoryboard(name: "Forgot2", bundle: nil).instantiateViewController(withIdentifier: "forgot2ViewController")
                self.navigationController?.pushViewController(forgot2ViewController, animated: true)
            }
        }
    }

}

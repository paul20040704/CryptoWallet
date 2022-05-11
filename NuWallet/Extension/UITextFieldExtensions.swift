//
//  UITextFieldExtensions.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/16.
//

import Foundation
import UIKit
extension UITextField {
    func resetCustom(cornerRadius: CGFloat?, paddingLeft: CGFloat?, paddingRight: CGFloat?, placeholderText: String?, placeholderColorHex: String?) {
        
        if let cornerRadius = cornerRadius {
            self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
        }
        
        if let placeholderText = placeholderText {
            if let placeholderColorHex = placeholderColorHex {
                if let color = UIColor.init(hex: placeholderColorHex) {
                    self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: color])
                } else {
                    self.placeholder = placeholderText
                }
            } else {
                self.placeholder = placeholderText
            }
        }
        
        if let paddingLeft = paddingLeft {
            self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: paddingLeft, height: self.frame.size.height))
            self.leftViewMode = UITextField.ViewMode.always
        }
        
        if let paddingRight = paddingRight {
            self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: paddingRight, height: self.frame.size.height))
            self.rightViewMode = UITextField.ViewMode.always
        }
        
    }
    
    func judgeRemind() {
        let text = self.text ?? ""
        if (text.count < 1) {
            self.borderWidth = 1
            self.borderColor = .red
        }else{
            self.borderWidth = 0
        }
    }
    
    func judgePassword() {
        let text = self.text ?? ""
        if (isPassword(text: text)) {
            self.borderWidth = 0
        }else{
            self.borderWidth = 1
            self.borderColor = .red
        }
    }
    
    
}

//
//  UILabelExtensions.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/19.
//

import Foundation
import UIKit

extension UILabel {
    
    func judgeRemind() {
        let text = self.text ?? ""
        if (text.count < 1) {
            self.borderWidth = 1
            self.borderColor = .red
        }else{
            self.borderWidth = 0
        }
    }
    
    
    func textColor() {
        if let value = Double(self.text ?? "") {
            if value < 0 {
                self.textColor = .init(hex: "#FF4A4A")
                self.text = self.text! + " %"
            }else{
                self.textColor = .init(hex: "#59ED3E")
                self.text = "+" + self.text! + " %"
            }
        }
    }
    
    
    
}

protocol Localizable {
    var localizedKey: String? {get set}
}

extension UILabel: Localizable {
    
    @IBInspectable var localizedKey: String? {
        get {return nil}
        set(key) {
            self.text = key?.localized
        }
    }
}


extension UISearchBar: Localizable {
    
    @IBInspectable var localizedKey: String? {
        get {return nil}
        set(key) {
            self.placeholder = key?.localized
        }
    }
}

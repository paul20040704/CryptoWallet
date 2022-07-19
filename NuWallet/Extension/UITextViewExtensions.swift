//
//  UITextViewExtensions.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/5/5.
//

import Foundation
import UIKit

extension UITextView: UITextViewDelegate {
    
    override open var bounds: CGRect {
            didSet {
                self.resizePlaceholder()
            }
        }
    
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            }else{
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    
    public func textViewDidChange(_ textView: UITextView) {
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderLabel.isHidden = !self.text.isEmpty
            }
        }
        
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            //let labelHeight = placeholderLabel.frame.height
            
            let size = placeholderLabel.sizeThatFits(CGSize(width: labelWidth, height: 0))
            placeholderLabel.frame = CGRect(x: labelX + 10, y: labelY + 10, width: size.width , height: size.height)
        }
    }
        
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        //placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.init(hex: "#393939")
        placeholderLabel.numberOfLines = 0
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = !self.text.isEmpty
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
        
    
}


extension UITextView: Localizable {
    
    @IBInspectable var localizedKey: String? {
        get {return nil}
        set(key) {
            self.text = key?.localized
        }
    }
}

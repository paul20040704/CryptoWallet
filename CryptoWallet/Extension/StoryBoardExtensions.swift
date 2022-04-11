//
//  StoryBoardExtensions.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/10.
//

import Foundation
import UIKit

// push跳出, pop跳回
// PAGE_ONE.navigationController?.pushViewController(PAGE_TWO, animated: true)
// PAGE_TWO.navigationController?.popViewController(animated: true)

// present跳出, dismiss跳回
// PAGE_ONE.present(PAGE_TWO, animated: true, completion: nil)
// PAGE_TWO.presentingViewController?.dismiss(animated: true, completion: nil)

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            if (newValue > 0) {
                if (newValue > (self.frame.height / 2)) {
                    layer.cornerRadius = self.frame.height / 2
                } else {
                    layer.cornerRadius = newValue
                }
                layer.masksToBounds = true
                clipsToBounds = true
            } else {
                layer.cornerRadius = newValue
                layer.masksToBounds = false
            }
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
}

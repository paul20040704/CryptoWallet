//
//  UIButtonExtensions.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/14.
//

import Foundation
import UIKit
extension UIButton {
    
    func setBackgroundHorizontalGradient(_ startColorHex: String, _ endColorHex: String, _ highlightedHex: String, paddingLeftRight: CGFloat?, paddingTopBottom: CGFloat?, borderWidth: CGFloat?, borderColorHex: String?, cornerRadius: CGFloat?) {
        
        DispatchQueue.main.async {
            self.backgroundColor = UIColor.clear
            
            let gradientImage = getHorizontalGradientImage(width: self.frame.size.width, height: self.frame.size.height, startColorHex: startColorHex, endColorHex: endColorHex, paddingLeftRight: paddingLeftRight, paddingTopBottom: paddingTopBottom, borderWidth: borderWidth, borderColorHex: borderColorHex, cornerRadius: cornerRadius)
            self.setBackgroundImage(gradientImage, for: UIControl.State.normal)
            
            
            let highlightedImage = getColorImage(width: self.frame.size.width, height: self.frame.size.height, colorHex: highlightedHex, paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: borderWidth, borderColorHex: borderColorHex, cornerRadius: cornerRadius)
            
            self.setBackgroundImage(highlightedImage, for: UIControl.State.highlighted)
        }
        
    }
    
    func setBackgroundVerticalGradient(_ startColorHex: String, _ endColorHex: String, _ highlightedHex: String, paddingLeftRight: CGFloat?, paddingTopBottom: CGFloat?, borderWidth: CGFloat?, borderColorHex: String?, cornerRadius: CGFloat?) {
        
        DispatchQueue.main.async {
            self.backgroundColor = UIColor.clear
            
            let gradientImage = getVerticalGradientImage(width: self.frame.size.width, height: self.frame.size.height, startColorHex: startColorHex, endColorHex: endColorHex, paddingLeftRight: paddingLeftRight, paddingTopBottom: paddingTopBottom, borderWidth: borderWidth, borderColorHex: borderColorHex, cornerRadius: cornerRadius)
            self.setBackgroundImage(gradientImage, for: UIControl.State.normal)
            
            let highlightedImage = getColorImage(width: self.frame.size.width, height: self.frame.size.height, colorHex: highlightedHex, paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: borderWidth, borderColorHex: borderColorHex, cornerRadius: cornerRadius)
            
            self.setBackgroundImage(highlightedImage, for: UIControl.State.highlighted)
        }
        
    }
    
    func setBackgroundColor(_ colorHex: String, _ highlightedHex: String, paddingLeftRight: CGFloat?, paddingTopBottom: CGFloat?, borderWidth: CGFloat?, borderColorHex: String?, cornerRadius: CGFloat?) {
        
        DispatchQueue.main.async {
            self.backgroundColor = UIColor.clear
            
            let colorImage = getColorImage(width: self.frame.size.width, height: self.frame.size.height, colorHex: colorHex, paddingLeftRight: paddingLeftRight, paddingTopBottom: paddingTopBottom, borderWidth: borderWidth, borderColorHex: borderColorHex, cornerRadius: cornerRadius)
            self.setBackgroundImage(colorImage, for: UIControl.State.normal)
            
            let highlightedImage = getColorImage(width: self.frame.size.width, height: self.frame.size.height, colorHex: highlightedHex, paddingLeftRight: paddingLeftRight, paddingTopBottom: paddingTopBottom, borderWidth: borderWidth, borderColorHex: borderColorHex, cornerRadius: cornerRadius)
            self.setBackgroundImage(highlightedImage, for: UIControl.State.highlighted)
        }
        
    }
}

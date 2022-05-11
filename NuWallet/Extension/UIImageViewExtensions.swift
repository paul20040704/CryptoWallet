//
//  UIImageViewExtensions.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/4/29.
//

import Foundation
import UIKit

extension UIImageView {
    
    func transform() {
        let flipImage = UIImage(cgImage: self.image!.cgImage!, scale: self.image?.scale ?? 0.0, orientation: UIImage.Orientation(rawValue: 2)!)
        self.image = flipImage
    }
    
}

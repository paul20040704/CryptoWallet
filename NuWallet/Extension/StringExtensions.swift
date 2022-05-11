//
//  StringExtensions.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/4/26.
//

import Foundation
import UIKit

extension String{
 
    var localized: String {
                 
        let lang = UD.string(forKey: "lang") ?? "en"
        let bundle = Bundle(path: Bundle.main.path(forResource: lang, ofType: "lproj")!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
         
    }
}


extension UITabBarItem: Localizable {
    
    @IBInspectable var localizedKey: String? {
        get {return nil}
        set(key) {
            self.title = key?.localized
        }
    }
}


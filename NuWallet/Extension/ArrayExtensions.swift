//
//  ArrayExtensions.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/4/27.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> String {
        if index < 0 || index > count - 1{
            return ""
        } else {
            return self[safe: index]
        }
    }
}

//
//  DoubleExtensions.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/5/20.
//

import Foundation

extension Double {
    func rounding(toDecimal decimal: Int) -> Double {
        let numberOfDigits = pow(10.0, Double(decimal))
        return (self * numberOfDigits).rounded(.toNearestOrAwayFromZero) / numberOfDigits
    }
    
    func round() -> String {
        if (self > 1) {
            return String(self.rounding(toDecimal: 2))
        }else if (self > 0.0001){
            return String(self.rounding(toDecimal: 4))
        }else if (self == 0){
            return String(self.rounding(toDecimal: 1))
        }else{
            return self.toString()
        }
    }
    
    //小數點後第X位無條件進位
    func ceiling(toDecimal decimal: Int) -> Double {
        let numberOfDigits = abs(pow(10.0, Double(decimal)))
        if self.sign == .minus {
            return Double(Int(self * numberOfDigits)) / numberOfDigits
        }else{
            return Double(ceil(self * numberOfDigits)) / numberOfDigits
        }
    }
    
    //小數點後第X位無條件捨去
    func floor(toDecimal decimal: Int) -> Double {
        let numberOfDigits = pow(10.0, Double(decimal))
        return (self * numberOfDigits).rounded(.towardZero) / numberOfDigits
    }
    
    
    func toString(decimal: Int = 8) -> String {
        let value = decimal < 0 ? 0 : decimal
        var string = String(format: "%.\(value)f", self)

        while string.last == "0" || string.last == "." {
            if string.last == "." { string = String(string.dropLast()); break}
            string = String(string.dropLast())
        }
        return string
    }
    
    
}


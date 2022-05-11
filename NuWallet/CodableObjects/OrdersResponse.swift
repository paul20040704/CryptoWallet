//
//  OrdersResponse.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/4/29.
//

import Foundation


struct SellingDetail: Codable {
    
    let orderId: String?
    let coinName: String?
    let coinFullName: String?
    let coinQuantity: Int?
    let currencyName: String?
    let currencyFullName: String?
    let currencyAmount: Int?
    let date: String?

}

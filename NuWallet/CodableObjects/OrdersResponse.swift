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
    let coinQuantity: Double?
    let currencyName: String?
    let currencyFullName: String?
    let currencyAmount: Double?
    let date: String?

}

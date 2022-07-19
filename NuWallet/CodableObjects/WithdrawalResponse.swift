//
//  WithdrawalResponse.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/5/17.
//

import Foundation


struct WithdrawalResponse: Codable {
    let coinId: String?
    let balance: Double?
    let twoFactorAuthEnabled: Bool?
    let twoFactorAuthType: Int?
    let networks: [NetworkResponse]
}


struct NetworkResponse: Codable {
    let networkId: String?
    let addressRegex: String?
    let minWithdrawalQuantity: Double?
    let fee: Double?
    let includeMemo: Bool?
    let decimalPlaces: Int?
}


struct Transaction: Codable {
    let transactionId: String?
}

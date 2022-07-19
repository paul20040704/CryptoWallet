//
//  TransactionResponse.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/5/25.
//

import Foundation

struct TransactionHistory: Codable {
    let data: [TransactionData]
}

struct TransactionData: Codable {
    let transactionId: String?
    let coinId: String?
    let quantity: Double?
    let time: String?
    let status: Int?
    let isBtmTransaction: Bool?
}


struct DepositList: Codable {
    let transactionId: String?
    let coinId: String?
    let coinFullName: String?
    let network: String?
    let quantity: Double?
    let fee: Double?
    let fromAddress: String?
    let time: String?
    let status: Int?
    let txid: String?
    let explorerUrl: String?
}

struct WithdrawList: Codable {
    let transactionId: String?
    let coinId: String?
    let coinFullName: String?
    let network: String?
    let quantity: Double?
    let fee: Double?
    let destinationAddress: String?
    let time: String?
    let status: Int?
    let txid: String?
    let explorerUrl: String?
}

struct BtmTransactionList: Codable {
    let source: String?
    let type: Int?
    let amount: Double?
    let currency: String?
    let quantity: Double?
    let coinId: String?
    let coinFullName: String?
    let rate: Double?
    let status: Int?
    let time: String?
}

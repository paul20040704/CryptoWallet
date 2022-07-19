//
//  SwapResponse.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/7/1.
//

import Foundation

struct SwapResponse: Codable {
    let data: [SwapData]?
}


struct SwapData: Codable {
    let fromCoinId: String?
    let toCoinIdCollection: [SwapMin]?
}

struct SwapMin: Codable {
    let coinId: String?
    let swapMinQuantity: Double?
    let swapFromCoinDecimalPlaces: Int?
}

struct SwapRate: Codable {
    let rate: Double?
}

struct SwapOrder: Codable {
    let transactionId: String?
    let fromCoinId: String?
    let toCoinId: String?
    let payQuantity: Double?
    let purchaseQuantity: Double?
    let confirmExpiredAt: String?
    let completeExpiredAt: String?
}

struct SwapHistory: Codable {
    let data: [HistoryData]?
}

struct HistoryData: Codable {
    let transactionId: String?
    let fromCoinId: String?
    let fromCoinFullName: String?
    let toCoinId: String?
    let toCoinFullName: String?
    let payQuantity: Double?
    let purchaseQuantity: Double?
    let exchangeRate: Double?
    let time: String?
}


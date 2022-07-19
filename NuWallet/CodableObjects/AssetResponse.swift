//
//  AssetResponse.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/4/27.
//

import Foundation

struct AssetResponse: Codable {
    let estimatedBalance: Double?
    let assets: [Asset]?
}

struct Asset: Codable {
    let coinId: String?
    let coinFullName: String?
    let balance: Double?
    let tradeEnabled: Bool?
    let depositEnabled: Bool?
    let withdrawalEnabled: Bool?
}


struct AssetAddress: Codable {
    let coinId: String?
    let addresses: [Address]?
}


struct Address: Codable {
    let networkId: String?
    let address: String?
}


struct PostAddress: Codable {
    let address: String?
}

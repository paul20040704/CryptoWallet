//
//  AssetResponse.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/4/27.
//

import Foundation

struct AssetResponse: Codable {
    let estimatedBalance: Int?
    let assets: [asset]?
}

struct asset: Codable {
    let coinId: String?
    let coinFullName: String?
    let balance: Int?
}

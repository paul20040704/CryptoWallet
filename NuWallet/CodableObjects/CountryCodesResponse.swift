//
//  CountryCodesResponse.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/21.
//

import Foundation
import UIKit

struct CountryCodesResponse: Codable {
    let data: [CountryCodeItem]?
    let currentPage: Int?
    let totalPages: Int?
    let totalCount: Int?
    let pageSize: Int?
    let hasPreviousPage: Bool?
    let hasNextPage: Bool?
}

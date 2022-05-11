//
//  TokenResponse.swift
//  CryptoWallet
//
//  Created by Fanglin Hsu on 2022/4/6.
//

import Foundation

struct TokenResponse: Codable {
    let token: String
    let refreshToken: String
    let refreshTokenExpiryTime: Int
}

struct TwoAuthResponse: Codable {
    let loginTwoFactorAuthEnabled: Bool?
    let verificationMethod: Int?
}

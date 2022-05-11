//
//  MemberResponse.swift
//  CryptoWallet
//
//  Created by Fanglin Hsu on 2022/4/7.
//

import Foundation

struct MemberResponse: Codable {
    let countryCode: String?
    let mobileNumber: String?
    let verifiedEmail: String?
    let authenticatorBound: Bool?
    let loginTwoFactorAuthEnabled: Bool?
    let wasTransactionPasswordSetted: Bool?
    let operatingTwoFactorAuthEnabled: Bool? //操作是否啟動兩步驟驗證
    let twoFactorAuthType: Int? //兩步驟驗證類型
    let memberLevel: Int?
    let memberKycStatus: Int? //會員 KYC 驗證狀態
    let memberKycVerifiedOn: String? //會員 Kyc 驗證完成日期
    let withdrawalEnabled: Bool?
    let invitationCode: String? //邀請碼
}

struct AuthenticatorResponse: Codable {
    let qrCodeImage: String?
    let manualSetupKey: String?
}


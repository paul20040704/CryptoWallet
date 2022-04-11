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
    let operatingTwoFactorAuthEnabled: Bool?
    let twoFactorAuthType: Int?
    let memberLevel: Int?
    let memberKycStatus: Int?
    let memberKycVerifiedOn: String?
    let withdrawalEnabled: Bool?
    let invitationCode: String?
}

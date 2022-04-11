//
//  Util.swift
//  CryptoWallet
//
//  Created by Fanglin Hsu on 2022/4/8.
//

import Foundation

class Util: NSObject {
    static let shared = Util()
    
    //取得當前timeInterval
    func getTimeInterval() -> Int {
        let now = Date()
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return timeStamp
    }
    //Base64解碼
    func decodeTokenTime(token: String) -> Int {
        let component = token.components(separatedBy: ".")
        let str = component[1]
        let decodedData = Data(base64Encoded: str)
        let decodedString = String(data: decodedData!, encoding: .utf8)
        let component1 = decodedString!.components(separatedBy: "," )
        let component2 = component1[1].components(separatedBy: ":")
        return Int(component2[1])!
    }
    
    //更新token
    func updateToken(token: TokenResponse) {
    //    var arr = Array<Any>()
    //    arr.append(token.token)
    //    arr.append(token.refreshToken)
    //    arr.append(token.refreshTokenExpiryTime)
    //    UD.set(arr, forKey: "token")
    //    UD.synchronize()
    //    print("updateTokenUsr")
        if let data = try? PEncoder.encode(token) {
            UD.set(data, forKey: "token")
            UD.synchronize()
            print("updateTokenUsr")
        }
    }

    //update會員資訊
    func updateMember(info: MemberResponse) {
    //    var arr = Array<Any>()
    //    arr.append(info.countryCode ?? "")
    //    arr.append(info.mobileNumber ?? "")
    //    arr.append(info.verifiedEmail ?? "")
    //    arr.append(info.authenticatorBound ?? false)
    //    arr.append(info.loginTwoFactorAuthEnabled ?? false)
    //    arr.append(info.wasTransactionPasswordSetted ?? false)
    //    arr.append(info.operatingTwoFactorAuthEnabled ?? false)
    //    arr.append(info.twoFactorAuthType ?? 0)
    //    arr.append(info.memberLevel ?? 0)
    //    arr.append(info.memberKycStatus ?? 0)
    //    arr.append(info.memberKycVerifiedOn ?? "")
    //    arr.append(info.withdrawalEnabled ?? false)
    //    arr.append(info.invitationCode ?? "")
    //    UD.set(arr, forKey: "member")
    //    UD.synchronize()
    //    print("updateMemberUsr")
        if let data = try? PEncoder.encode(info) {
            UD.set(data, forKey: "member")
            UD.synchronize()
            print("updateMemberUsr")
        }
    }
    
}

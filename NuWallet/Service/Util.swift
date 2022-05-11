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
    
    func dateToString(date:Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    //Dictionary利用value尋找key
    func dicFindKey(value: String, dic: (Dictionary<AnyHashable, String>)) -> Any {
        for item in dic {
            if (item.value == value) {
                return item.key
            }
        }
        return value
    }
    
    //透過Dictionary Key排序 value
    func sortDicValue(dic: (Dictionary<Int, String>)) -> Array<String> {
        let keyArr = Array(dic.keys.map{ $0 }).sorted(by: <)
        var valueArr = Array<String>()
        for key in keyArr {
            valueArr.append(dic[key] ?? "")
        }
        return valueArr
    }
    
    //更新token
    func updateToken(token: TokenResponse) {
    
        if let data = try? PEncoder.encode(token) {
            UD.set(data, forKey: "token")
            UD.synchronize()
            print("updateTokenUsr")
        }
    }

    //update會員資訊
    func updateMember(info: MemberResponse) {
    
        if let data = try? PEncoder.encode(info) {
            UD.set(data, forKey: "member")
            UD.synchronize()
            print("updateMemberUsr")
        }
    }
    
    //設定FaceID/TouchID開關
    func setFaceID (enable: Bool) {
        UD.set(enable, forKey: "faceId")
        UD.synchronize()
    }
    
}

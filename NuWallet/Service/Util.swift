//
//  Util.swift
//  CryptoWallet
//
//  Created by Fanglin Hsu on 2022/4/8.
//

import Foundation
import UIKit

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
    //解碼token拿到Id
    func decodeTokenId(token: String) -> String {
        let component = token.components(separatedBy: ".")
        let str = component[1]
        let decodedData = Data(base64Encoded: str)
        let decodedString = String(data: decodedData!, encoding: .utf8)
        let component1 = decodedString!.components(separatedBy: "," )
        let component2 = component1[0].components(separatedBy: "\"")
        return component2[3]
    }
    
    //時間轉String
    func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    //時間轉String
    func dateToStringMS(date:Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    //取得半年前時間String
    func halfDateString() -> String {
        let todatDate = Date()
        if let newDate = Calendar.current.date(byAdding: .month, value: -6, to: todatDate){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: newDate)
            return dateString
        }
        return ""
    }
    
    
    func isoDateToString(iso: String) -> String{
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions.insert(.withFractionalSeconds)
        let date = isoFormatter.date(from: iso)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: date ?? Date())
        return dateString
    }
    
    //時間倒數
    func dateDiff(iso: String) -> Int {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions.insert(.withFractionalSeconds)
        guard let isoDate = isoFormatter.date(from: iso) else {return 0}
        
        let nowDate = Date()
        let diff: DateComponents = Calendar.current.dateComponents([.second], from: nowDate, to: isoDate)
        
        return diff.second ?? 0
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
    
    //取得Member資訊
    func getMemberInfo() -> MemberResponse? {
        if let data = UD.data(forKey: "member"), let member = try? PDecoder.decode(MemberResponse.self, from: data){
            return member
        }
        return nil
    }
    
    //顯示AlertView
    func showAlert(title: String, message: String?) -> UIAlertController {
        let alertC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "yes".localized, style: .cancel)
        alertC.addAction(okAction)
        return alertC
    }
    
    //判斷檔案大小是否超過50MB
    func dataSizeOver(data: Data) -> Bool {
        let size = data.count
        if size > 52428800 {
            return true
        }else {
            return false
        }
    }
    
    
    
}

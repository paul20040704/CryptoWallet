//
//  UIImageExtensions.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/16.
//

import Foundation
import UIKit

func getCenterBtnImage64x64() -> UIImage? {
    
    UIGraphicsBeginImageContext(CGSize.init(width: 64, height: 64))
    
    // draw circle
    let gradientLayer = CAGradientLayer()
    gradientLayer.bounds = CGRect.init(x: 12, y: 4, width: 40, height: 40)
    gradientLayer.cornerRadius = 20
    
    if let startColor = UIColor.init(hex: "1F892B") {
        if let entColor = UIColor.init(hex: "11681B") {
            gradientLayer.colors = [
                startColor.cgColor,
                entColor.cgColor
            ]
        }
    }
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    gradientLayer.masksToBounds = true
    gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
    
    // draw logo
    let img = UIImage.init(named: "icon_tabbar_btm")
    img?.draw(in: CGRect.init(x: 18, y: 10, width: 28, height: 28))
    
    // draw title
    let txt: NSString = "BTM"
    let txtStyle = NSMutableParagraphStyle()
    txtStyle.alignment = NSTextAlignment.center
    txt.draw(in: CGRect.init(x: 12, y: 48, width: 40, height: 16), withAttributes: [
        NSAttributedString.Key.paragraphStyle: txtStyle,
        NSAttributedString.Key.foregroundColor: UIColor.init(hex: "1F892B")!,
        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11, weight: .regular)])
    
    let centerImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return centerImage
}

func getLineGraph(width: CGFloat, height: CGFloat, values: [CGFloat], colorHex: String) -> UIImage? {
    
    var graphImage: UIImage?
    if (values.count > 0) {
        UIGraphicsBeginImageContext(CGSize.init(width: width, height: height))
        if let context = UIGraphicsGetCurrentContext() {
            var max: CGFloat = values[0]
            var min: CGFloat = values[0]
            for value in values {
                if (value > max) {
                    max = value
                }
                if (value < min) {
                    min = value
                }
            }
            let range: CGFloat = width / CGFloat((values.count - 1))
            let path = CGMutablePath()
            let startX: CGFloat = 0
            var startY: CGFloat = height / 2
            if (max > min) {
                let ratio = height / (max - min)
                startY = (values[0] - min) * ratio
            }
            startY = height - startY
            path.move(to: CGPoint.init(x: startX, y: startY))
            for i in 1..<values.count {
                var stopX: CGFloat = CGFloat(i) * range
                if (i == (values.count - 1)) {
                    stopX = width;
                }
                var stopY: CGFloat = height / 2
                if (max > min) {
                    let ratio = height / (max - min)
                    stopY = (values[i] - min) * ratio
                }
                stopY = height - stopY
                path.addLine(to: CGPoint.init(x: stopX, y: stopY))
            }
            context.addPath(path)
            if let color = UIColor.init(hex: colorHex) {
                context.setStrokeColor(color.cgColor)
            }
            context.setLineWidth(3)
            context.strokePath()
            graphImage = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
    }
    
    return graphImage
}

func getColorImage(width: CGFloat, height: CGFloat, colorHex: String, paddingLeftRight: CGFloat?, paddingTopBottom: CGFloat?, borderWidth: CGFloat?, borderColorHex: String?, cornerRadius: CGFloat?) -> UIImage? {
    
    let layer = CALayer()
    if let paddingLeftRight = paddingLeftRight {
        if let paddingTopBottom = paddingTopBottom {
            layer.bounds = CGRect.init(x: paddingLeftRight, y: paddingTopBottom, width: width - paddingLeftRight * 2, height: height - paddingTopBottom * 2)
        } else {
            layer.bounds = CGRect.init(x: paddingLeftRight, y: 0, width: width - paddingLeftRight * 2, height: height)
        }
    } else {
        if let paddingTopBottom = paddingTopBottom {
            layer.bounds = CGRect.init(x: 0, y: paddingTopBottom, width: width, height: height - paddingTopBottom * 2)
        } else {
            layer.bounds = CGRect.init(x: 0, y: 0, width: width, height: height)
        }
    }
    
    if let radius = cornerRadius {
        layer.cornerRadius = radius
    }
    if let color = UIColor.init(hex: colorHex) {
        layer.backgroundColor = color.cgColor
    }
    if let width = borderWidth {
        layer.borderWidth = width
    }
    if let hex = borderColorHex {
        if let color = UIColor.init(hex: hex) {
            layer.borderColor = color.cgColor
        }
    }
    layer.masksToBounds = true
    
    UIGraphicsBeginImageContext(CGSize.init(width: width, height: height))
    layer.render(in: UIGraphicsGetCurrentContext()!)
    let colorImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return colorImage
}

func getHorizontalGradientImage(width: CGFloat, height: CGFloat, startColorHex: String, endColorHex: String, paddingLeftRight: CGFloat?, paddingTopBottom: CGFloat?, borderWidth: CGFloat?, borderColorHex: String?, cornerRadius: CGFloat?) -> UIImage? {
    
    let startPoint = CGPoint(x: 0, y: 0.5)
    let endPoint = CGPoint(x: 1, y: 0.5)
    return getGradientImage(width: width, height: height, startColorHex: startColorHex, endColorHex: endColorHex, startPoint: startPoint, endPoint: endPoint, paddingLeftRight: paddingLeftRight, paddingTopBottom: paddingTopBottom, borderWidth: borderWidth, borderColorHex: borderColorHex, cornerRadius: cornerRadius)
}

func getVerticalGradientImage(width: CGFloat, height: CGFloat, startColorHex: String, endColorHex: String, paddingLeftRight: CGFloat?, paddingTopBottom: CGFloat?, borderWidth: CGFloat?, borderColorHex: String?, cornerRadius: CGFloat?) -> UIImage? {
    
    let startPoint = CGPoint(x: 0.5, y: 0)
    let endPoint = CGPoint(x: 0.5, y: 1)
    return getGradientImage(width: width, height: height, startColorHex: startColorHex, endColorHex: endColorHex, startPoint: startPoint, endPoint: endPoint, paddingLeftRight: paddingLeftRight, paddingTopBottom: paddingTopBottom, borderWidth: borderWidth, borderColorHex: borderColorHex, cornerRadius: cornerRadius)
}

func getGradientImage(width: CGFloat, height: CGFloat, startColorHex: String, endColorHex: String, startPoint: CGPoint, endPoint: CGPoint, paddingLeftRight: CGFloat?, paddingTopBottom: CGFloat?, borderWidth: CGFloat?, borderColorHex: String?, cornerRadius: CGFloat?) -> UIImage? {
    
    let gradientLayer = CAGradientLayer()
    
    if let paddingLeftRight = paddingLeftRight {
        if let paddingTopBottom = paddingTopBottom {
            gradientLayer.bounds = CGRect.init(x: paddingLeftRight, y: paddingTopBottom, width: width - paddingLeftRight * 2, height: height - paddingTopBottom * 2)
        } else {
            gradientLayer.bounds = CGRect.init(x: paddingLeftRight, y: 0, width: width - paddingLeftRight * 2, height: height)
        }
    } else {
        if let paddingTopBottom = paddingTopBottom {
            gradientLayer.bounds = CGRect.init(x: 0, y: paddingTopBottom, width: width, height: height - paddingTopBottom * 2)
        } else {
            gradientLayer.bounds = CGRect.init(x: 0, y: 0, width: width, height: height)
        }
    }
    
    if let radius = cornerRadius {
        gradientLayer.cornerRadius = radius
    }
    if let startColor = UIColor.init(hex: startColorHex) {
        if let entColor = UIColor.init(hex: endColorHex) {
            gradientLayer.colors = [
                startColor.cgColor,
                entColor.cgColor
            ]
        }
    }
    gradientLayer.startPoint = startPoint
    gradientLayer.endPoint = endPoint
    if let width = borderWidth {
        gradientLayer.borderWidth = width
    }
    if let hex = borderColorHex {
        if let color = UIColor.init(hex: hex) {
            gradientLayer.borderColor = color.cgColor
        }
    }
    gradientLayer.masksToBounds = true
    UIGraphicsBeginImageContext(CGSize.init(width: width, height: height))
    gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
    let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return gradientImage
}

func getCountryCodes(headers: [String: String]?, response: ((_ statusCode: Int, _ dataObj: CountryCodesResponse?, _ err: Error?) -> Void)?) {
    
    if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/country-codes") {
        
        var request = URLRequest(url: url)
        
        if let headers = headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
            
            var statusCode = 0
            var dataObj: CountryCodesResponse? = nil
            
            if let httpResponse = urlResponse as? HTTPURLResponse {
                statusCode = httpResponse.statusCode
            }
            
            if let data = data {
                do {
                    dataObj = try JSONDecoder().decode(CountryCodesResponse.self, from: data)
                } catch {
                    
                }
            }
            DispatchQueue.main.async {
                response?(statusCode, dataObj, error)
            }
        }
        
        task.resume()
        
    } else {
        
        DispatchQueue.main.async {
            response?(0, nil, nil)
        }
    }
    
}

func sendVerificationCode(countryId: String, phoneNumber: String?, email: String?, verificationMethod: Int, verificationType: Int, response: ((_ statusCode: Int, _ dataObj: Any?, _ err: Error?) -> Void)?) {
    
    // verificationType => 0 = Undefined, 1 = Register
    // verificationMethod => 0 = Undefined, 1 = Email, 2 = SMS, 3 = GoogleAuthenticator
    
    let headers: [String: String] = [String: String]()
    var params: [String: Any] = [String: Any]()
    
    if (countryId.count > 0) {
        params["countryId"] = countryId
    }
    
    params["verificationMethod"] = verificationMethod
    params["verificationType"] = verificationType
    
    if (verificationMethod == 1) {
        // email
        if let email = email {
            if (email.count > 0) {
                params["email"] = email
            }
        }
    } else if (verificationMethod == 2) {
        // phone
        if let phoneNumber = phoneNumber {
            if (phoneNumber.count > 0) {
                params["mobileNumber"] = phoneNumber
            }
        }
    } else if (verificationMethod == 3) {
        // google auth
    }
    
    if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/verification-code") {
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
        } catch {
            
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
            
            
            var statusCode = 0

            if let httpResponse = urlResponse as? HTTPURLResponse {
                statusCode = httpResponse.statusCode
            }
            
            DispatchQueue.main.async {
                response?(statusCode, nil, error)
            }
        }
        
        task.resume()
        
    } else {
        
        DispatchQueue.main.async {
            response?(0, nil, nil)
        }
    }
    
}

func registMember(countryId: String, phoneNumber: String, verificationCode: String, password: String, repassword: String, invitationCode: String?, response: ((_ statusCode: Int, _ dataObj: RegistMemberResponse?, _ err: Error?) -> Void)?) {
    
    let headers: [String: String] = [String: String]()
    var params: [String: Any] = [String: Any]()
    if (countryId.count > 0) {
        params["countryId"] = countryId
    }
    if (phoneNumber.count > 0) {
        params["mobileNumber"] = phoneNumber
    }
    if (verificationCode.count > 0) {
        params["verificationCode"] = verificationCode
    }
    if (password.count > 0) {
        params["password"] = password
    }
    if (repassword.count > 0) {
        params["confirmPassword"] = repassword
    }
    if let invitationCode = invitationCode {
        if (invitationCode.count > 0) {
            params["invitationCode"] = invitationCode
        }
    }
    
    if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/member") {
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
        } catch {
            
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
            
            var statusCode = 0
            var dataObj: RegistMemberResponse? = nil

            if let httpResponse = urlResponse as? HTTPURLResponse {
                statusCode = httpResponse.statusCode
            }

            if let data = data {
                do {
                    dataObj = try JSONDecoder().decode(RegistMemberResponse.self, from: data)
                } catch {

                }
            }
            
            DispatchQueue.main.async {
                response?(statusCode, dataObj, error)
            }
        }
        
        task.resume()
        
    } else {
        
        DispatchQueue.main.async {
            response?(0, nil, nil)
        }
    }
    
}

func getToken(response: ((_ success: Bool, _ token: String) -> Void)?) {
    
    if let data = UD.data(forKey: "token"), let token = try? PDecoder.decode(TokenResponse.self, from: data){
        let nowT = US.getTimeInterval()
        let tokenT = US.decodeTokenTime(token: token.token)
        let reTokenT = token.refreshTokenExpiryTime
        if (tokenT > nowT) {
            //token時間還沒過期
            response?(true,token.token)
        }else{
            if (reTokenT > nowT) {
                //refreshToken時間還沒過期
                BN.refreshToken(token: token.token, reToken: token.refreshToken) { success, newToken in
                    if (success){
                        response?(true,newToken)
                    }else{
                        response?(false,"")
                    }
                }
            }else{
                //refreshToken時間過期
                response?(false,"")
            }
        }
    }else{
        response?(false,"")
    }
 }
    


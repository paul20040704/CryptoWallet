//
//  BaseNetwork.swift
//  CryptoWallet
//
//  Created by Fanglin Hsu on 2022/4/6.
//

import Foundation

class BaseNetwork {
    static let shareNetWork = BaseNetwork()
    
    //取得登入token
    func getToken(countryId: String, mobileNumber: String, password: String, verificationCode: String, verificationMethod: Int, response: ((_ statusCode: Int, _ dataObj: TokenResponse?, _ err: Error?) -> ())?){
        
        var params: [String: Any] = [String: Any]()
        if (countryId.count > 0){
            params["countryId"] = countryId
        }
        if (mobileNumber.count > 0) {
            params["mobileNumber"] = mobileNumber
        }
        if (password.count > 0) {
            params["password"] = password
        }
        if (verificationCode.count > 0) {
            params["verificationCode"] = verificationCode
        }
        params["verificationMethod"] = verificationMethod
        
        if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/token") {
            
            var request = URLRequest(url: url)
            
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do{
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
            } catch {
                
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                
                var statusCode = 0
                var dataObj: TokenResponse? = nil
                
                if let httpResponse = urlResponse as? HTTPURLResponse {
                    statusCode = httpResponse.statusCode
                }
                
                if let data = data {
                    do {
                        dataObj = try JSONDecoder().decode(TokenResponse.self, from: data)
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
    
    func loginTwoFactorAuth(countryId: String, mobileNumber: String, response: ((_ statusCode: Int, _ dataObj: TwoAuthResponse?, _ err: Error?) -> ())?){
        
        //let headers: [String: String] = [String: String]()
        var params: [String: Any] = [String: Any]()
        if (countryId.count > 0) {
            params["countryId"] = countryId
        }
        if (mobileNumber.count > 0) {
            params["mobileNumber"] = mobileNumber
        }
        var urlCompoent = URLComponents(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/member/login-two-factor-auth")
        urlCompoent?.queryItems = params.map({ (key, Value) in
            URLQueryItem(name: key, value: (Value as! String))
        })
        if let url = urlCompoent?.url {
            
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                
                var statusCode = 0
                var dataObj: TwoAuthResponse? = nil

                if let httpResponse = urlResponse as? HTTPURLResponse {
                    statusCode = httpResponse.statusCode
                }

                if let data = data {
                    do {
                        dataObj = try JSONDecoder().decode(TwoAuthResponse.self, from: data)
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
    
    func getMember(token: String, response: ((_ statusCode: Int, _ dataObj: MemberResponse?, _ err: Error?) -> ())?) {
    
        if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/member") {
            
            var request = URLRequest(url: url)
            request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("\(token)")
            let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                
                var statusCode = 0
                var dataObj: MemberResponse? = nil
                
                if let httpResponse = urlResponse as? HTTPURLResponse {
                    statusCode = httpResponse.statusCode
                }
                
                if let data = data {
                    do {
                        dataObj = try JSONDecoder().decode(MemberResponse.self, from: data)
                    } catch {

                    }
                }
                DispatchQueue.main.async {
                    response?(statusCode, dataObj, error)
                }
            }
            task.resume()
        }else{
            DispatchQueue.main.async {
                response?(0, nil, nil)
            }
        }
    }

    func refreshToken(token: String, reToken: String, response: ((_ success: Bool,_ newToken: String) -> ())?) {
        
        var params: [String: Any] = [String: Any]()
        params["token"] = token
        params["refreshToken"] = reToken
        if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/refresh-token") {
                
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
            do{
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
            } catch {
                
            }
                
            let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                    
                var statusCode = 0
                var dataObj: TokenResponse? = nil
                    
                if let httpResponse = urlResponse as? HTTPURLResponse {
                    statusCode = httpResponse.statusCode
                }
                    
                if let data = data {
                    do {
                        dataObj = try JSONDecoder().decode(TokenResponse.self, from: data)
                    } catch {

                    }
                }
                    
                if (statusCode == 200 && dataObj != nil){
                    response?(true,(dataObj!.token))
                    US.updateToken(token: dataObj!)
                }else{
                    response?(false,"")
                }
            }
            task.resume()
            
        }else{
            response?(false,"")
        }
    }

}

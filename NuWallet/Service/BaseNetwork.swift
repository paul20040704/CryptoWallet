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
    func firstGetToken(countryId: String, mobileNumber: String, password: String, verificationCode: String, verificationMethod: Int, response: ((_ statusCode: Int, _ dataObj: TokenResponse?, _ err: ErrorResponse?) -> ())?){
        
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
                var errorObj: ErrorResponse? = nil
                
                if let httpResponse = urlResponse as? HTTPURLResponse {
                    statusCode = httpResponse.statusCode
                }
                if let data = data {
                    do {
                        dataObj = try JSONDecoder().decode(TokenResponse.self, from: data)
                    } catch {
                    }
                    do {
                        errorObj = try JSONDecoder().decode(ErrorResponse.self, from: data)
                    } catch {
                    }
                }
                DispatchQueue.main.async {
                    response?(statusCode, dataObj, errorObj)
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
    //取得登入驗證碼
    func sendLoginVerCode(countryId: String, mobileNumber: String, response: ((_ statusCode: Int, _ dataObj: Any?, _ err: ErrorResponse?) -> Void)?) {
    
        var params: [String: Any] = [String: Any]()
        
        params["countryId"] = countryId
        params["mobileNumber"] = mobileNumber
        
        if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/verification-code/login") {
            
            var request = URLRequest(url: url)
            
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do{
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
            } catch {
                
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                
                var statusCode = 0
                var errorObj: ErrorResponse? = nil
                
                if let httpResponse = urlResponse as? HTTPURLResponse {
                    statusCode = httpResponse.statusCode
                }
                if let data = data {
                    do {
                        errorObj = try JSONDecoder().decode(ErrorResponse.self, from: data)
                    } catch {
                    }
                }
                
                DispatchQueue.main.async {
                    response?(statusCode, nil, errorObj)
                }
            }
            task.resume()
        } else {
            DispatchQueue.main.async {
                response?(0, nil, nil)
            }
        }
    }
    
    //取得會員資訊並更新Usr
    func getMember(response: ((_ statusCode: Int, _ dataObj: MemberResponse?, _ err: Error?) -> ())?) {
        getToken { success, token in
            if (success) {
                if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/member") {
                    
                    var request = URLRequest(url: url)
                    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
                    let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                        
                        var statusCode = 0
                        var dataObj: MemberResponse? = nil
    
                        if let httpResponse = urlResponse as? HTTPURLResponse {
                            statusCode = httpResponse.statusCode
                        }
                        
                        if let data = data {
                            do {
                                dataObj = try JSONDecoder().decode(MemberResponse.self, from: data)
                                if (dataObj != nil) && statusCode == 200 {
                                    US.updateMember(info: dataObj!)
                                }
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
            }else{
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
                    if let obj = dataObj {
                        US.updateToken(token: obj)
                    }
                }
                    
                if (statusCode == 200 && dataObj != nil){
                    response?(true,(dataObj!.token))
                }else{
                    response?(false,"")
                }
            }
            task.resume()
            
        }else{
            response?(false,"")
        }
    }
    //發送驗證碼根據驗證方式
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

    //舊手機請求驗證碼(使用token)
    func getVerificationCode(verificationMethod: Int, verificationType: Int, response: ((_ statusCode: Int, _ dataObj: Any?, _ err: Error?) -> ())?){
        
        getToken { success, token in
            if (success) {
                var params: [String: Any] = [String: Any]()
                
                params["verificationMethod"] = verificationMethod
                params["verificationType"] = verificationType
                
                if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/verification-code-with-token") {
                    
                    var request = URLRequest(url: url)
                    
                    request.httpMethod = "POST"
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
                    
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
            }else{
                response?(0, nil, nil)
            }
        }
    }
    
    //修改手機號碼
    func changeMobile(countryId: String, mobileNumber: String, verificationCode: String, newVerificationCode: String, response: ((_ statusCode: Int, _ dataObj: Any?, _ err: ErrorResponse?) -> ())?) {
        getToken { success, token in
            if (success) {
                var params: [String: Any] = [String: Any]()
                
                params["countryId"] = countryId
                params["mobileNumber"] = mobileNumber
                params["verificationCode"] = verificationCode
                params["newVerificationCode"] = newVerificationCode
                
                if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/member/mobile-number") {
                    
                    var request = URLRequest(url: url)
                    
                    request.httpMethod = "PUT"
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
                    
                    do{
                        request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
                    } catch {
                        
                    }
                    
                    let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                        
                        var statusCode = 0
                        var errorObj: ErrorResponse? = nil

                        if let httpResponse = urlResponse as? HTTPURLResponse {
                            statusCode = httpResponse.statusCode
                        }
                        
                        if let data = data {
                            do {
                                errorObj = try JSONDecoder().decode(ErrorResponse.self, from: data)
                            } catch {
                            }
                        }
                        
                        DispatchQueue.main.async {
                            response?(statusCode, nil, errorObj)
                        }
                    }
                    
                    task.resume()
                    
                } else {
                    
                    DispatchQueue.main.async {
                        response?(0, nil, nil)
                    }
                }
                
            }else{
                response?(0, nil, nil)
            }
        }
    }
    //綁定Email
    func bindEmail(email: String, verificationCode: String ,response: ((_ statusCode: Int, _ dataObj: Any?, _ err: ErrorResponse?) -> ())?) {
        getToken { success, token in
            if (success) {
                var params: [String: Any] = [String: Any]()
                
                params["email"] = email
                params["verificationCode"] = verificationCode
                
                if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/member/email") {
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
                    
                    do{
                        request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
                    } catch {
                        
                    }
                    
                    let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                        
                        var statusCode = 0
                        var errorObj: ErrorResponse? = nil

                        if let httpResponse = urlResponse as? HTTPURLResponse {
                            statusCode = httpResponse.statusCode
                        }
                        
                        if let data = data {
                            do{
                                errorObj = try JSONDecoder().decode(ErrorResponse.self, from: data)
                            }
                            catch{
                            }
                        }
                        DispatchQueue.main.async {
                            response?(statusCode, nil, errorObj)
                        }
                    }
                    task.resume()
                } else {
                    DispatchQueue.main.async {
                        response?(0, nil, nil)
                    }
                }
            }else{
                response?(0, nil, nil)
            }
        }
    }
    //修改Email
    func changeEmail(email: String, verificationCode: String, newVerificationCode: String, response: ((_ statusCode: Int, _ dataObj: Any?, _ err: ErrorResponse?) -> ())?) {
        getToken { success, token in
            if (success) {
                var params: [String: Any] = [String: Any]()
                
                params["email"] = email
                params["verificationCode"] = verificationCode
                params["newVerificationCode"] = newVerificationCode
                
                if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/member/email") {
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "PUT"
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
                    
                    do{
                        request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
                    } catch {
                        
                    }
                    
                    let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                        
                        var statusCode = 0
                        var errorObj: ErrorResponse? = nil
                        
                        if let httpResponse = urlResponse as? HTTPURLResponse {
                            statusCode = httpResponse.statusCode
                        }
                        if let data = data {
                            do{
                                errorObj = try JSONDecoder().decode(ErrorResponse.self, from: data)
                            }
                            catch{
                            }
                        }
                        DispatchQueue.main.async {
                            response?(statusCode, nil, errorObj)
                        }
                    }
                    task.resume()
                } else {
    
                    DispatchQueue.main.async {
                        response?(0, nil, nil)
                    }
                }
                
            }else{
                response?(0, nil, nil)
            }
        }
    }
    //建立 Authenticator
    func getAuthenticator(response: ((_ statusCode: Int, _ dataObj: AuthenticatorResponse?, _ err: Error?) -> ())?) {
        getToken { success, token in
            if (success) {
                if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/member/authenticator") {
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
                    let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                        
                        var statusCode = 0
                        var dataObj: AuthenticatorResponse? = nil
                        
                        if let httpResponse = urlResponse as? HTTPURLResponse {
                            statusCode = httpResponse.statusCode
                        }
                        
                        if let data = data {
                            do {
                                dataObj = try JSONDecoder().decode(AuthenticatorResponse.self, from: data)
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
            }else{
                response?(0, nil, nil)
            }
        }
    }
    
    //綁定 Authenticator
    func bindAuthenticator(verificationCode: String, response: ((_ statusCode: Int, _ dataObj: Any?, _ err: ErrorResponse?) -> ())?) {
        getToken { success, token in
            if (success) {
                var params: [String: Any] = [String: Any]()
                params["verificationCode"] = verificationCode
                
                if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/member/authenticator-binding") {
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue( "application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
                    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
                    
                    do{
                        request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
                    } catch {
                    }
                    
                    let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                        
                        var statusCode = 0
                        var errorObj: ErrorResponse? = nil
                        
                        if let httpResponse = urlResponse as? HTTPURLResponse {
                            statusCode = httpResponse.statusCode
                        }
                        if let data = data {
                            do {
                                errorObj = try JSONDecoder().decode(ErrorResponse.self, from: data)
                            } catch {
                            }
                        }
                    
                        DispatchQueue.main.async {
                            response?(statusCode, nil, errorObj)
                        }
                    }
                    task.resume()
                }else{
                    DispatchQueue.main.async {
                        response?(0, nil, nil)
                    }
                }
            }else{
                response?(0, nil, nil)
            }
        }
    }
    
    //修改2FA設定
    func changeTwoAuth(verificationMethod: Int, response: ((_ statusCode: Int, _ dataObj: Any?, _ err: ErrorResponse?) -> ())?) {
        getToken { success, token in
            if (success) {
                var params: [String: Any] = [String: Any]()
                
                params["verificationMethod"] = verificationMethod
                
                if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/member/two-factor-authentication") {
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "PUT"
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
                    
                    do{
                        request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
                    } catch {
                        
                    }
                    
                    let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                        
                        var statusCode = 0
                        var errorObj: ErrorResponse? = nil
                        
                        if let httpResponse = urlResponse as? HTTPURLResponse {
                            statusCode = httpResponse.statusCode
                        }
                        if let data = data {
                            do {
                                errorObj = try JSONDecoder().decode(ErrorResponse.self, from: data)
                            } catch {
                            }
                        }
                        DispatchQueue.main.async {
                            response?(statusCode, nil, errorObj)
                        }
                    }
                    task.resume()
                } else {
                    DispatchQueue.main.async {
                        response?(0, nil, nil)
                    }
                }
                
            }else{
                response?(0, nil, nil)
            }
        }
    }
    
    //修改登入密碼
    func changeLoginPassword(verificationCode: String, currentPassword: String, newPassword: String, newConfirmPassword: String, response: ((_ statusCode: Int, _ dataObj: Any?, _ err: ErrorResponse?) -> ())?) {
        getToken { success, token in
            if (success) {
                var params: [String: Any] = [String: Any]()
                
                params["verificationCode"] = verificationCode
                params["currentPassword"] = currentPassword
                params["newPassword"] = newPassword
                params["newConfirmPassword"] = newConfirmPassword
                
                if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/member/login-password") {
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "PUT"
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
                    
                    do{
                        request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
                    } catch {
                        
                    }
                    let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                        
                        var statusCode = 0
                        var errorObj: ErrorResponse? = nil
                        
                        if let httpResponse = urlResponse as? HTTPURLResponse {
                            statusCode = httpResponse.statusCode
                        }
                        if let data = data {
                            do {
                                errorObj = try JSONDecoder().decode(ErrorResponse.self, from: data)
                            } catch {
                            }
                        }
                        
                        DispatchQueue.main.async {
                            response?(statusCode, nil, errorObj)
                        }
                    }
                    task.resume()
                } else {
                    DispatchQueue.main.async {
                        response?(0, nil, nil)
                    }
                }
            }else{
                response?(0, nil, nil)
            }
        }
    }
    //建立交易密碼
    func setTransactionPw(password: String, confirmPassword: String, verificationCode: String, response: ((_ statusCode: Int, _ dataObj: Any?, _ err: ErrorResponse?) -> ())?) {
        getToken { success, token in
            if (success) {
                
                var params: [String: Any] = [String: Any]()
                params["password"] = password
                params["confirmPassword"] = confirmPassword
                params["verificationCode"] = verificationCode
                
                if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/member/transaction-password") {
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
                    
                    do{
                        request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
                    } catch {
                        
                    }
                    
                    let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                
                        var statusCode = 0
                        var errorObj: ErrorResponse? = nil
                        
                        if let httpResponse = urlResponse as? HTTPURLResponse {
                            statusCode = httpResponse.statusCode
                        }
                        if let data = data {
                            do {
                                errorObj = try JSONDecoder().decode(ErrorResponse.self, from: data)
                            } catch {
                            }
                        }
                        
                        DispatchQueue.main.async {
                            response?(statusCode, nil, errorObj)
                        }
                    }
                    task.resume()
                }else{
                    DispatchQueue.main.async {
                        response?(0, nil, nil)
                    }
                }
            }else{
                response?(0, nil, nil)
            }
        }
    }
    //修改交易密碼
    func changeTranPassword(verificationCode: String, currentPassword: String, newPassword: String, newConfirmPassword: String, response: ((_ statusCode: Int, _ dataObj: Any?, _ err: ErrorResponse?) -> ())?) {
        getToken { success, token in
            if (success) {
                var params: [String: Any] = [String: Any]()
                
                params["verificationCode"] = verificationCode
                params["currentPassword"] = currentPassword
                params["newPassword"] = newPassword
                params["newConfirmPassword"] = newConfirmPassword
                params["token"] = token
                
                if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/member/transaction-password") {
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "PUT"
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
                    
                    do{
                        request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
                    } catch {
                        
                    }
                    
                    let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                        
                        var statusCode = 0
                        var errorObj: ErrorResponse? = nil
                        
                        if let httpResponse = urlResponse as? HTTPURLResponse {
                            statusCode = httpResponse.statusCode
                        }
                        if let data = data {
                            do {
                                errorObj = try JSONDecoder().decode(ErrorResponse.self, from: data)
                            } catch {
                            }
                        }
                        
                        DispatchQueue.main.async {
                            response?(statusCode, nil, errorObj)
                        }
                    }
                    task.resume()
                } else {
    
                    DispatchQueue.main.async {
                        response?(0, nil, nil)
                    }
                }
                
            }else{
                response?(0, nil, nil)
            }
        }
    }
    //設定登入與交易兩步驗證開關
    func setTwoAuthLogin(type: Int, enabled: Bool, response: ((_ statusCode: Int, _ dataObj: Any?, _ err: Error?) -> ())?) {
        getToken { success, token in
            if (success) {
                var params: [String: Any] = [String: Any]()
                var urlStr = ""
                
                params["enabled"] = enabled
                
                if (type == 0) {
                    urlStr = "https://dev-numiner-wallet.azurewebsites.net/api/v1/member/two-factor-authentication/login"
                }else{
                    urlStr = "https://dev-numiner-wallet.azurewebsites.net/api/v1/member/two-factor-authentication/transaction"
                }
                if let url = URL(string: urlStr) {
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "PUT"
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
                    
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
            }else{
                response?(0, nil, nil)
            }
        }
    }
    
    //新增KYC資訊
    func addKycInfo(kycInfo: [String: Any], response: ((_ statusCode: Int, _ dataObj: Any?, _ err: ErrorResponse?) -> ())?) {
        getToken { success, token in
            if (success) {
            
                if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/member/kyc") {
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
                    request.setValue( "application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
                    request.setValue( "application/json", forHTTPHeaderField: "Accept")
                    do{
                        request.httpBody = try JSONSerialization.data(withJSONObject: kycInfo, options: JSONSerialization.WritingOptions())
                    } catch {
                        
                    }
                    
                    let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                        
                        var statusCode = 0
                        var errorObj: ErrorResponse? = nil
                        if let httpResponse = urlResponse as? HTTPURLResponse {
                            statusCode = httpResponse.statusCode
                        }
                        
                        if (statusCode != 200) {
                            if let data = data {
                                print(String.init(data: data, encoding: String.Encoding.utf8) ?? "")
                                do {
                                    errorObj = try JSONDecoder().decode(ErrorResponse.self, from: data)
                                } catch {

                                }
                            }
                        }
                            
                        DispatchQueue.main.async {
                            response?(statusCode, nil, errorObj)
                        }
                    }
                    task.resume()
                }else{
                    DispatchQueue.main.async {
                        response?(0, nil, nil)
                    }
                }
            }else{
                response?(0, nil, nil)
            }
        }
    }
    
    //重置密碼
    func resetPassword(countryId: String, mobileNumber: String, verificationCode: String, password: String, confirmPassword: String, response: ((_ statusCode: Int, _ dataObj: Any?, _ err: ErrorResponse?) -> Void)?) {
        
        var params: [String: Any] = [String: Any]()
        
        params["countryId"] = countryId
        params["mobileNumber"] = mobileNumber
        params["verificationCode"] = verificationCode
        params["password"] = password
        params["confirmPassword"] = confirmPassword
        
        if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/member/reset-password") {
            
            var request = URLRequest(url: url)
            
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do{
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
            } catch {
                
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                
                var statusCode = 0
                var errorObj: ErrorResponse? = nil
                
                if let httpResponse = urlResponse as? HTTPURLResponse {
                    statusCode = httpResponse.statusCode
                }
                if let data = data {
                    if statusCode != 200 {
                        do {
                            errorObj = try JSONDecoder().decode(ErrorResponse.self, from: data)
                        } catch {
                        }
                    }
                }
                DispatchQueue.main.async {
                    response?(statusCode, nil, errorObj)
                }
            }
            task.resume()
        } else {
            
            DispatchQueue.main.async {
                response?(0, nil, nil)
            }
        }
    }
    
    //取得KYC資訊摘要
    func getKYCSummary(response: ((_ statusCode: Int, _ dataObj: KYCResoponse?, _ err: Error?) -> ())?) {
        getToken { success, token in
            if (success) {
                if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/member/authenticator") {
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "GET"
                    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
                    let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                        
                        var statusCode = 0
                        var dataObj: KYCResoponse? = nil
                        
                        if let httpResponse = urlResponse as? HTTPURLResponse {
                            statusCode = httpResponse.statusCode
                        }
                        
                        if let data = data {
                            do {
                                dataObj = try JSONDecoder().decode(KYCResoponse.self, from: data)
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
            }else{
                response?(0, nil, nil)
            }
        }
    }
    
    //取得會員登入BTM Qrcode
    func getLoginQrcode(response: ((_ statusCode: Int, _ dataStr: String?, _ err: Error?) -> ())?) {
        getToken { success, token in
            if (success) {
                if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/member/qr-code") {
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
                    let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                        
                        var statusCode = 0
                        var dataStr: String? = nil
                        
                        if let httpResponse = urlResponse as? HTTPURLResponse {
                            statusCode = httpResponse.statusCode
                        }
                        
                        if let data = data {
                            do {
                                //let data1 = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                                dataStr = String(data: data, encoding: .utf8)
                            } catch {

                            }
                        }
                        DispatchQueue.main.async {
                            response?(statusCode, dataStr, error)
                        }
                    }
                    task.resume()
                }else{
                    DispatchQueue.main.async {
                        response?(0, nil, nil)
                    }
                }
            }else{
                response?(0, nil, nil)
            }
        }
    }
    //取得首頁幣種清單
    func getCryptocurrency(headers: [String: String]?, response: ((_ statusCode: Int, _ dataObj: CryptoResponse?, _ err: Error?) -> Void)?) {

        if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/coins/summary") {
            
            var request = URLRequest(url: url)
            
            if let headers = headers {
                for (key, value) in headers {
                    request.addValue(value, forHTTPHeaderField: key)
                }
            }
            let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                
                var statusCode = 0
                var dataObj: CryptoResponse? = nil
                
                if let httpResponse = urlResponse as? HTTPURLResponse {
                    statusCode = httpResponse.statusCode
                }
                
                if let data = data {
                    do {
                        dataObj = try JSONDecoder().decode(CryptoResponse.self, from: data)
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
    
    //取得首頁幣種行情
    func getCryptoMarket(headers: [String: String]?, response: ((_ statusCode: Int, _ dataObj: CryptoMarketResponse?, _ err: Error?) -> Void)?) {

        if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/market/ticker24hr") {
            
            var request = URLRequest(url: url)
            
            if let headers = headers {
                for (key, value) in headers {
                    request.addValue(value, forHTTPHeaderField: key)
                }
            }
            let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                
                var statusCode = 0
                var dataObj: CryptoMarketResponse? = nil
                
                if let httpResponse = urlResponse as? HTTPURLResponse {
                    statusCode = httpResponse.statusCode
                }
                
                if let data = data {
                    do {
                        dataObj = try JSONDecoder().decode(CryptoMarketResponse.self, from: data)
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
    
    //取得會員資產清單
    func getAssets(response: ((_ statusCode: Int, _ dataObj: AssetResponse?, _ err: Error?) -> ())?) {
        getToken { success, token in
            if (success) {
                if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/assets") {
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "GET"
                    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
                    let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                        
                        var statusCode = 0
                        var dataObj: AssetResponse? = nil
                        
                        if let httpResponse = urlResponse as? HTTPURLResponse {
                            statusCode = httpResponse.statusCode
                        }
                        
                        if let data = data {
                            do {
                                dataObj = try JSONDecoder().decode(AssetResponse.self, from: data)
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
            }else{
                response?(0, nil, nil)
            }
        }
    }
    
    //取得會員推薦清單
    func getInvitations(response: ((_ statusCode: Int, _ dataObj: InvitationsResponse?, _ err: Error?) -> ())?) {
        getToken { success, token in
            if (success) {
                if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/member/invitations") {
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "GET"
                    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
                    let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                        
                        var statusCode = 0
                        var dataObj: InvitationsResponse? = nil
                        
                        if let httpResponse = urlResponse as? HTTPURLResponse {
                            statusCode = httpResponse.statusCode
                        }
                        
                        if let data = data {
                            do {
                                dataObj = try JSONDecoder().decode(InvitationsResponse.self, from: data)
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
            }else{
                response?(0, nil, nil)
            }
        }
    }
    
    //設定推薦人
    func setReferrer(invitationCode: String, response: ((_ statusCode: Int, _ dataObj: Any?, _ err: ErrorResponse?) -> ())?) {
        getToken { success, token in
            if (success) {
                var params: [String: Any] = [String: Any]()
                params["invitationCode"] = invitationCode
            
                if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/member/referrer") {
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
                    
                    do{
                        request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
                    } catch {
                    }
                    
                    var errorObj: ErrorResponse? = nil
                    
                    let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                        
                        var statusCode = 0
                        
                        if let httpResponse = urlResponse as? HTTPURLResponse {
                            statusCode = httpResponse.statusCode
                        }
                        
                        if let data = data {
                            do {
                                errorObj = try JSONDecoder().decode(ErrorResponse.self, from: data)
                            } catch {
                            }
                        }
                        
                        DispatchQueue.main.async {
                            response?(statusCode, nil, errorObj)
                        }
                    }
                    task.resume()
                } else {
    
                    DispatchQueue.main.async {
                        response?(0, nil, nil)
                    }
                }
            }else{
                response?(0, nil, nil)
            }
        }
    }
    
    //新增BTM賣出交易
    func getSellingOrder(dataStr: String, response: ((_ statusCode: Int, _ dataObj: SellingDetail?, _ err: ErrorResponse?) -> ())?) {
        getToken { success, token in
            if (success) {
            
                if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/orders/selling") {
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
                    
                    do{
                        let data = dataStr.data(using: .utf8)
                        request.httpBody = data
                    } catch {
                        
                    }
                    let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                        
                        var statusCode = 0
                        var dataObj: SellingDetail? = nil
                        var errorObj: ErrorResponse? = nil
                        if let httpResponse = urlResponse as? HTTPURLResponse {
                            statusCode = httpResponse.statusCode
                        }
                        
                        if let data = data {
                            do {
                                dataObj = try JSONDecoder().decode(SellingDetail.self, from: data)
                            } catch {
                            }
                            do {
                                errorObj = try JSONDecoder().decode(ErrorResponse.self, from: data)
                            } catch {
                            }
                        }

                        DispatchQueue.main.async {
                            response?(statusCode, dataObj, errorObj)
                        }
                    }
                    task.resume()
                } else {
                    DispatchQueue.main.async {
                        response?(0, nil, nil)
                    }
                }
            }else{
                response?(0, nil, nil)
            }
        }
    }
    
    //確認BTM賣出交易
    func setSellingOrder(orderId: String, response: ((_ statusCode: Int, _ dataObj: Any?, _ err: ErrorResponse?) -> ())?) {
        getToken { success, token in
            if (success) {
                var params: [String: Any] = [String: Any]()
                params["orderId"] = orderId
            
                if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/orders/selling") {
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "PUT"
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
                    
                    do{
                        request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
                    } catch {
                        
                    }
                    
                    let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                        
                        var statusCode = 0
                        var errorObj: ErrorResponse? = nil
                        
                        if let httpResponse = urlResponse as? HTTPURLResponse {
                            statusCode = httpResponse.statusCode
                        }
                        
                        if let data = data {
                            do {
                                errorObj = try JSONDecoder().decode(ErrorResponse.self, from: data)
                            } catch {
                            }
                        }
                        
                        DispatchQueue.main.async {
                            response?(statusCode, nil, errorObj)
                        }
                    }
                    task.resume()
                } else {
    
                    DispatchQueue.main.async {
                        response?(0, nil, nil)
                    }
                }
            }else{
                response?(0, nil, nil)
            }
        }
    }
    
    
    
    
}

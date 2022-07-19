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
    func sendVerificationCode(countryId: String, phoneNumber: String?, email: String?, verificationMethod: Int, verificationType: Int, response: ((_ statusCode: Int, _ dataObj: Any?, _ err: ErrorResponse?) -> Void)?) {
        
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

    //舊手機請求驗證碼(使用token)
    func getVerificationCode(verificationMethod: Int, verificationType: Int, response: ((_ statusCode: Int, _ dataObj: Any?, _ err: ErrorResponse?) -> ())?){
        
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
    func setTwoAuthLogin(type: Int, enabled: Bool, response: ((_ statusCode: Int, _ dataObj: Any?, _ err: ErrorResponse?) -> ())?) {
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
                if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/member/kyc/summary") {
                    
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
    func getLoginQrcode(response: ((_ statusCode: Int, _ dataStr: String?, _ err: ErrorResponse?) -> ())?) {
        getToken { success, token in
            if (success) {
                if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/member/qr-code") {
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
                    let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                        
                        var statusCode = 0
                        var dataStr: String? = nil
                        var errorObj: ErrorResponse? = nil
                        
                        if let httpResponse = urlResponse as? HTTPURLResponse {
                            statusCode = httpResponse.statusCode
                        }
                        
                        if let data = data {
                            do {
                                //let data1 = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                                dataStr = String(data: data, encoding: .utf8)
                                errorObj = try JSONDecoder().decode(ErrorResponse.self, from: data)
                            } catch {

                            }
                        }
                        DispatchQueue.main.async {
                            response?(statusCode, dataStr, errorObj)
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
    
    //取得指定幣種的美金漲跌幅，最後價格
    func getCryptoMarketUsd(coins: [String], response: ((_ statusCode: Int, _ dataObj: CryptoMarketResponse?, _ err: Error?) -> Void)?) {
        
        var urlCompoent = URLComponents(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/market/latest-quotes/usd")
        var value = ""
        for coin in coins {
            value += coin + ","
        }
        urlCompoent?.queryItems = [URLQueryItem(name: "Coin", value: value)]
        
        if let url = urlCompoent?.url {
            let request = URLRequest(url: url)
            
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
    func getSellingOrder(sellDic: [String: String], response: ((_ statusCode: Int, _ dataObj: SellingDetail?, _ err: ErrorResponse?) -> ())?) {
        getToken { success, token in
            if (success) {
            
                if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/orders/selling") {
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
                    
                    do{
                        request.httpBody = try JSONSerialization.data(withJSONObject: sellDic, options: JSONSerialization.WritingOptions())
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
    func putSellingOrder(orderId: String, transactionPassword: String, response: ((_ statusCode: Int, _ dataObj: Any?, _ err: ErrorResponse?) -> ())?) {
        getToken { success, token in
            if (success) {
                var params: [String: Any] = [String: Any]()
                params["orderId"] = orderId
                params["transactionPassword"] = transactionPassword
            
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
    
    //取得會員資產地址清單
    func getAssetAddress(coinId: String, response: ((_ statusCode: Int, _ dataObj: AssetAddress?, _ err: ErrorResponse?) -> ())?){
        getToken { success, token in
            if (success) {
                var urlCompoent = URLComponents(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/asset/addresses")
                urlCompoent?.queryItems = [URLQueryItem(name: "CoinId", value: coinId)]
                
                if let url = urlCompoent?.url {
                    
                    var request = URLRequest(url: url)
                    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
                    
                    let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                        
                        var statusCode = 0
                        var dataObj: AssetAddress? = nil
                        var errorObj: ErrorResponse? = nil

                        if let httpResponse = urlResponse as? HTTPURLResponse {
                            statusCode = httpResponse.statusCode
                        }

                        if let data = data {
                            do {
                                dataObj = try JSONDecoder().decode(AssetAddress.self, from: data)
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
    
    //請求會員資產地址
    func postAssetAddress(coinId: String, networkId: String, response: ((_ statusCode: Int, _ dataObj: PostAddress?, _ err: ErrorResponse?) -> ())?) {
        getToken { success, token in
            if (success) {
                
                var params: [String: Any] = [String: Any]()
                params["coinId"] = coinId
                params["networkId"] = networkId
            
                if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/asset/address") {
                    
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
                        var dataObj: PostAddress? = nil
                        var errorObj: ErrorResponse? = nil
                        
                        if let httpResponse = urlResponse as? HTTPURLResponse {
                            statusCode = httpResponse.statusCode
                        }
                        
                        if let data = data {
                            do {
                                dataObj = try JSONDecoder().decode(PostAddress.self, from: data)
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
    
    //取得出金配置訊息
    func getAssetWithdrawal(coinId: String, response: ((_ statusCode: Int, _ dataObj: WithdrawalResponse?, _ err: ErrorResponse?) -> ())?){
        getToken { success, token in
            if (success) {
                var urlCompoent = URLComponents(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/asset/withdrawal/configurations")
                urlCompoent?.queryItems = [URLQueryItem(name: "CoinId", value: coinId)]
                
                if let url = urlCompoent?.url {
                    
                    var request = URLRequest(url: url)
                    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
                    
                    let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                        
                        var statusCode = 0
                        var dataObj: WithdrawalResponse? = nil
                        var errorObj: ErrorResponse? = nil

                        if let httpResponse = urlResponse as? HTTPURLResponse {
                            statusCode = httpResponse.statusCode
                        }

                        if let data = data {
                            do {
                                dataObj = try JSONDecoder().decode(WithdrawalResponse.self, from: data)
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
    //建立出金請求
    func postWithdrawal(withdrawDic: [String: Any], response: ((_ statusCode: Int, _ transactionId: Transaction?, _ err: ErrorResponse?) -> ())?) {
        getToken { success, token in
            if (success) {
                
                if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/asset/withdrawal") {
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
                    
                    do{
                        request.httpBody = try JSONSerialization.data(withJSONObject: withdrawDic, options: JSONSerialization.WritingOptions())
                    } catch {
                        
                    }
                    
                    let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                        
                        var statusCode = 0
                        var transactionId: Transaction? = nil
                        var errorObj: ErrorResponse? = nil
                        
                        if let httpResponse = urlResponse as? HTTPURLResponse {
                            statusCode = httpResponse.statusCode
                        }
                        
                        if let data = data {
                            do {
                                transactionId = try JSONDecoder().decode(Transaction.self, from: data)
                                errorObj = try JSONDecoder().decode(ErrorResponse.self, from: data)
                            } catch {
                            }
                        }

                        DispatchQueue.main.async {
                            response?(statusCode, transactionId, errorObj)
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
    //取得入金歷史紀錄
    func getDepositHistory(response: ((_ statusCode: Int, _ dataObj: TransactionHistory?, _ err: Error?) -> ())?) {
        getToken { success, token in
            if (success) {
                if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/asset/deposits") {
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "GET"
                    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
                    let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                        
                        var statusCode = 0
                        var dataObj: TransactionHistory? = nil
                        
                        if let httpResponse = urlResponse as? HTTPURLResponse {
                            statusCode = httpResponse.statusCode
                        }
                        
                        if let data = data {
                            do {
                                dataObj = try JSONDecoder().decode(TransactionHistory.self, from: data)
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
    
    //取得出金歷史紀錄
    func getWithdrawHistory(response: ((_ statusCode: Int, _ dataObj: TransactionHistory?, _ err: Error?) -> ())?) {
        getToken { success, token in
            if (success) {
                if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/asset/withdrawals") {
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "GET"
                    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
                    let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                        
                        var statusCode = 0
                        var dataObj: TransactionHistory? = nil
                        
                        if let httpResponse = urlResponse as? HTTPURLResponse {
                            statusCode = httpResponse.statusCode
                        }
                        
                        if let data = data {
                            do {
                                dataObj = try JSONDecoder().decode(TransactionHistory.self, from: data)
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
    //取得入金明細
    func getDepositList(transactionId: String, response: ((_ statusCode: Int, _ dataObj: DepositList?, _ err: Error?) -> ())?) {
        getToken { success, token in
            if (success) {
                var urlCompoent = URLComponents(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/asset/deposit")
                urlCompoent?.queryItems = [URLQueryItem(name: "transactionId", value: transactionId)]
                
                if let url = urlCompoent?.url {
                    
                    var request = URLRequest(url: url)
                    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
                    
                    let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                        
                        var statusCode = 0
                        var dataObj: DepositList? = nil

                        if let httpResponse = urlResponse as? HTTPURLResponse {
                            statusCode = httpResponse.statusCode
                        }

                        if let data = data {
                            do {
                                dataObj = try JSONDecoder().decode(DepositList.self, from: data)
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
            }else{
                response?(0, nil, nil)
            }
        }
    }
    //取得出金明細
    func getWithdrawList(transactionId: String, response: ((_ statusCode: Int, _ dataObj: WithdrawList?, _ err: Error?) -> ())?) {
        getToken { success, token in
            if (success) {
                var urlCompoent = URLComponents(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/asset/withdrawal")
                urlCompoent?.queryItems = [URLQueryItem(name: "transactionId", value: transactionId)]
                
                if let url = urlCompoent?.url {
                    
                    var request = URLRequest(url: url)
                    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
                    
                    let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                        
                        var statusCode = 0
                        var dataObj: WithdrawList? = nil

                        if let httpResponse = urlResponse as? HTTPURLResponse {
                            statusCode = httpResponse.statusCode
                        }

                        if let data = data {
                            do {
                                dataObj = try JSONDecoder().decode(WithdrawList.self, from: data)
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
            }else{
                response?(0, nil, nil)
            }
        }
    }
    //取得BTM入金明細
    func getBtmDeposit(transactionId: String, response: ((_ statusCode: Int, _ dataObj: BtmTransactionList?, _ err: ErrorResponse?) -> ())?) {
        getToken { success, token in
            if (success) {
                var urlCompoent = URLComponents(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/asset/btm/deposit")
                urlCompoent?.queryItems = [URLQueryItem(name: "transactionId", value: transactionId)]
                
                if let url = urlCompoent?.url {
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "GET"
                    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
                    
                    let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                        
                        var statusCode = 0
                        var dataObj: BtmTransactionList? = nil
                        var errorObj: ErrorResponse? = nil

                        if let httpResponse = urlResponse as? HTTPURLResponse {
                            statusCode = httpResponse.statusCode
                        }

                        if let data = data {
                            do {
                                dataObj = try JSONDecoder().decode(BtmTransactionList.self, from: data)
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
    //取得BTM出金明細
    func getBtmWithdrawal(transactionId: String, response: ((_ statusCode: Int, _ dataObj: BtmTransactionList?, _ err: ErrorResponse?) -> ())?) {
        getToken { success, token in
            if (success) {
                var urlCompoent = URLComponents(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/asset/btm/withdrawal")
                urlCompoent?.queryItems = [URLQueryItem(name: "transactionId", value: transactionId)]
                
                if let url = urlCompoent?.url {
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "GET"
                    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
                    
                    let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                        
                        var statusCode = 0
                        var dataObj: BtmTransactionList? = nil
                        var errorObj: ErrorResponse? = nil

                        if let httpResponse = urlResponse as? HTTPURLResponse {
                            statusCode = httpResponse.statusCode
                        }

                        if let data = data {
                            do {
                                dataObj = try JSONDecoder().decode(BtmTransactionList.self, from: data)
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
    //取得Swap幣種清單
    func getSwapCoins(response: ((_ statusCode: Int, _ dataObj: SwapResponse?, _ err: Error?) -> ())?) {
        if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/swap/coins") {
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                
                var statusCode = 0
                var dataObj: SwapResponse? = nil
                
                if let httpResponse = urlResponse as? HTTPURLResponse {
                    statusCode = httpResponse.statusCode
                }
                
                if let data = data {
                    do {
                        dataObj = try JSONDecoder().decode(SwapResponse.self, from: data)
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
    //取得Swap交易匯率
    func getSwapRate(fromCoin: String, toCoin: String, response: ((_ statusCode: Int, _ dataObj: SwapRate?, _ err: ErrorResponse?) -> ())?) {
        
        var urlCompoent = URLComponents(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/swap/exchange-rate")
        urlCompoent?.queryItems = [URLQueryItem(name: "FromCoinId", value: fromCoin), URLQueryItem(name: "ToCoinId", value: toCoin)]
        
        if let url = urlCompoent?.url {
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                
                var statusCode = 0
                var dataObj: SwapRate? = nil
                var errorObj: ErrorResponse? = nil

                if let httpResponse = urlResponse as? HTTPURLResponse {
                    statusCode = httpResponse.statusCode
                }

                if let data = data {
                    do {
                        dataObj = try JSONDecoder().decode(SwapRate.self, from: data)
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
    //建立Swap交易
    func postSwapOrder(fromCoinId: String, toCoinId: String, quantity: String, response: ((_ statusCode: Int, _ dataObj: SwapOrder?, _ err: ErrorResponse?) -> ())?) {
        getToken { success, token in
            if (success) {
                var params: [String: Any] = [String: Any]()
                
                params["fromCoinId"] = fromCoinId
                params["toCoinId"] = toCoinId
                params["quantity"] = quantity
                
                if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/swap") {
                    
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
                        var dataObj: SwapOrder? = nil
                        var errorObj: ErrorResponse? = nil
                        
                        if let httpResponse = urlResponse as? HTTPURLResponse {
                            statusCode = httpResponse.statusCode
                        }
                        if let data = data {
                            do {
                                dataObj = try JSONDecoder().decode(SwapOrder.self, from: data)
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
    //確認Swap交易
    func postSwapCompletion(transactionId: String, transactionPassword: String, response: ((_ statusCode: Int, _ dataObj: Any?, _ err: ErrorResponse?) -> ())?) {
        getToken { success, token in
            if (success) {
                var params: [String: Any] = [String: Any]()
                
                params["transactionId"] = transactionId
                params["transactionPassword"] = transactionPassword
                
                if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/swap/completion") {
                    
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
    //取得Swap歷史紀錄
    func getSwapHistory(response: ((_ statusCode: Int, _ dataObj: SwapHistory?, _ err: Error?) -> ())?) {
        getToken { success, token in
            if (success) {
                if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/swap/histories") {
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "GET"
                    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
                    let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                        
                        var statusCode = 0
                        var dataObj: SwapHistory? = nil
                        
                        if let httpResponse = urlResponse as? HTTPURLResponse {
                            statusCode = httpResponse.statusCode
                        }
                        
                        if let data = data {
                            do {
                                dataObj = try JSONDecoder().decode(SwapHistory.self, from: data)
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
    //取得公布欄清單
    func getBoardList(startOn: String,endOn: String ,response: ((_ statusCode: Int, _ dataObj: BoardList?, _ err: Error?) -> ())?) {
        getToken { success, token in
            if (success) {
                
                var urlCompoent = URLComponents(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/bulletin-board")
                urlCompoent?.queryItems = [URLQueryItem(name: "StartOn", value: startOn), URLQueryItem(name: "EndOn", value: endOn)]
                
                if let url = urlCompoent?.url { 
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "GET"
                    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
                    let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                        
                        var statusCode = 0
                        var dataObj: BoardList? = nil
                        
                        if let httpResponse = urlResponse as? HTTPURLResponse {
                            statusCode = httpResponse.statusCode
                        }
                        
                        if let data = data {
                            do {
                                dataObj = try JSONDecoder().decode(BoardList.self, from: data)
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
    //刪除帳號
    func postDeleteMember(loginPassword: String, response: ((_ statusCode: Int, _ dataObj: Any?, _ err: ErrorResponse?) -> ())?) {
        getToken { success, token in
            if (success) {
                var params: [String: Any] = [String: Any]()
                
                params["loginPassword"] = loginPassword
                
                if let url = URL(string: "https://dev-numiner-wallet.azurewebsites.net/api/v1/member/deletion") {
                    
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

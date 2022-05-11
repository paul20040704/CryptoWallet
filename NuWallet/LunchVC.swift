//
//  LunchVC.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/14.
//

import UIKit
import LocalAuthentication

class LunchVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //預設FaceID/TouchID關閉
        let faceId = UD.bool(forKey: "faceId")
        
        if judgeRefreshToken() {
            if (faceId) {
                createFaceID()
            }else{
                goMain()
            }
        }else{
            goLogin()
        }
    }
    
    func judgeRefreshToken() -> Bool{
        if let data = UD.data(forKey: "token"), let token = try? PDecoder.decode(TokenResponse.self,  from: data){
            let nowT = US.getTimeInterval()
            let reTokenT = token.refreshTokenExpiryTime
            if (nowT > reTokenT){
                return false
            }else{
                return true
            }
        }else{
            return false
        }
    }
    
    func createFaceID() {
        let context = LAContext()
        context.localizedCancelTitle = "Cancel"
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Login to your account"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                if success {
                    DispatchQueue.main.async {
                        goMain()
                    }
                }else{
                    DispatchQueue.main.async {
                        goLogin()
                    }
                }
            }
        }else {
            let alertC = showAlert(title: "Failed", message: error?.localizedDescription)
            self.present(alertC, animated: true, completion: nil)
        }
        
    }
    

    

}

import UIKit

class WelcomeNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navi background color
        navigationBar.backgroundColor = UIColor.clear
        // navi button text color
        navigationBar.tintColor = UIColor.white
        // title text color
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        if judgeRefreshToken() {
            goMain()
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
    
    
}

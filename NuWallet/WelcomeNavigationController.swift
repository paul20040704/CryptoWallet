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
        
        
    }
    

    
    
}

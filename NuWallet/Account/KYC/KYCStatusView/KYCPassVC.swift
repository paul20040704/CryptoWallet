//
//  KYCPassVC.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/21.
//

import UIKit
import PKHUD

class KYCPassVC: UIViewController {
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var nationalityLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        // Do any additional setup after loading the view.
    }
    
    func setUI() {
        HUD.show(.systemActivity)
        BN.getKYCSummary { statusCode, dataObj, err in
            HUD.hide()
            if let data = dataObj {
                let firstName = data.firstName ?? ""
                let lastName = data.lastName ?? ""
                self.typeLabel.text = data.typeOfCertificate ?? ""
                self.nationalityLabel.text = data.nationality ?? ""
                self.nameLabel.text = firstName + lastName
                self.birthdayLabel.text = data.bitrhday ?? ""
            }
        }
    }
   

}

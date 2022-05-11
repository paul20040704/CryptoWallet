//
//  MainBtmQrcodeVC.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/22.
//

import UIKit
import PKHUD

class MainBtmQrcodeVC: UIViewController {

    @IBOutlet weak var qrcodeImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "btm".localized
        updateQrcode()
    }
    

    func updateQrcode() {
        HUD.show(.systemActivity)
        BN.getLoginQrcode { statusCode, dataStr, err in
            HUD.hide()
            if (statusCode == 200) {
                if let str = dataStr {
                    self.qrcodeImage.image = self.createQrcode(str: str)
                }
            }
        }
    }
    
    func createQrcode(str: String) -> UIImage? {
        let strData = str.data(using: .utf8, allowLossyConversion: false)
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        qrFilter?.setValue(strData, forKey: "inputMessage")
        qrFilter?.setValue("H", forKey: "inputCorrectionLevel")
        let qrCIImage = qrFilter?.outputImage
        let codeImage = UIImage(ciImage: qrCIImage!)
        return codeImage
    }
    
    
    
}

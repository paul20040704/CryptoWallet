//
//  GoogleAuthVC.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/13.
//

import UIKit
import PKHUD

class GoogleAuthVC: UIViewController {

    @IBOutlet weak var copyBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var qrcodeImage: UIImageView!
    @IBOutlet weak var keyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "authenticator".localized
        self.navigationItem.backButtonTitle = ""
        setUI()
        updateQrcode()
        // Do any additional setup after loading the view.
    }
    

    func setUI() {
        copyBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: copyBtn.frame.height / 2)
        copyBtn.addTarget(self, action: #selector(copyBtnClick), for: UIControl.Event.touchUpInside)
        
        nextBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.nextBtn.frame.height / 2)
        nextBtn.addTarget(self, action: #selector(nextBtnClick), for: UIControl.Event.touchUpInside)
    }
    
    @objc func copyBtnClick() {
        UIPasteboard.general.string = keyLabel.text
        HUD.flash(.label("copy_text".localized), delay: 1.0)
    }
    
    @objc func nextBtnClick() {
        let GoogleAuth2VC = UIStoryboard(name: "GoogleAuth", bundle: nil).instantiateViewController(withIdentifier: "GoogleAuth2VC") as! GoogleAuth2VC
        self.navigationController?.show(GoogleAuth2VC, sender: nil)
    }
    
    func updateQrcode() {
        HUD.show(.systemActivity)
        BN.getAuthenticator { [self] statusCode, dataObj, err in
            if (statusCode == 200){
                HUD.hide()
                if let data = dataObj {
                    self.keyLabel.text = data.manualSetupKey ?? ""
                    self.createQrcode(str: data.qrCodeImage ?? "")
                }
            }else{
                HUD.hide()
            }
        }
    }
    
    func createQrcode(str: String) {
        
        let qrcodeStr = str.replacingOccurrences(of:"data:image/png;base64,",with:"")
        if let data: Data = Data(base64Encoded: qrcodeStr, options: Data.Base64DecodingOptions.ignoreUnknownCharacters) {
            qrcodeImage.image = UIImage(data: data)
        }
    }
    
}

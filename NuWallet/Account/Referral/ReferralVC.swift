//
//  ReferralVC.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/4/28.
//

import UIKit
import Photos
import PKHUD

class ReferralVC: UIViewController {
    
    @IBOutlet weak var qrcodeImage: UIImageView!
    @IBOutlet weak var inviteLabel: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var historyView: UIView!
    @IBOutlet weak var inviteListView: UIView!
    @IBOutlet weak var setupView: UIView!
    
    var invitationCode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setTap()
    }
    
    func setUI() {
        self.navigationItem.title = "referral_reward".localized
        self.navigationItem.backButtonTitle = ""
        
        //qrcodeImage.image = createQrcode(str: invitationCode)
        createQrcode(str: invitationCode)
        if let data = qrcodeImage.image?.jpegData(compressionQuality: 0.7) {
            qrcodeImage.image = UIImage.init(data: data)
        }
        inviteLabel.text = invitationCode
        
        saveBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: saveBtn.frame.height / 2)
        saveBtn.addTarget(self, action: #selector(saveClick), for: UIControl.Event.touchUpInside)
    }
    
    func createQrcode(str: String) {
        DispatchQueue.main.async {
            let strData = str.data(using: .utf8, allowLossyConversion: false)
            let qrFilter = CIFilter(name: "CIQRCodeGenerator")
            qrFilter?.setValue(strData, forKey: "inputMessage")
            qrFilter?.setValue("H", forKey: "inputCorrectionLevel")
            if let qrCIImage = qrFilter?.outputImage {
                let scaleX = self.qrcodeImage.frame.size.width / qrCIImage.extent.size.width
                let scaleY = self.qrcodeImage.frame.size.height / qrCIImage.extent.size.height
                let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
                let output = qrCIImage.transformed(by: transform)
                
                self.qrcodeImage.image = UIImage(ciImage: output)
            
            }
        }
    }
    
    @objc func saveClick() {
        if let image = qrcodeImage.image {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(downloadImage(image:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    @objc func downloadImage(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {

        if didFinishSavingWithError != nil {
            print("錯誤")
            return
        }
        HUD.flash(.label("save_picture_hint".localized), delay: 1.0)
    }
    
    func setTap() {
        historyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.singleTap(_:))))
        inviteListView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.singleTap(_:))))
        setupView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.singleTap(_:))))
    }
    
    @objc func singleTap(_ recognizer:UITapGestureRecognizer){
        let tag = recognizer.view?.tag
        switch tag! {
        case 0 :
            print("select first view")
        case 1 :
            let inviteListVC = UIStoryboard(name: "Referral", bundle: nil).instantiateViewController(withIdentifier: "InviteListVC")
            self.navigationController?.show(inviteListVC, sender: nil)
        case 2 :
            let referralCodeVC = UIStoryboard(name: "Referral", bundle: nil).instantiateViewController(withIdentifier: "ReferralCodeVC")
            self.navigationController?.show(referralCodeVC, sender: nil)
        default:
            print("default")
        }
    }
    
    
    
}

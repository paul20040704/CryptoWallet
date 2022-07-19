//
//  KYCVerificaion3VC.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/18.
//

import UIKit
import PKHUD
import AVFoundation

class KYCVerification3VC: UIViewController, SelectDelegate {

    @IBOutlet weak var selectLabel: PaddingLabel!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var exampleBtn: UIButton!
    @IBOutlet weak var frontImage: UIImageView!
    @IBOutlet weak var frontBtn: UIButton!
    @IBOutlet weak var frontChangeBtn: UIButton!
    
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var backChangeBtn: UIButton!
    
    @IBOutlet weak var holdImage: UIImageView!
    @IBOutlet weak var holdBtn: UIButton!
    @IBOutlet weak var holdChangeBtn: UIButton!
    
    @IBOutlet weak var proofImage: UIImageView!
    @IBOutlet weak var proofBtn: UIButton!
    @IBOutlet weak var proofChangeBtn: UIButton!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var threeLabel: UILabel!
    
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lastView: UIView!
    
    @IBOutlet weak var remindLabel: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    var selectImageType = 0
    var viewType = 0 //駕照頁或是護照頁
    
    var kycOptionsResponse: KYCOptionsResponse?
    var typeCertificateDic = Dictionary<Int, String>()
    
    var kycDic = Dictionary<String, Any>() //最後送出的資訊
    var isCanNext = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "account_verification".localized
        setUI()
        
    }
    
    func setUI() {
        selectLabel.text = "Driver license card"
        
        selectBtn.setBackgroundVerticalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nil)
        selectBtn.addTarget(self, action: #selector(selectBtnClick), for: .touchUpInside)
        
        exampleBtn.addTarget(self, action: #selector(showExample(btn:)), for: .touchUpInside)
        let yourAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.init(hex: "#1F892B"), .underlineStyle: NSUnderlineStyle.single.rawValue]
        exampleBtn.setAttributedTitle(NSAttributedString(string: "example".localized, attributes: yourAttributes), for: .normal)
        
        frontBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.frontBtn.frame.height / 2)
        frontBtn.addTarget(self, action: #selector(uploadBtnClick(btn:)), for: UIControl.Event.touchUpInside)
        
        frontChangeBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.frontChangeBtn.frame.height / 2)
        frontChangeBtn.addTarget(self, action: #selector(uploadBtnClick(btn:)), for: UIControl.Event.touchUpInside)
        
        backBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.backBtn.frame.height / 2)
        backBtn.addTarget(self, action: #selector(uploadBtnClick(btn:)), for: UIControl.Event.touchUpInside)
        
        holdBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.holdBtn.frame.height / 2)
        holdBtn.addTarget(self, action: #selector(uploadBtnClick(btn:)), for: UIControl.Event.touchUpInside)
        
        holdChangeBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.holdChangeBtn.frame.height / 2)
        holdChangeBtn.addTarget(self, action: #selector(uploadBtnClick(btn:)), for: UIControl.Event.touchUpInside)
        
        proofBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.proofBtn.frame.height / 2)
        proofBtn.addTarget(self, action: #selector(uploadBtnClick(btn:)), for: UIControl.Event.touchUpInside)
        
        proofChangeBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.proofChangeBtn.frame.height / 2)
        proofChangeBtn.addTarget(self, action: #selector(uploadBtnClick(btn:)), for: UIControl.Event.touchUpInside)
        
        backChangeBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.backChangeBtn.frame.height / 2)
        backChangeBtn.addTarget(self, action: #selector(uploadBtnClick(btn:)), for: UIControl.Event.touchUpInside)
        
        nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.nextBtn.frame.height / 2)
        nextBtn.addTarget(self, action: #selector(nextBtnClick), for: UIControl.Event.touchUpInside)
    }
    
    @objc func selectBtnClick() {
        showSelectView(tag: 0,arr: ["Driver license card", "Passport"])
    }
    
    func showSelectView(tag: Int,arr: Array<String>) {
        let selectVC = UIStoryboard(name: "SelectVC", bundle: nil).instantiateViewController(withIdentifier: "SelectVC") as! SelectVC
        selectVC.tag = tag
        selectVC.page = 3
        selectVC.selectArr = arr
        selectVC.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        selectVC.delegate = self
        self.present(selectVC, animated: true, completion: nil)
    }
    
    @objc func showExample(btn: UIButton) {
        switch btn.tag{
        case 0:
            ExampleLicenseView.exampleLicenseView.showMe()
        default:
            ExamplePassportView.examplePassportView.showMe()
        }
    }
    
    @objc func uploadBtnClick(btn: UIButton) {
        
        selectImageType = btn.tag
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
                case .notDetermined:
                    AVCaptureDevice.requestAccess(for: .video) { success in
                        guard success == true else{return}
                        self.present(imagePicker, animated: true, completion: nil)
                    }
                case .denied, .restricted:
                    let alertVC = UIAlertController(title: "相機開啟失敗", message: "相機服務未啟用", preferredStyle: .alert)
                    let action = UIAlertAction(title: "去設定", style: .destructive) {(_) in
                        guard let settingUrl = URL(string: UIApplication.openSettingsURLString) else {return}
                        
                        if UIApplication.shared.canOpenURL(settingUrl) {
                            UIApplication.shared.open(settingUrl)
                        }
                    }
                    alertVC.addAction(action)
                    let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                    alertVC.addAction(cancel)
                    self.present(alertVC, animated: true, completion: nil)
                    
                case .authorized:
                    present(imagePicker, animated: true, completion: nil)
                default:
                    break
                }
        
        
//        imagePicker.modalPresentationStyle = .overFullScreen
//        imagePicker.allowsEditing = true
   //     imagePicker.showsCameraControls = false
        
    }
    
    @objc func nextBtnClick() {
        if (viewType == 0) {
            kycDic["typeOfCertificate"] = 1
        }else {
            kycDic["typeOfCertificate"] = 2
        }
        
        if (isCanNext) {
            HUD.show(.systemActivity)
            BN.addKycInfo(kycInfo: kycDic) { statusCode, dataObj, err in
                if (statusCode == 200) {
                    HUD.hide()
                    let FinishVC = UIStoryboard(name: "FinishVC", bundle: nil).instantiateViewController(withIdentifier: "FinishVC") as! FinishVC
                    FinishVC.kycVerification3VC = self
                    FinishVC.tag = 7
                    FinishVC.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
                    self.present(FinishVC, animated: true, completion: nil)
                }else{
                    HUD.hide()
                    FailView.failView.showMe(error: err?.exception ?? "Upload kyc info fail.")
                }
            }
       }
    }
    
    func judgeIsCanNext() {
        switch viewType {
        case 0:
            if (kycDic["frontPhoto"] != nil && kycDic["backPhoto"] != nil && kycDic["holdingPhoto"] != nil && kycDic["proofOfAddressPhoto"] != nil) {
                isCanNext = true
                remindLabel.isHidden = true
                self.nextBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.nextBtn.frame.height / 2)
            }
        default:
            if (kycDic["frontPhoto"] != nil && kycDic["holdingPhoto"] != nil && kycDic["proofOfAddressPhoto"] != nil) {
                isCanNext = true
                remindLabel.isHidden = true
                self.nextBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.nextBtn.frame.height / 2)
            }
        }
    }
    
    func imageToBase64String(image: UIImage) -> String {
        let scaleImage = image.resizeImage()
        if let imageData = scaleImage.jpegData(compressionQuality: 0.7) {
            let str = imageData.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
            return "data:image/jpeg;base64," + str
        }
        if let imageData = scaleImage.pngData() {
            let str = imageData.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
            return "data:image/png;base64," + str
        }else{
            return ""
        }
        
    }
    
    //Delegate
    func updateOption(tag: Int, condition: String) {
        if (condition == "Driver license card") {
            if (viewType != 0) {
                viewType = 0
                changeView()
            }
        }
        else if (condition == "Passport") {
            if (viewType != 1) {
                viewType = 1
                changeView()
            }
        }
    }
    
    func changeView() {
        switch viewType {
        case 0:
            self.lastView.isHidden = false
            self.viewHeightConstraint.constant = 1600
            self.exampleBtn.tag = 0
            self.selectLabel.text = "Driver license card"
            self.firstLabel.text = "certificate_front".localized
            self.secondLabel.text = "certificate_back".localized
            self.threeLabel.text = "certificate_holding_photo".localized
        default:
            self.lastView.isHidden = true
            self.viewHeightConstraint.constant = 1350
            self.exampleBtn.tag = 1
            self.selectLabel.text = "Passport"
            self.firstLabel.text = "certificate_front_passport".localized
            self.secondLabel.text = "certificate_holding_photo".localized
            self.threeLabel.text = "certificate_address_proof".localized
        }

    }
    
}

extension KYCVerification3VC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            
            let base64Str = imageToBase64String(image: image)
            switch selectImageType {
            case 0:
                self.frontImage.image = image
                self.frontBtn.isHidden = true
                self.frontChangeBtn.isHidden = false
                kycDic["frontPhoto"] = base64Str
            case 1:
                self.backImage.image = image
                self.backBtn.isHidden = true
                self.backChangeBtn.isHidden = false
                if (viewType == 0) {
                    kycDic["backPhoto"] = base64Str
                }else{
                    kycDic["holdingPhoto"] = base64Str
                }
            case 2:
                self.holdImage.image = image
                self.holdBtn.isHidden = true
                self.holdChangeBtn.isHidden = false
                if (viewType == 0) {
                    kycDic["holdingPhoto"] = base64Str
                }else{
                    kycDic["proofOfAddressPhoto"] = base64Str
                }
            case 3:
                self.proofImage.image = image
                self.proofBtn.isHidden = true
                self.proofChangeBtn.isHidden = false
                if (viewType == 0) {
                    kycDic["proofOfAddressPhoto"] = base64Str
                }
            default:
                break
            }
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            judgeIsCanNext()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("imagePickerControllerDidCancel")
        picker.dismiss(animated: true, completion: nil) // 退出相機介面
    }
    
    
//    func drawImage(originalImage: UIImage) -> UIImage {
//        let renderer = UIGraphicsImageRenderer(size: CGSize(width: originalImage.size.width, height: originalImage.size.height / 1.2))
//        let image = renderer.image { context in
//            originalImage.draw(at: CGPoint(x: 0, y: -(ScreenHeight / 4)))
//        }
//        return image
//    }
  
}



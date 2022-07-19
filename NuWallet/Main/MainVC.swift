//
//  MainVC.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/22.
//

import UIKit
import PKHUD
import AVFoundation

class MainVC: UIViewController, scanQrcodeDelegate {

    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var payBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUI()
    }
    
    func setUI() {
        nextBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
        nextBtn.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
        
        payBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: payBtn.frame.height / 2)
        payBtn.addTarget(self, action: #selector(payClick), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        HUD.show(.systemActivity, onView: self.view)
        BN.getMember { statusCode, dataObj, err in
            HUD.hide()
        }
    }
    
    @objc func nextClick() {
        let memberInfo = US.getMemberInfo()
        let level = memberInfo?.memberLevel ?? 1
        //let level = 2
        let kycStatus = memberInfo?.memberKycStatus ?? 0
        if (level != 2) {
            FailGoView.failGoView.showMe(type: 0, status: kycStatus, vc: self)
        }else{
            let mainBtmQrcodeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainBtmQrcodeVC")
            self.navigationController?.show(mainBtmQrcodeVC, sender: nil)
        }
        
    }
    
    @objc func payClick() {
        let memberInfo = US.getMemberInfo()
        let enable = memberInfo?.withdrawalEnabled ?? false
        //let enable = true
        let level = memberInfo?.memberLevel ?? 1
        //let level = 2
        let kycStatus = memberInfo?.memberKycStatus ?? 0
        
        let setted = memberInfo?.wasTransactionPasswordSetted ?? false
        //let setted = false
        if level != 2{
            FailGoView.failGoView.showMe(type: 0, status: kycStatus, vc: self)
        }
        else if !(enable) {
            FailGoView.failGoView.showMe(type: 1, status: 0, vc: self)
        }
        else if !(setted) {
            FailGoView.failGoView.showMe(type: 2, status: 0, vc: self)
        }else{
            switch AVCaptureDevice.authorizationStatus(for: .video) {
                    case .notDetermined:
                        AVCaptureDevice.requestAccess(for: .video) { success in
                            guard success == true else{return}
                            DispatchQueue.main.async {
                                let scanQrcodeVC = ScanQrcodeVC()
                                scanQrcodeVC.delegate = self
                                self.present(scanQrcodeVC, animated: true, completion: nil)
                            }
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
                        let scanQrcodeVC = ScanQrcodeVC()
                        scanQrcodeVC.delegate = self
                        self.present(scanQrcodeVC, animated: true, completion: nil)
                    default:
                        break
            }
        }
    }
    
    func getQrcodeStr(qrStr: String) {
        //let str = "{\"vector\":\"456\",\"content\":\"123\"}"
        guard let qrDic = convertToDic(text: qrStr) else{return}
        HUD.show(.systemActivity)
        BN.getSellingOrder(sellDic: qrDic) { statusCode, dataObj, err in
            HUD.hide()
            if (statusCode == 200) {
                let sellingOrderVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SellingOrderVC") as! SellingOrderVC
                sellingOrderVC.sellingDetil = dataObj
                self.navigationController?.show(sellingOrderVC, sender: nil)
            }else{
                FailView.failView.showMe(error: err?.exception ?? "Get Selling Order Fail.")
            }
        }
    }
    
    func convertToDic(text: String) -> [String:String]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:String]
            }
            catch{
                FailView.failView.showMe(error: error.localizedDescription)
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
}

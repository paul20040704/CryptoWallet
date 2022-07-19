//
//  ReferralCodeVC.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/4/28.
//

import UIKit
import PKHUD
import AVFoundation

class ReferralCodeVC: UIViewController, scanQrcodeDelegate {

    @IBOutlet weak var codeTF: UITextField!
    @IBOutlet weak var scanBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    
    var isCanNext = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        // Do any additional setup after loading the view.
    }
    

    func setUI() {
        self.navigationItem.title = "referral_reward".localized
        codeTF.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "referral_code_placeholder".localized, placeholderColorHex: "393939")
        codeTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        scanBtn.addTarget(self, action: #selector(scanClick), for: .touchUpInside)
        
        confirmBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: confirmBtn.frame.height / 2)
        confirmBtn.addTarget(self, action: #selector(confirmClick), for: .touchUpInside)
    }
    
    @objc func scanClick() {
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        judgeCanNext()
    }
    
    func judgeCanNext() {
        
        var isCodeFilled = false
        if let code = codeTF.text {
            if (code.count > 0) {
                isCodeFilled = true
            }
        }
        if (isCodeFilled) {
            isCanNext = true
            self.confirmBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.confirmBtn.frame.height / 2)
        } else {
            isCanNext = false
            self.confirmBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.confirmBtn.frame.height / 2)
        }
    }
    
    @objc func confirmClick() {
        if isCanNext {
            HUD.show(.systemActivity)
            BN.setReferrer(invitationCode: codeTF.text ?? "") { statusCode, dataObj, err in
                HUD.hide()
                if (statusCode == 200) {
                    let FinishVC = UIStoryboard(name: "FinishVC", bundle: nil).instantiateViewController(withIdentifier: "FinishVC") as! FinishVC
                    FinishVC.referralCodeVC = self
                    FinishVC.tag = 11
                    FinishVC.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
                    self.present(FinishVC, animated: true, completion: nil)
                }else{
                    FailView.failView.showMe(error: err?.exception ?? "Fail to setReferral.")
                }
            }
        }
    }
    
    //scanQrcodeDelegate
    func getQrcodeStr(qrStr: String) {
        self.codeTF.text = qrStr
        judgeCanNext()
    }

}

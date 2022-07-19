//
//  SwapVerificationVC.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/6/29.
//

import UIKit
import PKHUD

class SwapVerificationVC: UIViewController {
    
    @IBOutlet weak var swapLabel: UILabel!
    @IBOutlet weak var transactionTF: UITextField!
    @IBOutlet weak var passwordBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    var timer = Timer()
    var totalTime = 60
    
    var transactionId = ""
    var completeExpiredAt = ""
    var isCanNext = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "swap".localized
        
        totalTime = US.dateDiff(iso: completeExpiredAt)
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        setUI()
        // Do any additional setup after loading the view.
    
    }
    
    func setUI() {
        swapLabel.text = "swap_time_limit_text_one".localized + "\(totalTime)" + "swap_time_limit_text_three".localized
        
        transactionTF.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "setting_transaction_pwd_palceholder".localized, placeholderColorHex: "393939")
        transactionTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        passwordBtn.addTarget(self, action: #selector(passwordVisibleBtnClick(_:)), for: UIControl.Event.touchUpInside)
        
        nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
        nextBtn.addTarget(self, action: #selector(nextBtnClick), for: UIControl.Event.touchUpInside)
        
    }
    
    @objc func updateTimer() {
        self.swapLabel.text = "swap_time_limit_text_one".localized + "\(totalTime)" + "swap_time_limit_text_three".localized
        if totalTime > 0 {
            totalTime -= 1
        }else{
            timer.invalidate()
            let FinishVC = UIStoryboard(name: "FinishVC", bundle: nil).instantiateViewController(withIdentifier: "FinishVC") as! FinishVC
            FinishVC.swapVerificationVC = self
            FinishVC.tag = 14
            FinishVC.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
            self.present(FinishVC, animated: true, completion: nil)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        judgeCanNext()
        
    }
    
    func judgeCanNext() {
        
        transactionTF.judgeRemind()
        isCanNext = false
        if let text = transactionTF.text {
            if (text.count > 0) {
                isCanNext = true
            }
        }
        
        if (isCanNext) {
            self.nextBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.nextBtn.frame.height / 2)
        } else {
            self.nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.nextBtn.frame.height / 2)
        }
    }
    
    @objc func passwordVisibleBtnClick(_ btn: UIButton) {
        transactionTF.isSecureTextEntry = !transactionTF.isSecureTextEntry
        passwordBtn.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        if (transactionTF.isSecureTextEntry) {
            passwordBtn.setImage(UIImage(named: "icon_eye_close"), for: UIControl.State.normal)
        } else {
            passwordBtn.setImage(UIImage(named: "icon_eye_open"), for: UIControl.State.normal)
        }
    }
    
    
    
    @objc func nextBtnClick() {
        judgeCanNext()
        if isCanNext {
            HUD.show(.systemActivity)
            BN.postSwapCompletion(transactionId: transactionId, transactionPassword: transactionTF.text ?? "") { statusCode, dataObj, err in
                HUD.hide()
                if (statusCode == 200) {
                    let FinishVC = UIStoryboard(name: "FinishVC", bundle: nil).instantiateViewController(withIdentifier: "FinishVC") as! FinishVC
                    FinishVC.swapVerificationVC = self
                    FinishVC.tag = 13
                    FinishVC.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
                    self.present(FinishVC, animated: true, completion: nil)
                }else{
                    FailView.failView.showMe(error: err?.exception ?? "network_fail".localized)
                }
            }
        }
    }
    

}

//
//  WithdrawTwoFactorVC.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/5/25.
//

import UIKit
import PKHUD

class WithdrawTwoFactorVC: UIViewController {

    @IBOutlet weak var codeTF: UITextField!
    @IBOutlet weak var codeBtn: UIButton!
    
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    var twoFactorType = 0
    var withdrawDic = Dictionary<String, Any>() //出金資訊
    var withdrawPwVC: WithdrawPwVC?
    
    var isCanNext = false
    var timer: Timer?
    var counter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    

    func setUI() {
        self.navigationItem.title = "withdraw".localized
        
        codeTF.resetCustom(cornerRadius: nil, paddingLeft: 15, paddingRight: 15, placeholderText: "verification_code_placeholder".localized, placeholderColorHex: "393939")
        codeTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        codeBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: codeBtn.frame.height / 2)
        codeBtn.addTarget(self, action: #selector(sendBtnClick(_:)), for: UIControl.Event.touchUpInside)
        if (twoFactorType == 3) {
            codeBtn.isHidden = true
            codeLabel.text = "authenticator_two_text".localized
        }
        
        nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
        nextBtn.addTarget(self, action: #selector(nextBtnClick), for: UIControl.Event.touchUpInside)
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        judgeCanNext()
        
    }
    
    func judgeCanNext() {
        
        codeTF.judgeRemind()
        
        isCanNext = false
        if let text = codeTF.text {
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
    
    @objc func sendBtnClick(_ btn: UIButton) {
        btn.isUserInteractionEnabled = false
        if (timer == nil) {
            BN.getVerificationCode(verificationMethod: twoFactorType, verificationType: 10) { statusCode, dataObj, err in
                btn.isUserInteractionEnabled = true
                if (statusCode == 200) {
                    self.counter = 120
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDownHandler), userInfo: nil, repeats: true)
                    self.codeLabel.text = "sms_verification_code_hint_text_paragraph_one".localized +  "twofa".localized + ". " + "verification_code_placeholder".localized
                }else{
                    self.codeLabel.text = err?.exception ?? "send_fail".localized
                }
            }
        }
    }
    
    @objc func countDownHandler() {
        counter = counter - 1
        if (counter <= 0) {
            codeLabel.text = "sms_verification_code_hint".localized
            codeBtn.setTitle("send_btn".localized, for: UIControl.State.normal)
            codeBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
            codeBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: codeBtn.frame.height / 2)
            timer?.invalidate()
            timer = nil
        } else {
            codeBtn.setTitle("(\(counter)s)", for: UIControl.State.normal)
            codeBtn.setTitleColor(UIColor.init(hex: "FFFF79"), for: UIControl.State.normal)
            codeBtn.setBackgroundImage(nil, for: UIControl.State.normal)
        }
    }
    
    @objc func nextBtnClick() {
        judgeCanNext()
        if isCanNext {
            withdrawDic["verificationCode"] = codeTF.text ?? ""
            HUD.show(.systemActivity)
            BN.postWithdrawal(withdrawDic: withdrawDic) { statusCode, transactionId, err in
                HUD.hide()
                if (statusCode == 200) {
                    let FinishVC = UIStoryboard(name: "FinishVC", bundle: nil).instantiateViewController(withIdentifier: "FinishVC") as! FinishVC
                    FinishVC.withdrawPwVC = self.withdrawPwVC
                    FinishVC.tag = 10
                    FinishVC.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
                    self.present(FinishVC, animated: true, completion: nil)
                }else{
                    FailView.failView.showMe(error: err?.exception ?? "Fail to withdraw.")
                }
            }
        }
    }
    
    

}

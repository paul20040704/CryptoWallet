//
//  SwapConfirmVC.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/6/29.
//

import UIKit
import PKHUD

class SwapConfirmVC: UIViewController {

    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    
    var timer = Timer()
    var totalTime = 60
    
    var fromAmount = "0"
    var fromCoin = ""
    var toAmount = "0"
    var toCoin = ""
    
    var transactionId = ""
    var confrimExpiredAt = ""
    var completeExpiredAt = ""
    
    var swapVC: SwapViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .custom
        
        HUD.flash(.systemActivity, onView: self.view, delay: 1, completion: nil)
        
        totalTime = US.dateDiff(iso: confrimExpiredAt)
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        setUI()
    }
    

    func setUI() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = alertView.bounds
        gradientLayer.colors = [UIColor(hex: "#1E361A")?.cgColor, UIColor(hex: "#071505")?.cgColor]
        //alertView.layer.addSublayer(gradientLayer)
        alertView.layer.insertSublayer(gradientLayer, at: 0)
        
        confirmBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: confirmBtn.frame.height / 2)
        confirmBtn.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        
        backBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        fromLabel.text = "\(fromAmount) \(fromCoin)"
        toLabel.text = "\(toAmount) \(toCoin)"
    }
    
    @objc func updateTimer() {
        self.countLabel.text = "swap_check_text_one".localized + "\(totalTime)" + "swap_check_text_three".localized
        if totalTime > 0 {
            totalTime -= 1
        }else{
            timer.invalidate()
            self.dismiss(animated: true)
        }
    }
    
    @objc func confirm() {
        timer.invalidate()
        self.dismiss(animated: true)
        let swapVerificationVC = UIStoryboard(name: "Swap", bundle: nil).instantiateViewController(withIdentifier: "SwapVerificationVC") as! SwapVerificationVC
        swapVerificationVC.transactionId = transactionId
        swapVerificationVC.completeExpiredAt = completeExpiredAt
        swapVC?.navigationController?.show(swapVerificationVC, sender: nil)
    }

    @objc func back() {
        timer.invalidate()
        self.dismiss(animated: true)
    }
}

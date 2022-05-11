//
//  DepositDetailVC.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/5/9.
//

import UIKit
import PKHUD

class DepositDetailVC: UIViewController {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var copyBtn: UIButton!
    @IBOutlet weak var qrcodeBtn: UIButton!
    @IBOutlet weak var bscBtn: UIButton!
    @IBOutlet weak var trcBtn: UIButton!
    @IBOutlet weak var splBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    

    func setUI() {
        self.navigationItem.title = "deposit".localized
        
        copyBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: copyBtn.frame.height / 2)
        copyBtn.addTarget(self, action: #selector(copyClick), for: UIControl.Event.touchUpInside)
        
        qrcodeBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: qrcodeBtn.frame.height / 2)
        qrcodeBtn.addTarget(self, action: #selector(qrcodeClick), for: UIControl.Event.touchUpInside)
        
        bscBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: 10)
        bscBtn.addTarget(self, action: #selector(qrcodeClick), for: UIControl.Event.touchUpInside)
        
        trcBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: 10)
        trcBtn.addTarget(self, action: #selector(qrcodeClick), for: UIControl.Event.touchUpInside)
        
        splBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: 10)
        splBtn.addTarget(self, action: #selector(qrcodeClick), for: UIControl.Event.touchUpInside)
    }
    
    @objc func copyClick() {
        UIPasteboard.general.string = addressLabel.text
        HUD.flash(.label("copy_text".localized), delay: 1.0)
    }
    
    @objc func qrcodeClick() {
        QrcodeView.qrcodeView.showMe()
    }
    

}

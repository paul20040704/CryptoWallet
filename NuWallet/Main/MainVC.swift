//
//  MainVC.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/22.
//

import UIKit
import PKHUD

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
    
    @objc func nextClick() {
        let mainBtmQrcodeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainBtmQrcodeVC")
        self.navigationController?.show(mainBtmQrcodeVC, sender: nil)
    }
    
    @objc func payClick() {
        let scanQrcodeVC = ScanQrcodeVC()
        scanQrcodeVC.delegate = self
        self.present(scanQrcodeVC, animated: true, completion: nil)
    }
    
    func getQrcodeStr(qrStr: String) {
        HUD.show(.systemActivity)
        BN.getSellingOrder(dataStr: qrStr) { statusCode, dataObj, err in
            HUD.hide()
            if (statusCode != 200) {
                let sellingOrderVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SellingOrderVC") as! SellingOrderVC
                sellingOrderVC.sellingDetil = dataObj
                self.navigationController?.show(sellingOrderVC, sender: nil)
            }else{
                FailView.failView.showMe(error: err?.exception ?? "Get Selling Order Fail.")
            }
        }
    }

    
}

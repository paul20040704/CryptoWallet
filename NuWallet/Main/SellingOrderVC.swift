//
//  SellingOrderVC.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/4/29.
//

import UIKit
import PKHUD

class SellingOrderVC: UIViewController {

    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var coinName: UILabel!
    @IBOutlet weak var coinFullName: UILabel!
    
    @IBOutlet weak var currencyImge: UIImageView!
    @IBOutlet weak var currencyName: UILabel!
    @IBOutlet weak var currencyFullName: UILabel!
    @IBOutlet weak var swapImage: UIImageView!
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    
    var sellingDetil: SellingDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        // Do any additional setup after loading the view.
    }
    

    func setUI() {
        self.navigationItem.title = "btm_order".localized
        swapImage.transform()
        
        confirmBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: confirmBtn.frame.height / 2)
        confirmBtn.addTarget(self, action: #selector(confirmClick), for: .touchUpInside)
        let image = UIImage(named: "icon_navigationbar_arrow_back")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backClick))
        
    }
    
    @objc func confirmClick() {
        HUD.show(.systemActivity)
        BN.setSellingOrder(orderId: sellingDetil?.orderId ?? "") { statusCode, dataObj, err in
            HUD.hide()
            if (statusCode == 200) {
                let FinishVC = UIStoryboard(name: "FinishVC", bundle: nil).instantiateViewController(withIdentifier: "FinishVC") as! FinishVC
                FinishVC.sellingOrderVC = self
                FinishVC.tag = 9
                self.present(FinishVC, animated: true, completion: nil)
            }else{
                FailView.failView.showMe(error: err?.exception ?? "Fail To Selling Order.")
            }
        }
    }
    
    @objc func backClick() {
        RejectView.rejectView.sellingVC = self
        RejectView.rejectView.showMe()
    }

}

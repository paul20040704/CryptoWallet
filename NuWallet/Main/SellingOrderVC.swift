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
        setData()
        // Do any additional setup after loading the view.
    }
    

    func setUI() {
        self.navigationItem.title = "btm_order".localized
        self.navigationItem.backButtonTitle = ""
        swapImage.transform()
        
        confirmBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: confirmBtn.frame.height / 2)
        confirmBtn.addTarget(self, action: #selector(confirmClick), for: .touchUpInside)
        let image = UIImage(named: "icon_navigationbar_arrow_back")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backClick))
        
    }
    
    func setData() {
        if let detail = sellingDetil {
            self.coinImage.image = UIImage(named: "coin_\((detail.coinName ?? "").lowercased())")
            self.coinName.text = detail.coinName ?? ""
            self.coinFullName.text = detail.coinFullName ?? ""
            
            self.currencyImge.image = UIImage(named: "coin_\((detail.currencyName ?? "").lowercased())")
            self.currencyName.text = detail.currencyName ?? ""
            self.currencyFullName.text = detail.currencyFullName ?? ""
            
            self.orderLabel.text = detail.orderId ?? ""
            self.coinLabel.text = detail.coinName ?? ""
            self.amountLabel.text = String(detail.currencyAmount ?? 0)
            self.dateLabel.text = detail.date ?? ""
        }
    }
    
    @objc func confirmClick() {
        if let orderId = sellingDetil?.orderId {
            let mainSmsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainSmsVC") as! MainSmsVC
            mainSmsVC.orderId = orderId
            self.navigationController?.show(mainSmsVC, sender: nil)
        }else{
            FailView.failView.showMe(error: "Get orderId fail.")
        }
    }
    
    @objc func backClick() {
        RejectView.rejectView.sellingVC = self
        RejectView.rejectView.showMe()
    }

}

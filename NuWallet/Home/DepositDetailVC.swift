//
//  DepositDetailVC.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/5/9.
//

import UIKit
import PKHUD

class DepositDetailVC: UIViewController {

    @IBOutlet weak var supportLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var coin = "USDT"
    var addressDic = Dictionary<String, String?>()
    var addressKey = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        setUI()
        getAddress()
        
    }

    func setUI() {
        self.navigationItem.title = "deposit".localized

    }
    
    func getAddress() {
        HUD.show(.systemActivity)
        BN.getAssetAddress(coinId: coin) { [weak self] statusCode, dataObj, err in
            HUD.hide()
            guard let self = self else {return}
            if (statusCode == 200) {
                if let assets = dataObj?.addresses {
                    for asset in assets {
                        if let id = asset.networkId {
                            self.addressDic[id] = asset.address
                        }
                    }
                    self.addressKey = Array(self.addressDic.keys.sorted(by: <))
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    var supportStr = ""
                    for key in self.addressKey {
                        supportStr = supportStr + " . \(key)"
                    }
                    self.supportLabel.text = supportStr
                }
            }else{
                FailView.failView.showMe(error: err?.exception ?? "network_fail".localized)
            }
        }
    }
    
    func postAddress(key: String) {
        HUD.show(.systemActivity)
        BN.postAssetAddress(coinId: coin, networkId: key) {[weak self] statusCode, dataObj, err in
            HUD.hide()
            guard let self = self else {return}
            if (statusCode == 200) {
                if let address = dataObj?.address {
                    self.addressDic[key] = address
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }else{
                HUD.flash(.label(err?.exception ?? "fail"), delay: 1)
            }
        }
    }
    
    

}


extension DepositDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressKey.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let addressCell = tableView.dequeueReusableCell(withIdentifier: "DepositAddressCell", for: indexPath) as! DepositAddressCell
        let generateCell = tableView.dequeueReusableCell(withIdentifier: "DepositGenerateCell", for: indexPath) as! DepositGenerateCell
        let key = addressKey[indexPath.row]
        if let address = addressDic[key] {
            if address == nil {
                generateCell.coinImage.image = UIImage(named: "coin_\(coin.lowercased())")
                generateCell.coinLable.text = "\(coin) \("generate_address_paragraph_two".localized) (\(key))"
                generateCell.generateBtn.setTitle("\("generate_address_paragraph_one".localized) \(coin) \("generate_address_paragraph_two".localized) (\(key))", for: .normal)
                generateCell.depositDetailVC = self
                generateCell.key = key
                
                return generateCell
            }else{
                addressCell.coinImage.image = UIImage(named: "coin_\(coin.lowercased())")
                addressCell.coinLabel.text = "\(coin) \("generate_address_paragraph_two".localized) (\(key))"
                addressCell.addressLabel.text = address
                addressCell.coin = coin
                addressCell.key = key
                return addressCell
            }
        }
        return UITableViewCell()
    }
    
    
}

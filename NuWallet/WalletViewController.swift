//
//  WalletViewController.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/15.
//

import UIKit

class WalletViewController: UIViewController {

    var iTabBarController: TabBarController?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var historyBtn: UIButton!
    @IBOutlet weak var assetsLabel: UILabel!
    @IBOutlet weak var hideBtn: UIButton!
    @IBOutlet weak var totalLabel: UILabel!
    
    var assetsDic = Dictionary<String, Array<String>>()
    var assetsKeys = Array<String>()
    var totalBalance = 0
    var hideStatus = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iTabBarController?.iTabBarMainViewController?.navigationItem.title = "Wallet"
        tableView.delegate = self
        tableView.dataSource = self
        setUI()
        getAssets()
    }
    
    func setUI() {
        hideBtn.addTarget(self, action: #selector(passwordVisibleBtnClick(_:)), for: .touchUpInside)
        historyBtn.addTarget(self, action: #selector(goHistory), for: .touchUpInside)
    }
    
    func getAssets() {
        BN.getAssets { statusCode, dataObj, err in
            if (statusCode == 200) {
                DispatchQueue.main.async {
                    self.totalBalance = dataObj?.estimatedBalance ?? 0
                    self.parseAssets(data: dataObj)
                    self.assetsLabel.text = "\(self.totalBalance)"
                    self.totalLabel.text = "Total ≈ \(self.totalBalance) USDT"
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func parseAssets(data: AssetResponse?) {
        if let assets = data?.assets {
            assetsDic.removeAll()
            assetsKeys.removeAll()
            for asset in assets {
                if let id = asset.coinId, let fullName = asset.coinFullName, let blance = asset.balance {
                    let arr: Array<String> = [fullName,String(blance)]
                    assetsDic[id] = arr
                }
            }
            assetsKeys = Array(assetsDic.keys.map{ $0 }.sorted(by: <))
        }
    }
    
    
    @objc func passwordVisibleBtnClick(_ btn: UIButton) {
        
        hideStatus = !hideStatus
        switch hideStatus {
        case true:
            assetsLabel.text = "*****"
            totalLabel.text = "Total ≈ ****** USDT"
            hideBtn.setImage(UIImage(named: "icon_eye_close"), for: UIControl.State.normal)
        default:
            assetsLabel.text = "\(totalBalance)"
            totalLabel.text = "Total ≈ \(totalBalance) USDT"
            hideBtn.setImage(UIImage(named: "icon_eye_open"), for: UIControl.State.normal)
        }
    }
    
    @objc func goHistory() {
        let historyVC = UIStoryboard(name: "History", bundle: nil).instantiateViewController(withIdentifier: "HistoryVC") as! HistoryVC
        self.navigationController?.show(historyVC, sender: nil)
    }
    

}

extension WalletViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assetsKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DepositCell", for: indexPath) as! DepositCell
        let id = assetsKeys[indexPath.row]
        let assetArr = assetsDic[id]
        let fullName = assetArr?[0] ?? ""
        let amount = assetArr?[1] ?? "0"
        
        cell.shortLabel.text = id
        cell.longLabel.text = fullName
        cell.amountLabel.text = amount
        cell.totalLabel.text = amount + " " + id
        cell.icon.image = UIImage(named: "coin_\(id.lowercased())")
        
        return cell
    }
    
    
}

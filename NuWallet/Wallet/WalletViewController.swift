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
    
//    var assetsDic = Dictionary<String, Array<String>>()
//    var assetsKeys = Array<String>()
//    var totalBalance = 0
    var hideStatus = false
    var walletViewModel = WalletViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iTabBarController?.iTabBarMainViewController?.navigationItem.title = "Wallet"
        tableView.delegate = self
        tableView.dataSource = self
        setUI()
        initVM()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        walletViewModel.getAsset()
        judgeBalanceSecurity()
        
    }
    
    func setUI() {
        hideBtn.addTarget(self, action: #selector(passwordVisibleBtnClick(_:)), for: .touchUpInside)
        historyBtn.addTarget(self, action: #selector(goHistory), for: .touchUpInside)
    }
    
    func initVM() {
        walletViewModel.reloadWallet = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.judgeBalanceSecurity()
            }
        }
    }
    
    @objc func passwordVisibleBtnClick(_ btn: UIButton) {
        
        var hideStatus = UD.bool(forKey: "balanceSecurity")
        hideStatus = !hideStatus
        
        switch hideStatus {
        case true:
            UD.set(true, forKey: "balanceSecurity")
            judgeBalanceSecurity()
            
        default:
            UD.set(false, forKey: "balanceSecurity")
            judgeBalanceSecurity()
        }
    }
    
    func judgeBalanceSecurity() {
        let hideStatus = UD.bool(forKey: "balanceSecurity")
        switch hideStatus {
        case true:
            assetsLabel.text = "*****"
            totalLabel.text = "Total ≈ ****** USD"
            hideBtn.setImage(UIImage(named: "icon_eye_close"), for: UIControl.State.normal)
        default:
            assetsLabel.text = "\(walletViewModel.estimatedBalance ?? 0)"
            totalLabel.text = "Total ≈ \(walletViewModel.estimatedBalance ?? 0) USDT"
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
        return walletViewModel.walletModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DepositCell", for: indexPath) as! DepositCell
        
        let walletModel = walletViewModel.walletModels[indexPath.row]
        
        cell.shortLabel.text = walletModel.coinId
        cell.longLabel.text = walletModel.coinFullName
        cell.amountLabel.text = walletModel.balance
        cell.icon.image = UIImage(named: "coin_\(walletModel.coinId.lowercased())")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let walletModel = walletViewModel.walletModels[indexPath.row]
        let candlestickChartViewController = UIStoryboard(name: "CandlestickChart", bundle: nil).instantiateViewController(withIdentifier: "candlestickChartViewController") as! CandlestickChartViewController
        candlestickChartViewController.symbol = walletModel.coinId
        //candlestickChartViewController.fullName = walletModel.coinFullName
        candlestickChartViewController.tradeEnabled = walletModel.tradeEnabled
        candlestickChartViewController.depositEnabled = walletModel.depositEnabled
        candlestickChartViewController.withdrawalEnabled = walletModel.withdrawalEnabled
        candlestickChartViewController.balance = walletModel.balance
        
        self.navigationController?.show(candlestickChartViewController, sender: nil)
    }
    
    
}

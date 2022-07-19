//
//  HomeViewController.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/15.
//

import UIKit

class HomeViewController: UIViewController, SelectDelegate {
    
    var iTabBarController: TabBarController?
    @IBOutlet weak var iHomeTableView: HomeTableView!
    @IBOutlet weak var notifyLabel: UILabel!
    @IBOutlet weak var notifyBtn: UIButton!
    
    var sort = "coin_sort_1".localized
    var balance = "0"
    var searching = false
    var searchHighlightIdArr = Array<String>()
    var searchAllIdArr = Array<String>()
    
    var crypcoModel = CryptoViewModel()
    
    var assetDic = Dictionary<String, DepositModel>()
    var timer: DispatchSourceTimer?
    
    var notifyViewModel = NotifyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notifyViewModel.getBoardList()
        
        iHomeTableView.iHomeViewController = self
    
        //iTabBarController?.iTabBarMainViewController?.navigationItem.title = "Home"

        notifyLabel.layer.cornerRadius = notifyLabel.frame.size.height / 2
        notifyLabel.clipsToBounds = true
        notifyBtn.addTarget(self, action: #selector(notifyBtnClick), for: UIControl.Event.touchUpInside)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getAsset()
        getNotifyRead()
        initVM()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.cancel()
        print("TimerCancel")
    }
    
    func initVM() {
        crypcoModel.reloadCrypto = {
            DispatchQueue.main.async {
                print("取得資料 更新行情")
                self.iHomeTableView.reloadData()
            }
        }
        
        timer = DispatchSource.makeTimerSource()
        timer?.schedule(deadline: .now(), repeating: .seconds(10), leeway: .nanoseconds(1))
        timer?.setEventHandler(handler: {
            self.crypcoModel.getCyypto()
        })
        
        timer?.activate()
    }
    
    func getAsset() {
        
        BN.getAssets { statusCode, dataObj, err in
            if (statusCode == 200) {
                if let assets = dataObj?.assets {
                    self.balance = String((dataObj?.estimatedBalance ?? 0).rounding(toDecimal: 2))
                    DispatchQueue.main.async {
                        self.iHomeTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
                    }
                    for asset in assets {
                        let model = DepositModel(coinId: asset.coinId ?? "", coinFullName: asset.coinFullName ?? "", balance: String(asset.balance ?? 0), tradeEnabled: asset.tradeEnabled ?? false, depositEnabled: asset.depositEnabled ?? false, withdrawalEnabled: asset.withdrawalEnabled ?? false)
                        self.assetDic[asset.coinId ?? ""] = model
                    }
                }
            }
        }
    }
    
    func getNotifyRead() {
        notifyViewModel.reloadData = {
            DispatchQueue.main.async {
                if self.notifyViewModel.unreadCount > 0 {
                    self.notifyLabel.isHidden = false
                    self.notifyLabel.text = String(self.notifyViewModel.unreadCount)
                }else{
                    self.notifyLabel.isHidden = true
                }
            }
        }
        notifyViewModel.getBoardList()
    }
    
    @objc func notifyBtnClick() {
        
        let notifyViewController = UIStoryboard(name: "Notify", bundle: nil).instantiateViewController(withIdentifier: "notifyViewController") as! NotifyViewController
        notifyViewController.notifyViewModel = notifyViewModel
        self.navigationController?.show(notifyViewController, sender: nil)
        
    }
    
    //Delegate
    func updateOption(tag: Int, condition: String) {
        sort = condition
        self.iHomeTableView.reloadData()
    }
    
}


extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count < 4 {
            let index = searchText.index(searchText.startIndex, offsetBy: searchText.count)
            searchHighlightIdArr = crypcoModel.listModel?.defaultKey.filter({ name in
                return name.lowercased().prefix(upTo: index) == searchText.lowercased()
            }) ?? [""]
            
            searchAllIdArr = crypcoModel.listModel?.allKey.filter({ name in
                return name.lowercased().prefix(upTo: index) == searchText.lowercased()
            }) ?? [""]
            
            searching = true
            iHomeTableView.reloadData()
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        iHomeTableView.reloadData()
    }
    
}

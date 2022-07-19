//
//  DepositVC.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/22.
//

import UIKit

protocol CoinSelectDelegate {
    func coinSelect (type: Int,balanceStr: String,coin: String)
}

class DepositVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searching = false
    var type = 0 // 0 Deposit 1 Withdraw 2 Swap
    var kind = 0 // 0 From 1 To
    var searchShortArr = Array<String>()
    
    var delegate: CoinSelectDelegate?
    var depositViewModel = DepositViewModel()
    
    var swapList = Array<String>() //Swap幣種清單
    var swapFullCoinDic = Dictionary<String, String>() //Swap幣種清單全名
    var swapWallectDic = Dictionary<String, Double>() //Swap幣種清單餘額
    
    var swapToList = Array<String>() //Swap可交換幣種清單
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        setUI()
        if type != 2 {
            setVM()
        }
    }
    
    
    func setUI() {
        self.navigationItem.backButtonTitle = ""
        self.tableView.tableFooterView = UIView()
        
        let item = UIBarButtonItem(image: UIImage(named: "icon_navigationbar_history"), style: .plain, target: self, action: #selector(goHistory))
        self.navigationItem.rightBarButtonItem = item
        
        switch type {
        case 0:
            self.navigationItem.title = "deposit".localized
        case 1:
            self.navigationItem.title = "withdraw".localized
        default:
            self.navigationItem.title = "swap".localized
            self.navigationController?.navigationBar.isHidden = true
        }
        
    }
    
    func setVM() {
        depositViewModel.reloadDeposit = { [weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.searchShortArr = self.depositViewModel.coinIdArr
                self.tableView.reloadData()
            }
        }
        depositViewModel.getAsset()
    }
    
    @objc func goHistory() {
        let historyVC = UIStoryboard(name: "History", bundle: nil).instantiateViewController(withIdentifier: "HistoryVC") as! HistoryVC
        historyVC.type = type
        self.navigationController?.show(historyVC, sender: nil)
    }

}


extension DepositVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch type {
        case 2:
            if searching {
                return searchShortArr.count
            }else{
                if (kind == 0) {
                    return swapList.count
                }else{
                    return swapToList.count
                }
            }
        default:
            if searching {
                return searchShortArr.count
            }else{
                return depositViewModel.coinIdArr.count
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DepositCell", for: indexPath) as! DepositCell
        var coin = ""
        switch type {
        case 2:
            if searching {
                coin = searchShortArr[indexPath.row]
            }else{
                if (kind == 0) {
                    coin = swapList[indexPath.row]
                }else{
                    coin = swapToList[indexPath.row]
                }
            }
            cell.shortLabel.text = coin
            cell.longLabel.text = swapFullCoinDic[coin]
            cell.icon.image = UIImage(named: "coin_\(coin.lowercased())")
            cell.amountLabel.text = String(swapWallectDic[coin] ?? 0)
            
            return cell
        default:
            if searching {
                coin = searchShortArr[indexPath.row]
            }else{
                coin = depositViewModel.coinIdArr[indexPath.row]
            }
            let depositModel = depositViewModel.depositModels[coin]
            cell.shortLabel.text = coin
            cell.longLabel.text = depositModel?.coinFullName
            cell.icon.image = UIImage(named: "coin_\(coin.lowercased())")
            cell.amountLabel.text = depositModel?.balance
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var coin = ""
        if searching {
            coin = searchShortArr[indexPath.row]
        }else{
            if (type == 2) {
                if (kind == 0) {
                    coin = swapList[indexPath.row]
                }else{
                    coin = swapToList[indexPath.row]
                }
            }else{
                coin = depositViewModel.coinIdArr[indexPath.row]
            }
        }
        let depositModel = depositViewModel.depositModels[coin]
        if (type == 0) {
            if (depositModel?.depositEnabled ?? false) {
                let depositDetailVC = UIStoryboard(name: "Deposit", bundle: nil).instantiateViewController(withIdentifier: "DepositDetailVC") as! DepositDetailVC
                depositDetailVC.coin = coin
                self.navigationController?.show(depositDetailVC, sender: nil)
            }else {
                let alertC = US.showAlert(title: "greet".localized, message: "not_support_deposit".localized)
                self.present(alertC, animated: true, completion: nil)
            }
        }else if (type == 1){
            if (depositModel?.withdrawalEnabled ?? false) {
                let withdrawDetailVC = UIStoryboard(name: "Deposit", bundle: nil).instantiateViewController(withIdentifier: "WithdrawDetailVC") as! WithdrawDetailVC
                withdrawDetailVC.coin = coin
                withdrawDetailVC.fullName = depositModel?.coinFullName ?? ""
                self.navigationController?.show(withdrawDetailVC, sender: nil)
            }else{
                let alertC = US.showAlert(title: "greet".localized, message: "not_support_withdraw".localized)
                self.present(alertC, animated: true, completion: nil)
            }
        }else{
            self.delegate?.coinSelect(type: kind, balanceStr: String(swapWallectDic[coin] ?? 0), coin: coin)
            //self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true)
        }
    }
    
    
}

extension DepositVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count < 4 {
            let index = searchText.index(searchText.startIndex, offsetBy: searchText.count)
            switch type {
            case 2:
                if (kind == 0) {
                    searchShortArr = swapList.filter({ name in
                        return name.lowercased().prefix(upTo: index) == searchText.lowercased()
                    })
                }else{
                    searchShortArr = swapToList.filter({ name in
                        return name.lowercased().prefix(upTo: index) == searchText.lowercased()
                    })
                }
            default:
                searchShortArr = depositViewModel.coinIdArr.filter({ name in
                    return name.lowercased().prefix(upTo: index) == searchText.lowercased()
                })
            }
            searching = true
            self.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        self.tableView.reloadData()
    }
    
}

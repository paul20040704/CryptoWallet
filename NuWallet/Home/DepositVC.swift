//
//  DepositVC.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/22.
//

import UIKit

class DepositVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var shortName = ["BTC","ETH","BCH","USDT","ATOM","LTC","ADA","XRP"]
    var fullName = ["Bitcoin","Ethereum","Bitcoin Cash","Tether","Cosmos","Litecoin","Cardano","XRP"]
    var searching = false
    var type = 0 // 0 Deposit 1 Withdraw
    lazy var searchShortName = shortName
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        searchBar.delegate = self
        setUI()
    }
    
    func setUI() {
        self.navigationItem.backButtonTitle = ""
        switch type {
        case 0:
            self.navigationItem.title = "deposit".localized
        default:
            self.navigationItem.title = "withdraw".localized
        }
        
        let item = UIBarButtonItem(image: UIImage(named: "icon_navigationbar_history"), style: .plain, target: self, action: #selector(goHistory))
        self.navigationItem.rightBarButtonItem = item
        
    }

    @objc func goHistory() {
        let historyVC = UIStoryboard(name: "History", bundle: nil).instantiateViewController(withIdentifier: "HistoryVC") as! HistoryVC
        historyVC.type = type
        self.navigationController?.show(historyVC, sender: nil)
    }

}


extension DepositVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchShortName.count
        }else{
            return shortName.count
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DepositCell", for: indexPath) as! DepositCell
        if searching {
            cell.shortLabel.text = searchShortName[indexPath.row]
            cell.longLabel.text = fullName[indexPath.row]
            cell.icon.image = UIImage(named: "coin_\(searchShortName[indexPath.row].lowercased())")
        }else{
            cell.shortLabel.text = shortName[indexPath.row]
            cell.longLabel.text = fullName[indexPath.row]
            cell.icon.image = UIImage(named: "coin_\(shortName[indexPath.row].lowercased())")
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (type == 0) {
            let depositDetailVC = UIStoryboard(name: "Deposit", bundle: nil).instantiateViewController(withIdentifier: "DepositDetailVC") as! DepositDetailVC
            self.navigationController?.show(depositDetailVC, sender: nil)
        }else{
            let withdrawDetailVC = UIStoryboard(name: "Deposit", bundle: nil).instantiateViewController(withIdentifier: "WithdrawDetailVC") as! WithdrawDetailVC
            self.navigationController?.show(withdrawDetailVC, sender: nil)
        }
    }
    
    
}

extension DepositVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let index = searchText.index(searchText.startIndex, offsetBy: searchText.count)
        searchShortName = shortName.filter({ name in
            return name.lowercased().prefix(upTo: index) == searchText.lowercased()
        })
        searching = true
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
    
}

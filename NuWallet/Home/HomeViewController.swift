//
//  HomeViewController.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/15.
//

import UIKit

enum sort {
    case defaultSort
    case all
    case lower
    case upper
}


class HomeViewController: UIViewController, SelectDelegate {
    
    var iTabBarController: TabBarController?
    @IBOutlet weak var iHomeTableView: HomeTableView!
    @IBOutlet weak var notifyLabel: UILabel!
    @IBOutlet weak var notifyBtn: UIButton!
    
    var highlightIdArr = Array<String>()
    var allIdArr = Array<String>()
    var cryptoSummaryDic = Dictionary<String, String>()
    var cryptoPercentDic = Dictionary<String, Double>()
    var cryptoPriceDic = Dictionary<String, String>()
    var cryptoSymbolDic = Dictionary<String, String>()
    
    var sort = "Default"
    var searching = false
    var searchHighlightIdArr = Array<String>()
    var searchAllIdArr = Array<String>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iHomeTableView.iHomeViewController = self
    
        //iTabBarController?.iTabBarMainViewController?.navigationItem.title = "Home"

        notifyLabel.layer.cornerRadius = notifyLabel.frame.size.height / 2
        notifyLabel.clipsToBounds = true
        notifyBtn.addTarget(self, action: #selector(notifyBtnClick), for: UIControl.Event.touchUpInside)
        
        updateCryptoPrice()
    }
    
    func updateCryptoPrice() {
        let group: DispatchGroup = DispatchGroup()
        
        let queue1 = DispatchQueue(label: "queue1")
        group.enter()
        queue1.async(group: group) {
            BN.getCryptocurrency(headers: nil) { statusCode, dataObj, err in
                if (statusCode == 200) {
                    self.setCryptoSummary(crypto: dataObj)
                }
                group.leave()
            }
        }
        
        let queue2 = DispatchQueue(label: "queue2")
        group.enter()
        queue2.async(group: group) {
            BN.getCryptoMarket(headers: nil) { statusCode, dataObj, err in
                if (statusCode == 200) {
                    self.setCryptoMarket(market: dataObj)
                }
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.judgeCryptoMarket()
            self.iHomeTableView.reloadData()
            print("===========API全都完成")
        }
    }
    
    func setCryptoSummary(crypto: CryptoResponse?) {
        if let highlights = crypto?.highlights {
            highlightIdArr.removeAll()
            allIdArr.removeAll()
            cryptoSummaryDic.removeAll()
            for highlight in highlights {
                if let id = highlight.id, let fullName = highlight.fullName {
                    highlightIdArr.append(id)
                    cryptoSummaryDic[id] = fullName
                }
            }
            highlightIdArr = Array(cryptoSummaryDic.keys)
        }
        
        if let others = crypto?.others {
            allIdArr = highlightIdArr
            for other in others {
                if let id = other.id, let fullName = other.fullName {
                    cryptoSummaryDic[id] = fullName
                }
            }
            allIdArr = Array(cryptoSummaryDic.keys.map{ $0 }.sorted(by: <))
        }
    }
    
    func setCryptoMarket(market: CryptoMarketResponse?) {
        if let markets = market?.marketTicker24hr {
            cryptoPriceDic.removeAll()
            cryptoPercentDic.removeAll()
            cryptoSymbolDic.removeAll()
            for market in markets {
                if let id = market.coinId, let percent = market.priceChangePercent, let price = market.lastPrice, let symbol = market.symbol {
                    cryptoPriceDic[id] = price
                    cryptoPercentDic[id] = Double(percent)
                    cryptoSymbolDic[id] = symbol
                }
            }
        }
    }
    //判斷是否有幣種行情
    func judgeCryptoMarket() {
        let marketKeyArr = Array(cryptoPercentDic.keys)
        for id in highlightIdArr {
            if !(marketKeyArr.contains(id)) {
                if let index = highlightIdArr.index(of: id) {
                    highlightIdArr.remove(at: index)
                }
            }
        }
        
        for id in allIdArr {
            if !(marketKeyArr.contains(id)) {
                if let index = allIdArr.index(of: id) {
                    allIdArr.remove(at: index)
                }
            }
        }
    }
    
    
    @objc func notifyBtnClick() {
        
        let notifyViewController = UIStoryboard(name: "Notify", bundle: nil).instantiateViewController(withIdentifier: "notifyViewController")
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
        
        let index = searchText.index(searchText.startIndex, offsetBy: searchText.count)
        searchHighlightIdArr = highlightIdArr.filter({ name in
            return name.lowercased().prefix(upTo: index) == searchText.lowercased()
        })
        
        searchAllIdArr = allIdArr.filter({ name in
            return name.lowercased().prefix(upTo: index) == searchText.lowercased()
        })
        
        searching = true
        iHomeTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        iHomeTableView.reloadData()
    }
    
}

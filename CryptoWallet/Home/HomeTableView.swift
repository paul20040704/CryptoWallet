//
//  HomeTableView.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/16.
//

import UIKit

class HomeTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    var iHomeViewController: HomeViewController?
    
    override func awakeFromNib() {
        self.dataSource = self
        self.delegate = self
        self.contentInset = UIEdgeInsets.init(top: 15, left: 0, bottom: 15, right: 0)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        } else if (section == 1) {
            return 14
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableViewCellTitle", for: indexPath) as? HomeTableViewCellTitle {
                
                cell.iHomeTableView = self
                
                return cell
            } else {
                return UITableViewCell()
            }
        } else if (indexPath.section == 1) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableViewCellCoin", for: indexPath) as? HomeTableViewCellCoin {
                
                cell.iHomeTableView = self
                
                if (indexPath.row%7 == 0) {
                    cell.cellCoinImageView.image = UIImage.init(named: "coin_atom")
                    cell.cellCoinShortNameLabel.text = "ATOM"
                    cell.cellCoinFullNameLabel.text = "Cosmos"
                } else if (indexPath.row%7 == 1) {
                    cell.cellCoinImageView.image = UIImage.init(named: "coin_btc")
                    cell.cellCoinShortNameLabel.text = "BTC"
                    cell.cellCoinFullNameLabel.text = "Bitcoin"
                } else if (indexPath.row%7 == 2) {
                    cell.cellCoinImageView.image = UIImage.init(named: "coin_eth")
                    cell.cellCoinShortNameLabel.text = "ETH"
                    cell.cellCoinFullNameLabel.text = "Ethereum"
                } else if (indexPath.row%7 == 3) {
                    cell.cellCoinImageView.image = UIImage.init(named: "coin_ltc")
                    cell.cellCoinShortNameLabel.text = "LTC"
                    cell.cellCoinFullNameLabel.text = "Litecoin"
                } else if (indexPath.row%7 == 4) {
                    cell.cellCoinImageView.image = UIImage.init(named: "coin_usdt")
                    cell.cellCoinShortNameLabel.text = "USDT"
                    cell.cellCoinFullNameLabel.text = "Tether"
                } else if (indexPath.row%7 == 5) {
                    cell.cellCoinImageView.image = UIImage.init(named: "coin_xrp")
                    cell.cellCoinShortNameLabel.text = "XRP"
                    cell.cellCoinFullNameLabel.text = "XRP"
                } else if (indexPath.row%7 == 6) {
                    cell.cellCoinImageView.image = UIImage.init(named: "coin_iot")
                    cell.cellCoinShortNameLabel.text = "IOT"
                    cell.cellCoinFullNameLabel.text = "IOT"
                }
                
                var values: [CGFloat] = [CGFloat]()
                for _ in 1...10 {
                    let cgf = CGFloat.random(in: 0...100)
                    values.append(cgf)
                }
                
                if let image = getLineGraph(width: 400, height: 200, values: values, colorHex: "59ED3E") {
                    cell.cellCoinGraphImageView.image = image
                }
                
                return cell
            } else {
                return UITableViewCell()
            }
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt")
        if (indexPath.section == 1) {
            let candlestickChartViewController = UIStoryboard(name: "CandlestickChart", bundle: nil).instantiateViewController(withIdentifier: "candlestickChartViewController")
            self.iHomeViewController?.iTabBarController?.iTabBarMainViewController?.iTabBarNavigationController?.pushViewController(candlestickChartViewController, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

//
//  HomeTableView.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/16.
//

import UIKit

class HomeTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    var iHomeViewController: HomeViewController!
    
    override func awakeFromNib() {
        self.dataSource = self
        self.delegate = self
        self.contentInset = UIEdgeInsets.init(top: 15, left: 0, bottom: 15, right: 0)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            switch iHomeViewController?.sort {
            case "Default":
                if (iHomeViewController.searching){
                    return iHomeViewController?.searchHighlightIdArr.count ?? 0
                }else{
                    return iHomeViewController?.highlightIdArr.count ?? 0
                }
            default:
                if (iHomeViewController.searching) {
                    return iHomeViewController?.searchAllIdArr.count ?? 0
                }else{
                    return iHomeViewController?.allIdArr.count ?? 0
                }
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableViewCellTitle", for: indexPath) as! HomeTableViewCellTitle
                cell.iHomeTableView = self
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSearchCell", for: indexPath) as! HomeSearchCell
                cell.iHomeTableView = self
                cell.sortBtn.setTitle(iHomeViewController.sort, for: .normal)
                return cell
            }
        } else if (indexPath.section == 1) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableViewCellCoin", for: indexPath) as? HomeTableViewCellCoin {
                cell.iHomeTableView = self
                var id = String()
                switch iHomeViewController?.sort {
                case "Default":
                    if (iHomeViewController.searching) {
                        id = iHomeViewController.searchHighlightIdArr[indexPath.row]
                    }else{
                        id = iHomeViewController.highlightIdArr[indexPath.row]
                    }
                    
                case "All":
                    if (iHomeViewController.searching) {
                        id = iHomeViewController.searchAllIdArr[indexPath.row]
                    }else{
                        id = iHomeViewController.allIdArr[indexPath.row]
                    }
                    
                case "漲幅由高至低":
                    var idArr = Array<String>()
                    for item in iHomeViewController!.cryptoPercentDic.sorted(by: {$0.1 > $1.1}) {
                        idArr.append(item.key)
                    }
                    if (iHomeViewController.searching) {
                        for id in idArr {
                            if !(iHomeViewController.searchAllIdArr.contains(id)) {
                                if let index = idArr.index(of: id) {
                                    idArr.remove(at: index)
                                }
                            }
                        }
                        id = idArr[indexPath.row]
                    }else{
                        id = idArr[indexPath.row]
                    }
                    
                default:
                    var idArr = Array<String>()
                    for item in iHomeViewController!.cryptoPercentDic.sorted(by: {$0.1 < $1.1}) {
                        idArr.append(item.key)
                    }
                    if (iHomeViewController.searching) {
                        for id in idArr {
                            if !(iHomeViewController.searchAllIdArr.contains(id)) {
                                if let index = idArr.index(of: id) {
                                    idArr.remove(at: index)
                                }
                            }
                        }
                        id = idArr[indexPath.row]
                    }else{
                        id = idArr[indexPath.row]
                    }
                }
                
                cell.cellCoinImageView.image = UIImage(named: "coin_\(id.lowercased())")
                cell.cellCoinShortNameLabel.text = id
                cell.cellCoinFullNameLabel.text = iHomeViewController?.cryptoSummaryDic[id]
                cell.cellCoinPercentLabel.text = String(format: "%.2f", iHomeViewController?.cryptoPercentDic[id] ?? 0)
                cell.cellCoinPercentLabel.textColor()
                let double = Double(iHomeViewController?.cryptoPriceDic[id] ?? "0")
                cell.cellCoinValueLabel.text = String(format: "%.2f", double ?? 0)
                
                
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
        if (indexPath.section == 1) {
            if let cell = tableView.cellForRow(at: indexPath) as? HomeTableViewCellCoin {
                if let id = cell.cellCoinShortNameLabel.text {
                    let candlestickChartViewController = UIStoryboard(name: "CandlestickChart", bundle: nil).instantiateViewController(withIdentifier: "candlestickChartViewController") as! CandlestickChartViewController
                    candlestickChartViewController.symbol = id
                    candlestickChartViewController.price = cell.cellCoinValueLabel.text ?? ""
                    candlestickChartViewController.percent = iHomeViewController?.cryptoPercentDic[id] ?? 0
                    self.iHomeViewController?.iTabBarController?.iTabBarMainViewController?.iTabBarNavigationController?.pushViewController(candlestickChartViewController, animated: true)
                }
            }
        }
    }

}

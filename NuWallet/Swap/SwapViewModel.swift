//
//  SwapViewModel.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/7/1.
//

import Foundation

class SwapViewModel: NSObject {
    var swapDefaultDic = Dictionary<String, Double>() {
        didSet {
            self.swapReload?()
        }
    }
    
    var swapReload: (() -> ())?
    var swapModelDic = Dictionary<String, Array<String>>() // Swap幣種可以交換的清單
    var swapList = Array<String>() // 可以Swap的幣種
    var swapListMin = Dictionary<String, Double>() // Swap幣種最小值
    var swapDecimal = Dictionary<String, Int>() //Swap幣種支援小數點
    var swapWalletDic = Dictionary<String, Double>() // Swap幣種的餘額
    var fullCoinDic = Dictionary<String, String>() //幣種全名

    
    var walletDic = Dictionary<String, Double>() //資產幣種的餘額
    
    
    func getSwapModel() {
        swapModelDic.removeAll()
        swapList.removeAll()
        swapWalletDic.removeAll()
        fullCoinDic.removeAll()
        walletDic.removeAll()
        
        let group: DispatchGroup = DispatchGroup()
        let queue1 = DispatchQueue(label: "queue1")
        group.enter()
        queue1.async {
            BN.getSwapCoins { statusCode, dataObj, err in
                if (statusCode == 200) {
                    if let datas = dataObj?.data {
                        for data in datas {
                            self.swapList.append(data.fromCoinId ?? "")
                            var swapToArr = Array<String>()
                            if let toCoinArr = data.toCoinIdCollection {
                                for swap in toCoinArr {
                                    swapToArr.append(swap.coinId ?? "")
                                    self.swapListMin[swap.coinId ?? ""] = swap.swapMinQuantity ?? 0
                                    self.swapDecimal[swap.coinId ?? ""] = swap.swapFromCoinDecimalPlaces ?? 0
                                }
                            }
                            self.swapModelDic[data.fromCoinId ?? ""] = swapToArr
                        }
                    }
                    group.leave()
                }
            }
        }
        let queue2 = DispatchQueue(label: "queue2")
        group.enter()
        queue2.async {
            BN.getAssets { statusCode, dataObj, err in
                if(statusCode == 200) {
                    if let datas = dataObj?.assets {
                        for data in datas {
                            self.walletDic[data.coinId ?? ""] = data.balance ?? 0
                            self.fullCoinDic[data.coinId ?? ""] = data.coinFullName ?? ""
                        }
                    }
                }
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            for swapCoin in self.swapList {
                self.swapWalletDic[swapCoin] = self.walletDic[swapCoin]
            }
            
            let dicArr = self.swapWalletDic.sorted(by: {$0.1 > $1.1})
            if dicArr.count > 0 {
                
                var newTmpDic = Dictionary<String, Double>()
                self.swapList.removeAll()
                for dic in dicArr {
                    newTmpDic[dic.key] = dic.value
                    self.swapList.append(dic.key)
                }
                self.swapWalletDic = newTmpDic
                
                let dic = dicArr[0]
                self.swapDefaultDic[dic.key] = dic.value
                //self.defaultKey = dic.key
            }
        }
        
    }
    
    
    
}



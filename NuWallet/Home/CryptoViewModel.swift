//
//  CryptoModel.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/5/11.
//

import Foundation

class CryptoViewModel: NSObject {
    var cryptoModels: [CryptoModel] = [CryptoModel]() {
        didSet{
            self.reloadCrypto?()
        }
    }
    
    var reloadCrypto : (() -> ())?
    var listModel: ListModel?
    var fullDic = Dictionary<String, String>()
    //var symbolDic = Dictionary<String, String>()
    var priceDic = Dictionary<String, String>()
    var percentDic = Dictionary<String, Double>()
    
    func getCyypto() {
       
        var defaultKey = Array<String>()
        var allkey = Array<String>()
        fullDic.removeAll()
        //symbolDic.removeAll()
        priceDic.removeAll()
        percentDic.removeAll()
        BN.getCryptocurrency(headers: nil) { statusCode, dataObj, err in
            if (statusCode == 200) {
                if let hightlights = dataObj?.highlights {
                    for hightlight in hightlights {
                        defaultKey.append(hightlight.id ?? "")
                        allkey.append(hightlight.id ?? "")
                        self.fullDic[hightlight.id ?? ""] = hightlight.fullName
                    }
                }
                if let others = dataObj?.others {
                    for other in others {
                        allkey.append(other.id ?? "")
                        self.fullDic[other.id ?? ""] = other.fullName
                    }
                }
                BN.getCryptoMarketUsd(coins: allkey) { statusCode, dataObj, err in
                    if (statusCode == 200) {
                        if let markets = dataObj?.converts {
                            for market in markets {
                                if let id = market.coinId, let percent = market.percentChange24h, let price = market.price {
                                    self.priceDic[id] = String(price)
                                    self.percentDic[id] = percent
                                }
                            }
                            self.listModel = ListModel(defaultKey: defaultKey, allKey: allkey)
                            var vms = [CryptoModel]()
                            for key in allkey {
                                let fullName = self.fullDic[key] ?? ""
                                let price = self.priceDic[key] ?? "0"
                                let percent = self.percentDic[key] ?? 0
                                vms.append(CryptoModel(id: key, fullName: fullName, price: price, percent: percent))
                            }
                            self.cryptoModels = vms
                        }
                    }
                }
            }
        }
       
    }
    
    func sortId(sort: Int) -> Array<String>{
        var id = Array<String>()
        for cryptoModel in cryptoModels {
            percentDic[cryptoModel.id] = cryptoModel.percent
        }
        if sort == 0 {
            for item in percentDic.sorted(by: {$0.1 > $1.1}) {
                id.append(item.key)
            }
        }else{
            for item in percentDic.sorted(by: {$0.1 < $1.1}) {
                id.append(item.key)
            }
        }
        return id
    }
    
    
}

struct CryptoModel {
    
    let id: String
    let fullName: String
    let price: String
    let percent: Double
    

}

struct ListModel {
    
    let defaultKey: Array<String>
    let allKey: Array<String>
}



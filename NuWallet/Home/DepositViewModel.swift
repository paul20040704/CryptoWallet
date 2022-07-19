//
//  DepositViewModel.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/5/17.
//

import Foundation


class DepositViewModel: NSObject {
    var depositModels = Dictionary<String, DepositModel>() {
        didSet{
            self.reloadDeposit?()
        }
    }
    
    var reloadDeposit: (() -> ())?
    var coinIdArr = Array<String>()
    
    func getAsset() {
        var modelDic = Dictionary<String, DepositModel>()
        BN.getAssets { statusCode, dataObj, err in
            if (statusCode == 200) {
                if let assets = dataObj?.assets {
                    for asset in assets {
                        let model = DepositModel(coinId: asset.coinId ?? "", coinFullName: asset.coinFullName ?? "", balance: String(asset.balance ?? 0), tradeEnabled: asset.tradeEnabled ?? false, depositEnabled: asset.depositEnabled ?? false, withdrawalEnabled: asset.withdrawalEnabled ?? false)
                        modelDic[asset.coinId ?? ""] = model
                    }
                }
                self.coinIdArr = Array(modelDic.keys.sorted(by: <))
                self.depositModels = modelDic
            }
        }
    }
    
    
    
    
}


struct DepositModel {
    
    let coinId: String
    let coinFullName: String
    let balance: String
    let tradeEnabled: Bool
    let depositEnabled: Bool
    let withdrawalEnabled: Bool
}

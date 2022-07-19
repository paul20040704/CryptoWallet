//
//  WalletViewModel.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/5/12.
//

import Foundation

class WalletViewModel: NSObject {
    var walletModels: [WalletModel] = [WalletModel]() {
        didSet{
            self.reloadWallet?()
        }
    }

    var reloadWallet: (() -> ())?
    var estimatedBalance: Double?
    
    func getAsset() {
        
        var vms = [WalletModel]()
        BN.getAssets { statusCode, dataObj, err in
            if (statusCode == 200) {
                self.estimatedBalance = dataObj?.estimatedBalance?.rounding(toDecimal: 2)
                if let assets = dataObj?.assets {
                    for asset in assets {
                        vms.append(WalletModel(coinId: asset.coinId ?? "", coinFullName: asset.coinFullName ?? "", balance: String(asset.balance ?? 0), tradeEnabled: asset.tradeEnabled ?? false, depositEnabled: asset.depositEnabled ?? false, withdrawalEnabled: asset.withdrawalEnabled ?? false))
                    }
                }
                self.walletModels = vms.sorted{ $0.balance > $1.balance}
            }
        }
    }
    
    
    
    
}


struct WalletModel {
    
    let coinId: String
    let coinFullName: String
    let balance: String
    let tradeEnabled: Bool
    let depositEnabled: Bool
    let withdrawalEnabled: Bool
    
}

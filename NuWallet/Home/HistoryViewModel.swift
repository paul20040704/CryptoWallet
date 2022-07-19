//
//  HistoryViewModel.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/5/25.
//

import Foundation

class HistoryViewModel: NSObject {
    
    var reloadHistory : (() -> ())?
    
    var deposits = [TransactionModel]()
    var withdraws = [TransactionModel]()
    var swaps = [HistoryData]()
    
    func getHistory() {
        let group: DispatchGroup = DispatchGroup()
        let queue1 = DispatchQueue(label: "queue1")
        group.enter()
        queue1.async(group: group) {
            var models = [TransactionModel]()
            BN.getDepositHistory { statusCode, dataObj, err in
                if (statusCode == 200) {
                    if let datas = dataObj?.data {
                        for data in datas {
                            models.append(TransactionModel(transactionId: data.transactionId ?? "", coinId: data.coinId ?? "", quantity: data.quantity ?? 0, time: data.time ?? "", status: data.status ?? 0, isBtmTransaction: data.isBtmTransaction ?? false))
                        }
                        self.deposits = models
                    }
                }
                group.leave()
            }
        }
        
        let queue2 = DispatchQueue(label: "queue2")
        group.enter()
        queue2.async(group: group) {
            var models = [TransactionModel]()
            BN.getWithdrawHistory { statusCode, dataObj, err in
                if (statusCode == 200) {
                    if let datas = dataObj?.data {
                        for data in datas {
                            models.append(TransactionModel(transactionId: data.transactionId ?? "", coinId: data.coinId ?? "", quantity: data.quantity ?? 0, time: data.time ?? "", status: data.status ?? 0, isBtmTransaction: data.isBtmTransaction ?? false))
                        }
                        self.withdraws = models
                    }
                }
                group.leave()
            }
        }
        
        let queue3 = DispatchQueue(label: "queue3")
        group.enter()
        queue3.async(group: group) {
            BN.getSwapHistory { statusCode, dataObj, err in
                if (statusCode == 200) {
                    if let data = dataObj?.data {
                        self.swaps = data
                    }
                }
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.reloadHistory?()
        }
        
    }
    
}


struct TransactionModel {
    
    let transactionId: String
    let coinId: String
    let quantity: Double
    let time: String
    let status: Int
    let isBtmTransaction: Bool

}

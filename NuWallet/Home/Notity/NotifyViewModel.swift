//
//  NotifyViewModel.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/7/14.
//

import Foundation

class NotifyViewModel: NSObject {
    var notifyList = Dictionary<Int, BoardModel>() {
        didSet {
            self.reloadData?()
        }
    }
    
    var reloadData: (() -> ())?
    var sortBoardKey = Array<Int>() //key根據時間排序
    var boardTimeDic = Dictionary<Int, String>()
    var unreadCount = 0 //未讀數量
    
    
    func getBoardList() {
        let now = US.dateToStringMS(date: Date())
        let halfYear = US.halfDateString()
        
        var vms = Dictionary<Int, BoardModel>()
        boardTimeDic.removeAll()
        
        BN.getBoardList(startOn: halfYear,endOn: now) { statusCode, dataObj, err in
            if (statusCode == 200) {
                if let list = dataObj?.bulletinBoardDataList {
                    for info in list {
                        vms[info.id ?? 0] = BoardModel(id: info.id ?? 0,title: info.title ?? "", article: info.article ?? "", postOn: info.postOn ?? "")
                        self.boardTimeDic[info.id ?? 0] = info.postOn ?? ""
                    }
                }
                self.sortBoardDic()
                self.judgeFirstRead()
                self.notifyList = vms
            }
        }
    }
    
    func judgeFirstRead() {
        if let readList = UD.object(forKey: "boardRead") as? Array<Int> {
            var unread = 0
            for key in sortBoardKey {
                if !(readList.contains(key)) {
                    unread += 1
                }
            }
            unreadCount = unread
        }else{
            UD.set(sortBoardKey, forKey: "boardRead")
        }
    }
    
    func sortBoardDic() {
        sortBoardKey.removeAll()
        for item in boardTimeDic.sorted(by: {$0.1 > $1.1}) {
            sortBoardKey.append(item.key)
        }
    }
    
}

struct BoardModel {
    let id: Int
    let title: String
    let article: String
    let postOn: String
}



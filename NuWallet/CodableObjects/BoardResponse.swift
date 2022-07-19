//
//  BoardResponse.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/7/14.
//

import Foundation


struct BoardList: Codable {
    let bulletinBoardDataList: [ListData]?
}

struct ListData: Codable {
    let id: Int?
    let title: String?
    let article: String?
    let postOn: String?
}

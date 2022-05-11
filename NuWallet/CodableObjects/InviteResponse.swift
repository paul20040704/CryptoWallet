//
//  InviteResponse.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/4/28.
//

import Foundation

struct InvitationsResponse: Codable {
    let data: [DataResponse]?
    let currentPage: Int?
    let totalPages: Int?
    let totalCount: Int?
    let pageSize: Int?
    let hasPreviousPage: Bool?
    let hasNextPage: Bool?
}




struct DataResponse: Codable {
    let mobile: String?
    let date: String?
}

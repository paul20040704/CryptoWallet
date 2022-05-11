//
//  ErrorResponse.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/15.
//

import Foundation

struct ErrorResponse: Codable {
    //let messages: [String]?
    //let source: String?
    let exception: String?
    //let errorId: String?
    //let supportMessage: String?
    let statusCode: Int?
}



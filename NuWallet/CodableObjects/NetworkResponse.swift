//
//  NetworkResponse.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/6/30.
//

import Foundation

struct AppleData: Codable {
    let resultCount: Int?
    let results: [Result]?
}

struct Result: Codable {
    let version: String?
}


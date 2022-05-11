//
//  Cryptocurrency.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/22.
//

import Foundation

struct CryptoResponse: Codable {
    
    let highlights: [Highlights]?
    let others: [Others]?
    
}

struct Highlights: Codable {
    
    let id: String?
    let shortName: String?
    let fullName: String?
    
}

struct Others: Codable {
    
    let id: String?
    let shortName: String?
    let fullName: String?
 
}


struct CryptoMarketResponse: Codable {
    
    let marketTicker24hr: [marketTicker24hrs]?
    
}

struct marketTicker24hrs: Codable {
    
    let coinId: String?
    let symbol: String?
    let priceChangePercent: String?
    let lastPrice: String?
    
}


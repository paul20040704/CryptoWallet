//
//  KYCResponse.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/21.
//

import Foundation

struct KYCResoponse: Codable {
    
    let nationality: String?
    let bitrhday: String?
    let lastName: String?
    let firstName: String?
    let typeOfCertificate: String?
    let reasonsForRejection: String?
    let typeOfRejection: Int?
    
}

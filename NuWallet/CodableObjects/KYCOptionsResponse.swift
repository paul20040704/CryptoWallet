//
//  KYCOptionsResponse.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/18.
//

import Foundation

struct KYCOptionsResponse: Codable {
    let nationality: [Nationality]
    let countryOfResidence: [CountryOfResidence]
    let gender: [Gender]
    let employmentStatus: [EmploymentStatus]
    let industry: [Industry]
    let totalAnnualIncome: [TotalAnnualIncome]
    let sourceOfFunds: [SourceOfFunds]
    let typeOfCertificate: [TypeOfCertificate]
    
}

struct Nationality: Codable {
    let key: String?
    let value: String?
}

struct CountryOfResidence: Codable {
    let key: String?
    let value: String?
}

struct Gender: Codable {
    let key: Int?
    let value: String?
}

struct EmploymentStatus: Codable {
    let key: Int?
    let value: String?
}

struct Industry: Codable {
    let key: Int?
    let value: String?
}

struct TotalAnnualIncome: Codable {
    let key: Int?
    let value: String?
}

struct SourceOfFunds: Codable {
    let key: Int?
    let value: String?
}

struct TypeOfCertificate: Codable {
    let key: Int?
    let value: String?
}

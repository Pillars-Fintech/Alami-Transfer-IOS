//
//  BanksResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 9/16/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - BanksResponse
struct BanksResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: [BankDatum]?
}

// MARK: - Datum
struct BankDatum: Codable {
    let bankID, code, name, countryID: String?
    let countryName, startIBANCode: String?
    let accountLength: Int?
    let addressFree, routingNumber, swiftCode, sortCode: String?

    enum CodingKeys: String, CodingKey {
        case bankID = "BankId"
        case code = "Code"
        case name = "Name"
        case countryID = "CountryId"
        case countryName = "CountryName"
        case startIBANCode = "StartIBANCode"
        case accountLength = "AccountLength"
        case addressFree = "AddressFree"
        case routingNumber = "RoutingNumber"
        case swiftCode = "SwiftCode"
        case sortCode = "SortCode"
    }
}

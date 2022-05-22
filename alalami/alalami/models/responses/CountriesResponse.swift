//
//  CountriesResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 8/31/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - CountriesResponse
struct CountriesResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: [CountryDatum]?
}

// MARK: - Datum
struct CountryDatum: Codable {
    let id, name, iso2: String?
    let iso3: String?
    let afexCode: Int?
    let moneyGramCode, moneyGramAnathorCode, moneyGramDescription: String?
    let moneyGramIncludeSend, moneyGramIncludeReceive, moneyGramIsDirectedSendCountry: Bool?
    let eFAWATEERcomCode, eFAWATEERcomDescription: String?
    let country_code : String?
    let flag : String?

    enum CodingKeys: String, CodingKey {
        case id = "CountryId"
        case name = "Name"
        case iso2 = "ISO2"
        case iso3 = "ISO3"
        case afexCode = "AfexCode"
        case moneyGramCode = "MoneyGramCode"
        case moneyGramAnathorCode = "MoneyGramAnathorCode"
        case moneyGramDescription = "MoneyGramDescription"
        case moneyGramIncludeSend = "MoneyGramIncludeSend"
        case moneyGramIncludeReceive = "MoneyGramIncludeReceive"
        case moneyGramIsDirectedSendCountry = "MoneyGramIsDirectedSendCountry"
        case eFAWATEERcomCode, eFAWATEERcomDescription
        case country_code = "country_code"
        case flag = "Flag"
    }
}

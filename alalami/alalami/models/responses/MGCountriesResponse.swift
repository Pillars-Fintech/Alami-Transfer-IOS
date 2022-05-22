//
//  MGCountriesResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 9/24/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - MGCountriesResponse
struct MGCountriesResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: [MGCountryDatum]?
}

// MARK: - Datum
struct MGCountryDatum: Codable {
    var countryCode, countryName: String?
    let countryId, countryPhoneCode: String?
    let flag : String?
    let curencyIso3: String?

    enum CodingKeys: String, CodingKey {
        case countryCode = "CountryCode"
        case countryName = "CountryName"
        case countryId = "CountryId"
        case countryPhoneCode = "CountryPhoneCode"
        case flag = "Flag"
        case curencyIso3 = "CurrencyISO3"
    }
}

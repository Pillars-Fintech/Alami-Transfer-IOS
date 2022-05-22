//
//  CountryCodesResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 9/2/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - CountryCodesResponse
struct CountryCodesResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: [CountryCodeDatum]?
}

// MARK: - Datum
struct CountryCodeDatum: Codable {
    let id, name, iso2: String?
    let iso3, postCode: String?
    let isActive: Bool?
    let flag : String?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case iso2 = "ISO2"
        case iso3 = "ISO3"
        case postCode = "PostCode"
        case isActive = "IsActive"
        case flag = "Flag"
    }
}

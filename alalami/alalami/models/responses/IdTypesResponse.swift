//
//  IdTypesResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 8/31/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - IDTypesResponse
struct IDTypesResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: [IdTypeDatum]?
}

// MARK: - Datum
struct IdTypeDatum: Codable {
    let id: String?
    let clientTypeID: Int?
    let code, name, moneyGramCode: String?
    let moneyGramDescription, eFAWATEERcomCode, eFAWATEERcomDescription: String?

    enum CodingKeys: String, CodingKey {
        case id = "IdentityTypeId"
        case clientTypeID = "ClientTypeId"
        case code = "Code"
        case name = "Name"
        case moneyGramCode = "MoneyGramCode"
        case moneyGramDescription = "MoneyGramDescription"
        case eFAWATEERcomCode, eFAWATEERcomDescription
    }
}

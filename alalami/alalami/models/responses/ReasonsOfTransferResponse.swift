//
//  ReasonsOfTransferResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 9/7/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - ReasonsOfTransferResponse
struct ReasonsOfTransferResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: [ReasonOfTransferDatum]?
}

// MARK: - Datum
struct ReasonOfTransferDatum: Codable {
    let reasonOfTransferID, code, name, moneyGramCode: String?
    let moneyGramDescription: String?

    enum CodingKeys: String, CodingKey {
        case reasonOfTransferID = "ReasonOfTransferId"
        case code = "Code"
        case name = "Name"
        case moneyGramCode = "MoneyGramCode"
        case moneyGramDescription = "MoneyGramDescription"
    }
}

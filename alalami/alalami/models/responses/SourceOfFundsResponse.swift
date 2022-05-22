//
//  SourceOfFundsResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 9/7/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation


struct SourceOfFundsResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: [SourceOfFundsDatum]?
}

// MARK: - Datum
struct SourceOfFundsDatum: Codable {
    let sourceOfFundsID, code, name, moneyGramCode: String?
    let moneyGramDescription: String?

    enum CodingKeys: String, CodingKey {
        case sourceOfFundsID = "SourceOfFundsId"
        case code = "Code"
        case name = "Name"
        case moneyGramCode = "MoneyGramCode"
        case moneyGramDescription = "MoneyGramDescription"
    }
}

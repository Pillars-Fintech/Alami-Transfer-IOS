//
//  RelationToReceiverResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 9/7/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - RelationToReceiverResponse
struct RelationToReceiverResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: [RelationToReceiverDatum]?
}

// MARK: - Datum
struct RelationToReceiverDatum: Codable {
    let relationToReceiverID, code, name, moneyGramCode: String?
    let moneyGramDescription: String?

    enum CodingKeys: String, CodingKey {
        case relationToReceiverID = "RelationToReceiverId"
        case code = "Code"
        case name = "Name"
        case moneyGramCode = "MoneyGramCode"
        case moneyGramDescription = "MoneyGramDescription"
    }
}

//
//  RemittanceDynamicDetailsResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 12/3/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - RemittanceDynamicDetailsResponse
struct RemittanceDynamicDetailsResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: RemDetailsClass?
}

// MARK: - DataClass
struct RemDetailsClass: Codable {
    let customerID, remittanceNumber, transactionDate: String?
    let remettancesStatusID: Int?
    let remettancesStatusName, tapTitel1, cardTitel1, tapTitel2: String?
    let cardTitel2: String?
    let detialsTab1, detialsTab2: [DetialsTab]?
    let isSend : Bool?
    let CanBeAmended, CanBeCancel : Bool?

    enum CodingKeys: String, CodingKey {
        case customerID = "CustomerId"
        case remittanceNumber = "RemittanceNumber"
        case transactionDate = "TransactionDate"
        case remettancesStatusID = "RemettancesStatusId"
        case remettancesStatusName = "RemettancesStatusName"
        case tapTitel1 = "TapTitel1"
        case cardTitel1 = "CardTitel1"
        case tapTitel2 = "TapTitel2"
        case cardTitel2 = "CardTitel2"
        case detialsTab1 = "DetialsTab1"
        case detialsTab2 = "DetialsTab2"
        case isSend = "IsSend"
        case CanBeAmended = "CanBeAmended"
        case CanBeCancel = "CanBeCancel"
    }
}

// MARK: - DetialsTab
struct DetialsTab: Codable {
    let value, caption, icon: String?
    let index: Int?

    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case caption = "Caption"
        case icon = "Icon"
        case index = "Index"
    }
}

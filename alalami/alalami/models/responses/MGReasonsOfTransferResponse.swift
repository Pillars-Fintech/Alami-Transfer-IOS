//
//  MGReasonsOfTransferResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 9/24/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - MGReasonsOfTransferResponse
struct MGReasonsOfTransferResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: [MGReasonOfTransferDatum]?
}

// MARK: - Datum
struct MGReasonOfTransferDatum: Codable {
    let reasonOfTransferID, reasonOfTransferCode, reasonOfTransferName: String?

    enum CodingKeys: String, CodingKey {
        case reasonOfTransferID = "ReasonOfTransferId"
        case reasonOfTransferCode = "ReasonOfTransferCode"
        case reasonOfTransferName = "ReasonOfTransferName"
    }
}

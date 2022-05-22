//
//  RCVReasonsOfTransferResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 12/3/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - MGReasonsOfTransferResponse
struct RCVReasonsOfTransferResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: [RCVReasonOfTransfer]?
}

// MARK: - Datum
struct RCVReasonOfTransfer: Codable {
    let reasonOfTransferID, reasonOfTransferName: String?

    enum CodingKeys: String, CodingKey {
        case reasonOfTransferID = "Value"
        case reasonOfTransferName = "Text"
    }
}

//
//  MGSourceOfFundsResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 9/24/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - MGSourceOfFundsResponse
struct MGSourceOfFundsResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: [MGSourceOfFundsDatum]?
}

// MARK: - Datum
struct MGSourceOfFundsDatum: Codable {
    let sourceOfFundID, sourceOfFundCode, sourceOfFundName: String?

    enum CodingKeys: String, CodingKey {
        case sourceOfFundID = "SourceOfFundId"
        case sourceOfFundCode = "SourceOfFundCode"
        case sourceOfFundName = "SourceOfFundName"
    }
}

//
//  RCVRelationshipsResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 12/3/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - MGRelationToReceiverResponse
struct RCVRelationshipsResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: [RCVRelationship]?
}

// MARK: - Datum
struct RCVRelationship: Codable {
    let relationshipsID, relationshipsName: String?

    enum CodingKeys: String, CodingKey {
        case relationshipsID = "Value"
        case relationshipsName = "Text"
    }
}

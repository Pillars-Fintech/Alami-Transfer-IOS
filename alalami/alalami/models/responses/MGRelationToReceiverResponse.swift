//
//  MGRelationToReceiverResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 9/24/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - MGRelationToReceiverResponse
struct MGRelationToReceiverResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: [MGRelationToReceiverDatum]?
}

// MARK: - Datum
struct MGRelationToReceiverDatum: Codable {
    let relationshipsID, relationshipsCode, relationshipsName: String?

    enum CodingKeys: String, CodingKey {
        case relationshipsID = "RelationshipsId"
        case relationshipsCode = "RelationshipsCode"
        case relationshipsName = "RelationshipsName"
    }
}

//
//  RejectionReasonsResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 10/28/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - RejectionReasonsResponse
struct RejectionReasonsResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: [RejectionReasonDatum]?
}

// MARK: - Datum
struct RejectionReasonDatum: Codable {
    let caption, value: String?
    let index: Int?

    enum CodingKeys: String, CodingKey {
        case caption = "Caption"
        case value = "Value"
        case index = "Index"
    }
}

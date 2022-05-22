//
//  UpdateProfileResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 11/3/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - RejectionReasonsResponse
struct UpdateProfileResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: [UpdateDatum]?
}

// MARK: - Datum
struct UpdateDatum: Codable {
    let caption, value: String?
    let index: Int?

    enum CodingKeys: String, CodingKey {
        case caption = "Caption"
        case value = "Value"
        case index = "Index"
    }
}

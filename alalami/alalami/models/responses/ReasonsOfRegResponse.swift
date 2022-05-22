//
//  ReasonsOfRegResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 9/1/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - ReasonsOfRegResponse
struct ReasonsOfRegResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: [ReasonOfRegDatum]?
}

// MARK: - Datum
struct ReasonOfRegDatum: Codable {
    let reasonOfRegistrationID, code, name: String?

    enum CodingKeys: String, CodingKey {
        case reasonOfRegistrationID = "ReasonOfRegistrationId"
        case code = "Code"
        case name = "Name"
    }
}

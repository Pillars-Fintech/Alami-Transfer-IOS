//
//  PayOutMethodsResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 9/7/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - PayOutMethodsResponse
struct PayOutMethodsResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: [PayOutMethodDatum]?
}

// MARK: - Datum
struct PayOutMethodDatum: Codable {
    let payoutMethodID: Int?
    let name, code: String?

    enum CodingKeys: String, CodingKey {
        case payoutMethodID = "PayoutMethodId"
        case name = "Name"
        case code = "Code"
    }
}

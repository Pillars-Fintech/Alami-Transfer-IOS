//
//  PayInMethodsResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 9/7/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - PayInMethodsResponse
struct PayInMethodsResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: [PayInMethodDatum]?
}

// MARK: - Datum
struct PayInMethodDatum: Codable {
    let payMethodsResponseID: Int?
    let name, code, logo: String?

    enum CodingKeys: String, CodingKey {
        case payMethodsResponseID = "PayMethodsResponseId"
        case name = "Name"
        case code = "Code"
        case logo = "LogoURL"
    }
}

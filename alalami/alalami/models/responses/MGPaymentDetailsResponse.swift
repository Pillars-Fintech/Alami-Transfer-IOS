//
//  MGPaymentDetailsResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 9/28/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - MGPaymentDetailsResponse
struct MGPaymentDetailsResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: MGDetailsClass?
}

// MARK: - DataClass
struct MGDetailsClass: Codable {
    let includeOTP: Bool?
    let confirmInfo: [MGResponseList]?
    let PayMethodId:Int


    enum CodingKeys: String, CodingKey {
        case includeOTP = "IncludeOTP"
        case confirmInfo = "ConfirmInfo"
        case PayMethodId = "PayMethodId"

    }
}

// MARK: - ConfirmInfo
struct MGResponseList: Codable {
    let icon: String?
    let index: Int?
    let value, caption: String?

    enum CodingKeys: String, CodingKey {
        case icon = "Icon"
        case index = "Index"
        case value = "Value"
        case caption = "Caption"
    }
}

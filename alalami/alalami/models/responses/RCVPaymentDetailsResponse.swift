//
//  RCVPaymentDetailsResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 12/3/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - RCVPaymentDetailsResponse
struct RCVPaymentDetailsResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: RCVConfirm?
}

// MARK: - DataClass
struct RCVConfirm: Codable {
    let includeOTP: Bool?
    let rcvGUID: String?
    let confirmInfo: [ConfirmInfo]?

    enum CodingKeys: String, CodingKey {
        case includeOTP = "IncludeOTP"
        case rcvGUID = "RCVGuid"
        case confirmInfo = "ConfirmInfo"
    }
}

// MARK: - ConfirmInfo
struct ConfirmInfo: Codable {
    let caption, value, icon: String?
    let index: Int?

    enum CodingKeys: String, CodingKey {
        case caption = "Caption"
        case value = "Value"
        case icon = "Icon"
        case index = "Index"
    }
}

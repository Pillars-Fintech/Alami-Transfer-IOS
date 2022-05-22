//
//  SendMoneyResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 9/16/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - SendMoneyResponse
struct SendMoneyResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: [MGSentDatum]?
}

// MARK: - Datum
struct MGSentDatum: Codable {
    let caption, value: String?
    let index: Int?

    enum CodingKeys: String, CodingKey {
        case caption = "Caption"
        case value = "Value"
        case index = "Index"
    }
}

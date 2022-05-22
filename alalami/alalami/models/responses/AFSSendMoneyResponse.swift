//
//  AFSSendMoneyResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 9/28/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - AfsSendM
struct AFSSendMoneyResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: [AfsSentDatum]?
}

// MARK: - Datum
struct AfsSentDatum: Codable {
    let caption, value: String?
    let index: Int?

    enum CodingKeys: String, CodingKey {
        case caption = "Caption"
        case value = "Value"
        case index = "Index"
    }
}

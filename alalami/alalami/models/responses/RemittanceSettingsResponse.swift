//
//  RemittanceSettingsResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 11/8/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - RemittanceSettingsResponse
struct RemittanceSettingsResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: [RemittanceSettingsDatum]?
}

// MARK: - Datum
struct RemittanceSettingsDatum: Codable {
    let id: Int?
    let icon, name, value, valueType: String?
    let explain, color: String?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case icon = "Icon"
        case name = "Name"
        case value = "Value"
        case valueType = "ValueType"
        case explain = "Explain"
        case color = "Color"
    }
}

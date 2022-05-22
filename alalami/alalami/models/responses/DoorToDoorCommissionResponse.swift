//
//  DoorToDoorCommissionResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 9/9/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - DoorToDoorCommissionResponse
struct DoorToDoorCommissionResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: DoorToDoorCommissionClass?
}

// MARK: - DataClass
struct DoorToDoorCommissionClass: Codable {
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

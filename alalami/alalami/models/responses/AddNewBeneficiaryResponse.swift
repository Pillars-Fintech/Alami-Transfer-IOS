//
//  AddNewBeneficiaryResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 10/27/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - AddNewBeneficiaryResponse
struct AddNewBeneficiaryResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: [AddBeneDatum]?
}

// MARK: - Datum
struct AddBeneDatum: Codable {
    let caption, value: String?
    let index: Int?

    enum CodingKeys: String, CodingKey {
        case caption = "Caption"
        case value = "Value"
        case index = "Index"
    }
}

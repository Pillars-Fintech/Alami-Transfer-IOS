//
//  BranchesResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 9/7/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - BranchesResponse
struct BranchesResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: [BranchDatum]?
}

// MARK: - Datum
struct BranchDatum: Codable {
    let branchID, code, afexCode, name: String?
    let address, phone, fax: String?
    let longitude, latitude: String?
    let afexCostCenterID: Int?
    let activeInSend, activeInReceive, hasPhysicalLocation: Bool?

    enum CodingKeys: String, CodingKey {
        case branchID = "BranchId"
        case code = "Code"
        case afexCode = "AfexCode"
        case name = "Name"
        case address = "Address"
        case phone = "Phone"
        case fax = "Fax"
        case longitude = "Longitude"
        case latitude = "Latitude"
        case afexCostCenterID = "AfexCostCenterId"
        case activeInSend = "ActiveInSend"
        case activeInReceive = "ActiveInReceive"
        case hasPhysicalLocation = "HasPhysicalLocation"
    }
}

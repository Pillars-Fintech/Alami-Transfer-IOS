//
//  ServicesResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 9/6/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - ServicesResponse
struct ServicesResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: [ServiceDatum]?
}

// MARK: - Datum
struct ServiceDatum: Codable {
    let servicesProviderID, code: String?
    let isAvailableSend, isAvailableReceived: Bool?
    let name, shortName, explain, logo: String?
    let color, backgroundColor: String?

    enum CodingKeys: String, CodingKey {
        case servicesProviderID = "ServicesProviderId"
        case code = "Code"
        case isAvailableSend = "IsAvailableSend"
        case isAvailableReceived = "IsAvailableReceived"
        case name = "Name"
        case shortName = "ShortName"
        case explain = "Explain"
        case logo = "Logo"
        case color = "Color"
        case backgroundColor = "BackgroundColor"
    }
}

//
//  WalletProvidersResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 9/7/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - WalletProvidersResponse
struct WalletProvidersResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: [WalletProviderDatum]?
}

// MARK: - Datum
struct WalletProviderDatum: Codable {
    let walletsProvidersID, code: String?
    let isAvailableSend, isAvailableReceived: Bool?
    let name, shortName, logo, color: String?
    let backgroundColor: String?

    enum CodingKeys: String, CodingKey {
        case walletsProvidersID = "WalletsProvidersId"
        case code = "Code"
        case isAvailableSend = "IsAvailableSend"
        case isAvailableReceived = "IsAvailableReceived"
        case name = "Name"
        case shortName = "ShortName"
        case logo = "Logo"
        case color = "Color"
        case backgroundColor = "BackgroundColor"
    }
}

//
//  ServiceCommisionsResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 9/7/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - ServiceCommisionsResponse
struct ServiceCommisionsResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: ServiceCommissionClass?
}

// MARK: - DataClass
struct ServiceCommissionClass: Codable {
    let id, serviceProviderID: String?
    let fromAmount, toAmount, feeAmount, amonut: Double?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case serviceProviderID = "ServiceProviderId"
        case fromAmount = "FromAmount"
        case toAmount = "ToAmount"
        case feeAmount = "FeeAmount"
        case amonut = "Amonut"
    }
}

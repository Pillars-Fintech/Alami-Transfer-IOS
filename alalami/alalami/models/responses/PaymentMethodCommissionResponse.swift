//
//  PaymentMethodCommissionResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 9/9/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - PaymentMethodCommissionResponse
struct PaymentMethodCommissionResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: PaymentMethodCommissionClass?
}

// MARK: - DataClass
struct PaymentMethodCommissionClass: Codable {
    let id: String?
    let payMethodID: Int?
    let fromAmount, toAmount, feeAmount, amonut: Double?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case payMethodID = "PayMethodId"
        case fromAmount = "FromAmount"
        case toAmount = "ToAmount"
        case feeAmount = "FeeAmount"
        case amonut = "Amonut"
    }
}

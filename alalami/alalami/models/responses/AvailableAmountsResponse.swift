//
//  AvailableAmountsResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 10/26/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - MGRewardResponse
struct AvailableAmountsResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: Double?
}

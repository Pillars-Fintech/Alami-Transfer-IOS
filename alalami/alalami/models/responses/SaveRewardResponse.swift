//
//  SaveRewardResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 9/24/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - SaveRewardResponse
struct SaveRewardResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: String?
}

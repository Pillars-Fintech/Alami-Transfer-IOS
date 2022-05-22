//
//  OnTimeAuthorizeResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 11/3/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - OnTimeAuthorizeResponse
struct OnTimeAuthorizeResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: String?
}


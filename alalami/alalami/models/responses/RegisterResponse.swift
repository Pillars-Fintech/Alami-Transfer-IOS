//
//  RegisterResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 9/2/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - RegisterResponse
struct RegisterResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: RegisterClass?
}

// MARK: - DataClass
struct RegisterClass: Codable {
    let accessToken, tokenType: String?
    let expiresIn: Int?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}

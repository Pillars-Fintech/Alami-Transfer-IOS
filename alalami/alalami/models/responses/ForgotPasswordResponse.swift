//
//  ForgotPasswordResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 9/3/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - ForgotPasswordResponse
struct ForgotPasswordResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: String?
}

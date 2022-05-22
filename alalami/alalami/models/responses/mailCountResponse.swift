//
//  mailCountResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 10/1/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - MailCountResponse
struct MailCountResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: MailCountClass?
}

// MARK: - DataClass
struct MailCountClass: Codable {
    let messageCount: Int?

    enum CodingKeys: String, CodingKey {
        case messageCount = "MessageCount"
    }
}

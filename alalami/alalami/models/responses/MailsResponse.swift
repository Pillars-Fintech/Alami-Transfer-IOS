//
//  MailsResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 10/1/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - MailsResponse
struct MailsResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: [MailDatum]?
}

// MARK: - Datum
struct MailDatum: Codable {
    let id, email, emailSubject, body: String?
    let isSend: Bool?
    let sendDate, byModel, customerID: String?
    let messageCount: Int?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case email = "Email"
        case emailSubject = "EmailSubject"
        case body = "Body"
        case isSend = "IsSend"
        case sendDate = "SendDate"
        case byModel = "ByModel"
        case customerID = "CustomerId"
        case messageCount = "MessageCount"
    }
}

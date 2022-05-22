//
//  AFSPaymentDetailsResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 10/16/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - AFSPaymentDetailsResponse
struct AFSPaymentDetailsResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: AFSPaymentDetailsClass?
}

// MARK: - DataClass
struct AFSPaymentDetailsClass: Codable {
    let afsGUID, senderName, receiverName, sendAmount: String?
    let receiveAmount, fee, totalDueAmount, payMethod: String?
    let destinationBranch: String?
    let includeOTP : Bool?

    enum CodingKeys: String, CodingKey {
        case afsGUID = "AFSGuid"
        case senderName = "SenderName"
        case receiverName = "ReceiverName"
        case sendAmount = "SendAmount"
        case receiveAmount = "ReceiveAmount"
        case fee = "Fee"
        case totalDueAmount = "TotalDueAmount"
        case payMethod = "PayMethod"
        case destinationBranch = "DestinationBranch"
        case includeOTP = "IncludeOTP"
    }
}

//
//  TransactionDetailsResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 9/16/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - TransactionDetailsResponse
struct TransactionDetailsResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: TransactionDatum?
}

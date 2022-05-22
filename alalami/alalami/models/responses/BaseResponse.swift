//
//  BaseResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 9/2/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - BaseResponse
struct BaseResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
}

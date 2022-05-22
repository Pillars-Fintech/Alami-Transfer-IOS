//
//  RewardSuggestionsResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 9/24/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - RewardSuggestionsResponse
struct RewardSuggestionsResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: RewardClass?
}

// MARK: - DataClass
struct RewardClass: Codable {
    let consumerAddress, consumerCity, consumerDOB: String?
    let consumerFirstName, consumerHomePhone, consumerLastName: String?
    
    let consumerCountry, consumerCountryName, consumerCountryFlag : String?
    
    enum CodingKeys: String, CodingKey {
        case consumerAddress = "ConsumerAddress"
        case consumerCity = "ConsumerCity"
        case consumerCountry = "ConsumerCountry"
        case consumerCountryName = "ConsumerCountryName"
        case consumerCountryFlag = "ConsumerCountryFlag"
        case consumerDOB = "ConsumerDOB"
        case consumerFirstName = "ConsumerFirstName"
        case consumerHomePhone = "ConsumerHomePhone"
        case consumerLastName = "ConsumerLastName"
    }
}

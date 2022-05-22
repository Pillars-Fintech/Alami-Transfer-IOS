//
//  FlashCardsResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 9/6/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - FlashCardsResponse
struct FlashCardsResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: [FlashCardDatum]?
}

// MARK: - Datum
struct FlashCardDatum: Codable {
    let id, image, innerImage, title, datumDescription: String?
    let actionType: Int?
    let actionValue: String?
    let isVisible: Bool?
    let expiryDate, color: String?

    enum CodingKeys: String, CodingKey {
        case id, image, title
        case innerImage = "innerImage"
        case datumDescription = "description"
        case actionType, actionValue, isVisible, expiryDate, color
    }
}

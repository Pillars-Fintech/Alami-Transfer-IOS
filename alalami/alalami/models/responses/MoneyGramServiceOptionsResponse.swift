//
//  MoneyGramServiceOptionsResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 9/7/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - MoneyGramServiceOptionsResponse
class MoneyGramServiceOptionsResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: [MoneyGramServiceOptionsDatum]?

    init(success: Bool?, code: String?, message: [String]?, data: [MoneyGramServiceOptionsDatum]?) {
        self.success = success
        self.code = code
        self.message = message
        self.data = data
    }
}

// MARK: - Datum
class MoneyGramServiceOptionsDatum: Codable {
    let mgSendTransactionID, mgGUID: String?
    let responseLists: [ResponseList]?
    var isChecked : Bool?

    enum CodingKeys: String, CodingKey {
        case mgSendTransactionID = "MGSendTransactionId"
        case mgGUID = "MGGuid"
        case responseLists = "ResponseLists"
    }

    init(mgSendTransactionID: String?, mgGUID: String?, responseLists: [ResponseList]?) {
        self.mgSendTransactionID = mgSendTransactionID
        self.mgGUID = mgGUID
        self.responseLists = responseLists
    }
}

// MARK: - ResponseList
class ResponseList: Codable {
    let caption, value: String?
    let icon: String?
    let index: Int?

    enum CodingKeys: String, CodingKey {
        case caption = "Caption"
        case value = "Value"
        case icon = "Icon"
        case index = "Index"
    }

    init(caption: String?, value: String?, icon: String?, index: Int?) {
        self.caption = caption
        self.value = value
        self.icon = icon
        self.index = index
    }
}

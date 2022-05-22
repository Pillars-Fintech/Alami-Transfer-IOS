//
//  MyBeneficiariesResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 10/27/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - MyBeneficiariesResponse
struct MyBeneficiariesResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: [MyBeneficiaryDatum]?
}

// MARK: - Datum
struct MyBeneficiaryDatum: Codable {
    let beneficiaryID, firstNameAr, secondNameAr, thirdNameAr: String?
    let lastNameAr, firstNameEn, secondNameEn, thirdNameEn: String?
    let lastNameEn, countryID, countryNameAr, countryNameEn: String?
    let mobile: String?

    enum CodingKeys: String, CodingKey {
        case beneficiaryID = "BeneficiaryId"
        case firstNameAr = "FirstNameAr"
        case secondNameAr = "SecondNameAr"
        case thirdNameAr = "ThirdNameAr"
        case lastNameAr = "LastNameAr"
        case firstNameEn = "FirstNameEn"
        case secondNameEn = "SecondNameEn"
        case thirdNameEn = "ThirdNameEn"
        case lastNameEn = "LastNameEn"
        case countryID = "CountryId"
        case countryNameAr = "CountryNameAr"
        case countryNameEn = "CountryNameEn"
        case mobile = "Mobile"
    }
}

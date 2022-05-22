//
//  MGBeneficiriesResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 10/27/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - MGBeneficiriesResponse
class MGBeneficiriesResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: [MGBeneficiaryDatum]?

    init(success: Bool?, code: String?, message: [String]?, data: [MGBeneficiaryDatum]?) {
        self.success = success
        self.code = code
        self.message = message
        self.data = data
    }
}

// MARK: - Datum
class MGBeneficiaryDatum: Codable , Equatable {
    static func == (lhs: MGBeneficiaryDatum, rhs: MGBeneficiaryDatum) -> Bool {
        if lhs.firstNameEn == rhs.firstNameEn
           && lhs.lastNameEn == rhs.lastNameEn
            && lhs.mobile == rhs.mobile
            && lhs.firstNameAr == rhs.firstNameAr
            && lhs.secondNameAr == rhs.secondNameAr
            && lhs.thirdNameAr == rhs.thirdNameAr
            && lhs.lastNameAr == rhs.lastNameAr
            && lhs.countryID == rhs.countryID
            && lhs.countryNameAr == rhs.countryNameAr
            && lhs.countryNameEn == rhs.countryNameEn
        {
            return true
        } else {
            return false
        }
    }
    
    let beneficiaryID, firstNameAr, secondNameAr, thirdNameAr: String?
    let lastNameAr, firstNameEn, secondNameEn, thirdNameEn: String?
    let lastNameEn, countryID, countryNameAr, countryNameEn: String?
    let mobile: String?
    var isChecked : Bool?

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

    init(beneficiaryID: String?, firstNameAr: String?, secondNameAr: String?, thirdNameAr: String?, lastNameAr: String?, firstNameEn: String?, secondNameEn: String?, thirdNameEn: String?, lastNameEn: String?, countryID: String?, countryNameAr: String?, countryNameEn: String?, mobile: String?) {
        self.beneficiaryID = beneficiaryID
        self.firstNameAr = firstNameAr
        self.secondNameAr = secondNameAr
        self.thirdNameAr = thirdNameAr
        self.lastNameAr = lastNameAr
        self.firstNameEn = firstNameEn
        self.secondNameEn = secondNameEn
        self.thirdNameEn = thirdNameEn
        self.lastNameEn = lastNameEn
        self.countryID = countryID
        self.countryNameAr = countryNameAr
        self.countryNameEn = countryNameEn
        self.mobile = mobile
    }
}

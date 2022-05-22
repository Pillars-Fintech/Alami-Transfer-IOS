//
//  BeneficiariesResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 9/13/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - BeneficiariesResponse
class BeneficiariesResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: [BeneficiaryDatum]?

    init(success: Bool?, code: String?, message: [String]?, data: [BeneficiaryDatum]?) {
        self.success = success
        self.code = code
        self.message = message
        self.data = data
    }
}

// MARK: - Datum
class BeneficiaryDatum: Codable {
    let firstNameAr, secondNameAr, thirdNameAr, lastNameAr: String?
    let firstNameEn, secondNameEn, thirdNameEn, lastNameEn: String?
    let mobile: String?
    
    var isChecked: Bool?

    enum CodingKeys: String, CodingKey {
        case firstNameAr = "FirstNameAr"
        case secondNameAr = "SecondNameAr"
        case thirdNameAr = "ThirdNameAr"
        case lastNameAr = "LastNameAr"
        case firstNameEn = "FirstNameEn"
        case secondNameEn = "SecondNameEn"
        case thirdNameEn = "ThirdNameEn"
        case lastNameEn = "LastNameEn"
        case mobile = "Mobile"
    }

    init(firstNameAr: String?, secondNameAr: String?, thirdNameAr: String?, lastNameAr: String?, firstNameEn: String?, secondNameEn: String?, thirdNameEn: String?, lastNameEn: String?, mobile: String?) {
        self.firstNameAr = firstNameAr
        self.secondNameAr = secondNameAr
        self.thirdNameAr = thirdNameAr
        self.lastNameAr = lastNameAr
        self.firstNameEn = firstNameEn
        self.secondNameEn = secondNameEn
        self.thirdNameEn = thirdNameEn
        self.lastNameEn = lastNameEn
        self.mobile = mobile
    }
}

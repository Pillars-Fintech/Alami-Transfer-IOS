//
//  AcountInfoResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 9/9/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - AcountInfoResponse
struct AcountInfoResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: AcountInfoClass?
}

// MARK: - DataClass
struct AcountInfoClass: Codable {
    let id, requestID: String?
    let code: Int?
    let isApproved: Bool?
    let approvedDate, approvedBy, username, password: String?
    let firstNameAr, secondNameAr, thirdNameAr, lastNameAr: String?
    let firstNameEn, secondNameEn, thirdNameEn, lastNameEn: String?
    let emailAddress, city, street, building: String?
    let address, nationalNumber, identityNumber, identityIssuePlace: String?
    let identityIssueData, identityExpireDate: String?
    let resident: Bool?
    let placeOfBirth, birthOfDate, countryOfBirthID, countryOfBirthNameAr: String?
    let countryOfBirthNameEn, countryOfBirthMoneyGramCode, phone, mobile: String?
    let profileImage, identityFront, identityBack, countryID: String?
    let countryNameAr, countryNameEn, countryMoneyGramCode, identityTypeID: String?
    let identityTypeNameAr, identityTypeNameEn, identityTypeMoneyGramCode, identityIssueCountryID: String?
    let identityIssueCountryNameAr, identityIssueCountryNameEn, identityIssueCountryMoneyGramCode, nationalityID: String?
    let nationalityNameAr, nationalityNameEn, nationalityMoneyGramCode, occupationID: String?
    let occupationNameAr, occupationNameEn: String?
    let isActive: Bool?
    let isMale, motherName, maritalStatusID, maritalStatusNameAr: String?
    let maritalStatusNameEn, spouseHusbandName, region, zipCode: String?
    let postalCode, otherNationalityID, otherNationalityNameAr, otherNationalityNameEn: String?
    let workPhone, fax, sourceOfFundsID, sourceOfFundsNameAr: String?
    let sourceOfFundsNameEn, otherSourceOfIncome, annualIncomeRangeID, annualIncomeRangeNameAr: String?
    let annualIncomeRangeNameEn, reasonOfRegistrationID, reasonOfRegistrationNameAr, reasonOfRegistrationNameEn: String?
    let createDate, identityFrontImage, identityBackImage, youImage: String?
    let requestDate, approvalStatemant, keepMeOnUpdate, video: String?
    let isBlock, isActiveMobile, isActiveEmail, isExist: Bool?
    let usageAggreementIsAgreed: Bool?
    //flags
    let CountryOfBirthFlagURL, CountryFlagURL, IdentityIssueCountryFlagUrl, NationalityFlagURL : String?

    enum CodingKeys: String, CodingKey {
        case CountryOfBirthFlagURL = "CountryOfBirthFlagURL"
        case CountryFlagURL = "CountryFlagURL"
        case IdentityIssueCountryFlagUrl = "IdentityIssueCountryFlagUrl"
        case NationalityFlagURL = "NationalityFlagURL"
        
        case id = "Id"
        case requestID = "RequestId"
        case code = "Code"
        case isApproved = "IsApproved"
        case approvedDate = "ApprovedDate"
        case approvedBy = "ApprovedBy"
        case username = "Username"
        case password = "Password"
        case firstNameAr = "FirstNameAr"
        case secondNameAr = "SecondNameAr"
        case thirdNameAr = "ThirdNameAr"
        case lastNameAr = "LastNameAr"
        case firstNameEn = "FirstNameEn"
        case secondNameEn = "SecondNameEn"
        case thirdNameEn = "ThirdNameEn"
        case lastNameEn = "LastNameEn"
        case emailAddress = "EmailAddress"
        case city = "City"
        case street = "Street"
        case building = "Building"
        case address = "Address"
        case nationalNumber = "NationalNumber"
        case identityNumber = "IdentityNumber"
        case identityIssuePlace = "IdentityIssuePlace"
        case identityIssueData = "IdentityIssueData"
        case identityExpireDate = "IdentityExpireDate"
        case resident = "Resident"
        case placeOfBirth = "PlaceOfBirth"
        case birthOfDate = "BirthOfDate"
        case countryOfBirthID = "CountryOfBirthId"
        case countryOfBirthNameAr = "CountryOfBirthNameAr"
        case countryOfBirthNameEn = "CountryOfBirthNameEn"
        case countryOfBirthMoneyGramCode = "CountryOfBirthMoneyGramCode"
        case phone = "Phone"
        case mobile = "Mobile"
        case profileImage = "ProfileImage"
        case identityFront = "IdentityFront"
        case identityBack = "IdentityBack"
        case countryID = "CountryId"
        case countryNameAr = "CountryNameAr"
        case countryNameEn = "CountryNameEn"
        case countryMoneyGramCode = "CountryMoneyGramCode"
        case identityTypeID = "IdentityTypeId"
        case identityTypeNameAr = "IdentityTypeNameAr"
        case identityTypeNameEn = "IdentityTypeNameEn"
        case identityTypeMoneyGramCode = "IdentityTypeMoneyGramCode"
        case identityIssueCountryID = "IdentityIssueCountryId"
        case identityIssueCountryNameAr = "IdentityIssueCountryNameAr"
        case identityIssueCountryNameEn = "IdentityIssueCountryNameEn"
        case identityIssueCountryMoneyGramCode = "IdentityIssueCountryMoneyGramCode"
        case nationalityID = "NationalityId"
        case nationalityNameAr = "NationalityNameAr"
        case nationalityNameEn = "NationalityNameEn"
        case nationalityMoneyGramCode = "NationalityMoneyGramCode"
        case occupationID = "OccupationId"
        case occupationNameAr = "OccupationNameAr"
        case occupationNameEn = "OccupationNameEn"
        case isActive = "IsActive"
        case isMale = "IsMale"
        case motherName = "MotherName"
        case maritalStatusID = "MaritalStatusId"
        case maritalStatusNameAr = "MaritalStatusNameAr"
        case maritalStatusNameEn = "MaritalStatusNameEn"
        case spouseHusbandName = "SpouseHusbandName"
        case region = "Region"
        case zipCode = "ZipCode"
        case postalCode = "PostalCode"
        case otherNationalityID = "OtherNationalityId"
        case otherNationalityNameAr = "OtherNationalityNameAr"
        case otherNationalityNameEn = "OtherNationalityNameEn"
        case workPhone = "WorkPhone"
        case fax = "Fax"
        case sourceOfFundsID = "SourceOfFundsId"
        case sourceOfFundsNameAr = "SourceOfFundsNameAr"
        case sourceOfFundsNameEn = "SourceOfFundsNameEn"
        case otherSourceOfIncome = "OtherSourceOfIncome"
        case annualIncomeRangeID = "AnnualIncomeRangeId"
        case annualIncomeRangeNameAr = "AnnualIncomeRangeNameAr"
        case annualIncomeRangeNameEn = "AnnualIncomeRangeNameEn"
        case reasonOfRegistrationID = "ReasonOfRegistrationId"
        case reasonOfRegistrationNameAr = "ReasonOfRegistrationNameAr"
        case reasonOfRegistrationNameEn = "ReasonOfRegistrationNameEn"
        case createDate = "CreateDate"
        case identityFrontImage = "IdentityFrontImage"
        case identityBackImage = "IdentityBackImage"
        case youImage = "YouImage"
        case requestDate = "RequestDate"
        case approvalStatemant = "ApprovalStatemant"
        case keepMeOnUpdate = "KeepMeOnUpdate"
        case video = "Video"
        case isBlock = "IsBlock"
        case isActiveMobile = "IsActiveMobile"
        case isActiveEmail = "IsActiveEmail"
        case isExist = "IsExist"
        case usageAggreementIsAgreed = "UsageAggreementIsAgreed"
    }
}

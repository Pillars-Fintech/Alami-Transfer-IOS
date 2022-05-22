//
//  ConfigResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 9/6/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - ConfigResponse
struct ConfigResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: ConfigClass?
}

// MARK: - DataClass
struct ConfigClass: Codable {
    let updateStatus: UpdateStatus?
    let company: Company?
    let configString: ConfigString?
    let introStrings: [IntroString]?
    let moneyGramSettings: MoneyGramSettings?
    let remittancesSettings: RemittancesSettings?
    let registrationSettings: RegistrationSettings?
    
    enum CodingKeys: String, CodingKey {
        case updateStatus = "UpdateStatus"
        case company = "Company"
        case configString = "ConfigString"
        case introStrings = "IntroStrings"
        case moneyGramSettings = "MoneyGramSettings"
        case remittancesSettings = "RemittancesSettings"
        case registrationSettings = "RegistrationSettings"
    }
}

// MARK: - Company
struct Company: Codable {
    let name: String?
    let logo: String?
    let companyDESCRIPTION: String?
    let facebook, twitter, instagram: String?
    let email: String?
    let website: String?
    let phone, whatsapp: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "NAME"
        case logo = "LOGO"
        case companyDESCRIPTION = "DESCRIPTION"
        case facebook = "FACEBOOK"
        case twitter = "TWITTER"
        case instagram = "INSTAGRAM"
        case email = "Email"
        case website = "WEBSITE"
        case phone = "PHONE"
        case whatsapp = "WHATSAPP"
    }
}

// MARK: - ConfigString
struct ConfigString: Codable {
    let tellAFriend: String?
    let aboutUsURL, helpURL, termsAndConditionsURL: String?
    let email: String?
    let jordanFlag : String?
      let isOneTimePasswordEnabled : Int?
    
    enum CodingKeys: String, CodingKey {
        case tellAFriend = "TELL_A_FRIEND"
        case aboutUsURL = "ABOUT_US_URL"
        case helpURL = "HELP_URL"
        case termsAndConditionsURL = "TERMS_AND_CONDITIONS_URL"
        case email = "Email"
        case jordanFlag = "JordanFlag"
        case isOneTimePasswordEnabled = "OneTimePasswordEnabled"
    }
}

// MARK: - IntroString
struct IntroString: Codable {
    let masterWelcomeSliderID: Int?
    let masterWelcomeSliderTitle, masterWelcomeSliderDescription, masterWelcomeSliderTitleAr, masterWelcomeSliderDescriptionAr: String?
    
    enum CodingKeys: String, CodingKey {
        case masterWelcomeSliderID = "MASTER_WELCOME_SLIDER_ID"
        case masterWelcomeSliderTitle = "MASTER_WELCOME_SLIDER_TITLE"
        case masterWelcomeSliderDescription = "MASTER_WELCOME_SLIDER_DESCRIPTION"
        case masterWelcomeSliderTitleAr = "MASTER_WELCOME_SLIDER_TITLE_AR"
        case masterWelcomeSliderDescriptionAr = "MASTER_WELCOME_SLIDER_DESCRIPTION_AR"
    }
}

// MARK: - MoneyGramSettings
struct MoneyGramSettings: Codable {
    let fraudWarningAr, fraudWarningEn, rewardsAlertAr, rewardsAlertEn: String?
    let rewardButtonTitlteAr, rewardButtonTitlteEn, availableRewardAr, availableRewardEn: String?
    
    enum CodingKeys: String, CodingKey {
        case fraudWarningAr = "FraudWarningAr"
        case fraudWarningEn = "FraudWarningEn"
        case rewardsAlertAr = "RewardsAlertAr"
        case rewardsAlertEn = "RewardsAlertEn"
        case rewardButtonTitlteAr = "RewardButtonTitlteAr"
        case rewardButtonTitlteEn = "RewardButtonTitlteEn"
        case availableRewardAr = "AvailableRewardAr"
        case availableRewardEn = "AvailableRewardEn"
    }
}

// MARK: - RegistrationSettings
struct RegistrationSettings: Codable {
    let declareList: [DeclareList]?
    
    enum CodingKeys: String, CodingKey {
        case declareList = "DeclareList"
    }
}

// MARK: - DeclareList
struct DeclareList: Codable {
    let titleAr, titleEn: String?
    
    enum CodingKeys: String, CodingKey {
        case titleAr = "AlertAr"
        case titleEn = "AlertEn"
    }
}

// MARK: - RemittancesSettings
struct RemittancesSettings: Codable {
    let confirmAlertPionies: [ConfirmAlertPiony]?
    
    enum CodingKeys: String, CodingKey {
        case confirmAlertPionies = "ConfirmAlertPionies"
    }
}

// MARK: - ConfirmAlertPiony
struct ConfirmAlertPiony: Codable {
    let alertAr, alertEn: String?
    
    enum CodingKeys: String, CodingKey {
        case alertAr = "AlertAr"
        case alertEn = "AlertEn"
    }
}

// MARK: - UpdateStatus
struct UpdateStatus: Codable {
    let androidUpdateLst: AndroidUpdateLst?
    let iosUpdateLst: IosUpdateLst?
    
    enum CodingKeys: String, CodingKey {
        case androidUpdateLst = "AndroidUpdateLst"
        case iosUpdateLst = "IosUpdateLst"
    }
}

// MARK: - AndroidUpdateLst
struct AndroidUpdateLst: Codable {
    let masterAndroidUpdateID: Int?
    let masterAndroidUpdateDescription, masterAndroidUpdateURL, masterAndroidUpdateVersion: String?
    let masterAndroidUpdateIsRequired: Bool?
    
    enum CodingKeys: String, CodingKey {
        case masterAndroidUpdateID = "MASTER_ANDROID_UPDATE_ID"
        case masterAndroidUpdateDescription = "MASTER_ANDROID_UPDATE_DESCRIPTION"
        case masterAndroidUpdateURL = "MASTER_ANDROID_UPDATE_URL"
        case masterAndroidUpdateVersion = "MASTER_ANDROID_UPDATE_VERSION"
        case masterAndroidUpdateIsRequired = "MASTER_ANDROID_UPDATE_IS_REQUIRED"
    }
}

// MARK: - IosUpdateLst
struct IosUpdateLst: Codable {
    let masterIosUpdateID: Int?
    let masterIosUpdateDescription, masterIosUpdateURL, masterIosUpdateVersion: String?
    let masterIosUpdateIsRequired: Bool?
    
    enum CodingKeys: String, CodingKey {
        case masterIosUpdateID = "MASTER_IOS_UPDATE_ID"
        case masterIosUpdateDescription = "MASTER_IOS_UPDATE_DESCRIPTION"
        case masterIosUpdateURL = "MASTER_IOS_UPDATE_URL"
        case masterIosUpdateVersion = "MASTER_IOS_UPDATE_VERSION"
        case masterIosUpdateIsRequired = "MASTER_IOS_UPDATE_IS_REQUIRED"
    }
}

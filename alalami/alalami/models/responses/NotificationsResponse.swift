//
//  NotificationsResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 10/28/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - NotificationsResponse
struct NotificationsResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: [NotificationDatum]?
}

// MARK: - Datum
struct NotificationDatum: Codable {
    let id: Int?
    let titleAr, titleEn, descriptionAr, descriptionEn: String?
    let notifactionType: Int?
    let enabledNotifaction, sound, vibration: Bool?
    let registerMobileID: String?
    let sourceId : String?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case titleAr = "TitleAr"
        case titleEn = "TitleEn"
        case descriptionAr = "DescriptionAr"
        case descriptionEn = "DescriptionEn"
        case notifactionType = "NotifactionType"
        case enabledNotifaction = "EnabledNotifaction"
        case sound = "Sound"
        case vibration = "Vibration"
        case registerMobileID = "RegisterMobileId"
        case sourceId = "SourceId"
    }
}

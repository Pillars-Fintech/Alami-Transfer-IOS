//
//  Constants.swift
//  alalami
//
//  Created by Zaid Khaled on 8/31/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation
class Constants {
    
    
    static let SHOULD_DISABLE_BUTTON = false
    //user defaults
    enum DEFAULT_KEYS {
        static let DID_SELECT_LANGUAGE = "DID_SELECT_LANGUAGE"
        static let DID_SEE_INTRO = "DID_SEE_INTRO"
        static let DID_SEE_STARTED = "DID_SEE_STARTED"
        static let NOTIFICATION_COUNT = "NOTIFICATION_COUNT"
        static let IS_NOTIFICATION_ACTIVE = "IS_NOTIFICATION_ACTIVE"
        static let IS_TOUCHID_ACTIVE = "IS_TOUCHID_ACTIVE"
    }
    
    static let DEFAULT_COUNTRYCODE_IMAGE = ""
    
    //-----
    
    //fonts
    static let ENGLISH_LIGHT = "Inter-ExtraLight"
    static let ENGLISH_REGULAR = "Inter-Regular"
    static let ENGLISH_MEDIUM = "Inter-Medium"
    static let ENGLISH_SEMIBOLD = "Inter-SemiBold"
    static let ENGLISH_BOLD = "Inter-Bold"
    
    static let ARABIC_LIGHT = "Tajawal-Regular"
    static let ARABIC_REGULAR = "Tajawal-Regular"
    static let ARABIC_MEDIUM = "Tajawal-Bold"
    static let ARABIC_SEMIBOLD = "Tajawal-Bold"
    static let ARABIC_BOLD = "Tajawal-Bold"
    
    //---------
    
    static let PAYMENT_URL = "http://alalami.payment.com"
    
    static let APP_ID = "1543530376"
    
    static let DEFAULT_COUNTRY = "JO"
    
    static let GOOGLE_API_KEY = "AIzaSyCaM00qE2kwyGoDm7eQOopPacDwMJFrsdw"
    
    static let LAST_LATITUDE = "LAST_LATITUDE"
    static let LAST_LONGITUDE = "LAST_LONGITUDE"
    
    static let CONTENT_HEADER_KEY = "Content-Type"
    static let CONTENT_HEADER_VALUE = "application/x-www-form-urlencoded"
    
    static var DATE_LOCALE = "en_US"
    
    static let DEVICE_PLATFORM = "ios"
    
    static let LANG_HEADER = "Accept-Language"
    static let AUTH_HEADER = "Authorization"
    
    //api links
    
    
    //local link
//    static let BASE_URL = "http://192.168.20.13:9091/api/"
    
    
    
    //global
//    static let BASE_URL = "http://79.173.251.189:9091/api/"
    
//    static let BASE_URL = "https://149.200.136.46:4433/"
    
    static let BASE_URL = "https://mobile.alalamifs.com:4433/api/"

    
//     static let BASE_URL = "https://testmobile.alalamifs.com/api/"
    
    
    
    // "https://mobile1.alalamifs.com/api/"
    
    
    static let IMAGE_URL = ""
    static let DUMMY_IMAGE_URL = ""
    
    //------
    
    //------- add on azure
    //test
    // wow
    
    
    static let PASSWORD_MIN_LENGTH = 8
    static let PASSWORD_REGEX = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
    static let ID_NUMBER_REGEX = "[A-Za-z][A-Za-z][A-Za-z][0-9][0-9][0-9][0-9][0-9]"
    // static let PERSON_NAME_REGEX = "(?<! )[-a-zA-Z0-9\\u0600-\\u06FF ]*"
    static let PERSON_NAME_REGEX = "[a-zA-Z0-9\\u0600-\\u06FF ]*"
    static let TEXT_NUMBER_REGEX  = ".*[^A-Za-z0-9].*"
    
    //enums
    
    enum ONBOARDING_TEXT_SIZE {
        static let NORMAL_TITLE = 35.0
        static let NORMAL_BODY = 20.0
        static let SMALL_TITLE = 26.0
        static let SMALL_BODY = 16.0
    }
    
    enum STORYBOARDS {
        static let authentication = "Authentication"
        static let main = "Main"
        static let money_gram = "MoneyGram"
        static let afs = "AFS"
        static let daman = "Daman"
        static let receive_money = "ReceiveMoney"
        static let transactions = "Transactions"
        static let more = "More"
        static let profile = "Profile"
        static let moneyGramTest = "MoneyGramViewController"
    }
    
    enum REMITTANCE_SETTINGS {
        static let send_remittance = 1
        static let receive_remittance = 2
    }
    
    static let NOTIFICATION_COUNT = "NOTIFICATION_COUNT"
    static let NOT_KEY_TITLE_EN = "TitleEn"
    static let NOT_KEY_TITLE_AR = "TitleAr"
    static let NOT_KEY_BODY_EN = "MessageEn"
    static let NOT_KEY_BODY_AR = "MessageAr"
    static let NOT_KEY_TYPE = "Type"
    static let NOT_KEY_VALUE = "NotificationData"
    
    enum DYNAMIC_FIELDS {
        static let dropdown = "enum"
        static let countrycode = "cntrycode"
        static let string = "string"
        static let decimal = "decimal"
        static let datetime = "date"
        static let boolean = "boolean"
        //for static cells
        static let first_name = "firstname"
        static let second_name = "secondname"
        static let third_name = "thirdname"
        static let last_name = "lastname"
    }
    
    enum lOOKUPS {
        static let ar = "ar"
        static let en = "en"
    }
    
    enum SERVICE_PROVIDERS {
        static let ria = "03"
        static let money_gram = "02"
        static let afs = "01"
    }
    
    enum DATE_FORMATS {
        static let dd_mm_yyyy_hh_mm_a = "dd/MM/yyyy hh:mm a"
        static let dd_mm_yyyy = "dd/MM/yyyy"
        static let hh_mm_a = "hh:mm a"
        static let hh_mm = "HH:mm"
        static let dd_MMM = "dd-MMM"
        static let EEEE_MMM_d_yyyy = "EEEE, MMM d, yyyy"
        static let api_date = "yyyy-MM-dd'T'HH:mm:ss"
    }
    
    enum RESPONSE_CODES {
        //        static let success = "0"
        //        static let valid = "200"
        static let needs_verification = "201"
    }
    
    enum FONT_TYPE {
        static let light = 1
        static let regular = 2
        static let medium = 3
        static let semibold = 4
        static let bold = 5
    }
    
    enum TRANSACTION_STATUS {
        static let processing = 1
        static let approved = 2
        static let rejected = 3
        static let cancelled = 4
        static let pending = 5
        static let ready = 6
        static let received = 7
    }
    
    enum NOTIFICATION_TYPES {
        static let send = 1
        static let receive = 2
        static let profile = 3
        static let general = 4
    }
    
    //-----
    
    
    static func getFilterTransactionStatuses() -> [StatusFilterItem] {
        var items = [StatusFilterItem]()
        
        var item = StatusFilterItem()
        item.value = Constants.TRANSACTION_STATUS.processing
        item.title = "filter_processing".localized
        items.append(item)
        
        item = StatusFilterItem()
        item.value = Constants.TRANSACTION_STATUS.approved
        item.title = "filter_approved".localized
        items.append(item)
        
        item = StatusFilterItem()
        item.value = Constants.TRANSACTION_STATUS.rejected
        item.title = "filter_rejected".localized
        items.append(item)
        
        item = StatusFilterItem()
        item.value = Constants.TRANSACTION_STATUS.cancelled
        item.title = "filter_cancelled".localized
        items.append(item)
        
        item = StatusFilterItem()
        item.value = Constants.TRANSACTION_STATUS.pending
        item.title = "filter_pending".localized
        items.append(item)
        
        item = StatusFilterItem()
        item.value = Constants.TRANSACTION_STATUS.ready
        item.title = "filter_ready".localized
        items.append(item)
        
        item = StatusFilterItem()
        item.value = Constants.TRANSACTION_STATUS.received
        item.title = "filter_received".localized
        items.append(item)
        
        return items
        
    }
    
}

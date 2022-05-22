//
//  DynamicFieldsResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 9/8/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - DynamicFieldsResponse
class DynamicFieldsResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: DynamicFieldClass?

    init(success: Bool?, code: String?, message: [String]?, data: DynamicFieldClass?) {
        self.success = success
        self.code = code
        self.message = message
        self.data = data
    }
}

class DynamicFieldClass : Codable {
    let firstName, secondName, thirdName, lastName : String?
    let fields: [DynamicFieldDatum]?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "FirstNameEn"
        case secondName = "SecondNameEn"
        case thirdName = "ThirdNameEn"
        case lastName = "LastNameEn"
        case fields = "DynamicControls"
    }
    
    

    init(firstName : String?, secondName : String?, thirdName : String?, lastName : String? ,fields: [DynamicFieldDatum]?) {
        self.firstName = firstName
        self.secondName = secondName
        self.thirdName = thirdName
        self.lastName = lastName
        self.fields = fields
    }
}

// MARK: - Datum
class DynamicFieldDatum: Codable {
    let fieldsForProductEnumDetails: [FieldsForProductEnumDetail]?
    let xmlTag, visibility, label, displayOrder: String?
    let category: String?
    let datumDynamic: Bool?
    let max, min, dataType: String?
    let enumerated: Bool?
    let defaultValue, validationRegEx, arrayName, arrayLength: String?
    var isMand: Bool?
    
    //value filled after receiver info is continued
    var value : String?

    enum CodingKeys: String, CodingKey {
        case fieldsForProductEnumDetails = "FieldsForProductEnumDetails"
        case xmlTag = "XmlTag"
        case visibility = "Visibility"
        case label = "Label"
        case displayOrder = "DisplayOrder"
        case category = "Category"
        case datumDynamic = "Dynamic"
        case max = "Max"
        case min = "Min"
        case dataType = "DataType"
        case enumerated = "Enumerated"
        case defaultValue = "DefaultValue"
        case validationRegEx = "ValidationRegEx"
        case arrayName = "ArrayName"
        case arrayLength = "ArrayLength"
        case isMand = "IsMand"
    }

    init(fieldsForProductEnumDetails: [FieldsForProductEnumDetail]?, xmlTag: String?, visibility: String?, label: String?, displayOrder: String?, category: String?, datumDynamic: Bool?, max: String?, min: String?, dataType: String?, enumerated: Bool?, defaultValue: String?, validationRegEx: String?, arrayName: String?, arrayLength: String?, isMand : Bool?) {
        self.fieldsForProductEnumDetails = fieldsForProductEnumDetails
        self.xmlTag = xmlTag
        self.visibility = visibility
        self.label = label
        self.displayOrder = displayOrder
        self.category = category
        self.datumDynamic = datumDynamic
        self.max = max
        self.min = min
        self.dataType = dataType
        self.enumerated = enumerated
        self.defaultValue = defaultValue
        self.validationRegEx = validationRegEx
        self.arrayName = arrayName
        self.arrayLength = arrayLength
        self.isMand = isMand
    }
}

// MARK: - FieldsForProductEnumDetail
class FieldsForProductEnumDetail: Codable {
    let value, label: String?

    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case label = "Label"
    }

    init(value: String?, label: String?) {
        self.value = value
        self.label = label
    }
}

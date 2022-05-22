//
//  RegisterModel.swift
//  alalami
//
//  Created by Zaid Khaled on 9/1/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation
import UIKit

class RegisterModel : NSObject {
    //step1
    var firstName: String?
    var middleName: String?
    var thirdName: String?
    var familyName: String?
    var countryOfBirth: CountryDatum?
    var dateOfBirth: String?
    var nationality: CountryDatum?
    var occupation : OccupationDatum?
    
    //step2
    var idType : IdTypeDatum?
    var idIssueCountry : CountryDatum?
    var idNumber: String?
    var idIssueDate: String?
    var idExpiryDate: String?
    var residence: Bool = true
    var frontIdImage: UIImage?
    var backIdImage: UIImage?
    var yourCountry: CountryDatum?
    var city: String?
    var street: String?
    var building: String?
    var address: String?
    var nationalNumber: String?
    
    //step3
    var selectedCountryCode: String?
    var mobileNumber: String?
    var phone: String?
    var email: String?
    var faceImage: UIImage?
    var videoUrl : URL?
    var reason: ReasonOfRegDatum?
    var password : String?

}

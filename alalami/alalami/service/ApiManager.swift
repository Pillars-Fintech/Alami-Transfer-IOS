//
//  ApiManager.swift
//  alalami
//
//  Created by Zaid Khaled on 8/31/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation
import Alamofire
import MOLH
import KeychainAccess
import SwiftyJSON

class ApiManager {
    
    func getLang() -> String {
        if (MOLHLanguage.currentAppleLanguage() == "ar") {
            return Constants.lOOKUPS.ar
        }else {
            return Constants.lOOKUPS.en
        }
    }
    
    func getMacAddress() -> String {
        return "10:0560:8946:19"
    }
    
    func getDefaultHeaders() -> [String : String] {
        return ["Content-Type" : "application/x-www-form-urlencoded","Languages" : self.getLang(),"FelUsername" : "admin", "FelPassword" : "P@ssw0rd", "MobileMacAddress" : self.getMacAddress()]
    }
    
    func getJSONDefaultHeaders() -> [String : String] {
        return ["Content-Type" : "application/json; charset=utf-8","Languages" : self.getLang(),"FelUsername" : "admin", "FelPassword" : "P@ssw0rd", "MobileMacAddress" : self.getMacAddress()]
    }
    
    
    func getAccountInfo(token : String ,completion:@escaping(_ response : AcountInfoResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        let url = "\(Constants.BASE_URL)custCustomers/GetAccountLoginInfo"
        
        AFManager.request(url, method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(AcountInfoResponse(success: false, code: "401", message: [String](), data: nil))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(AcountInfoResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                    
                        
                        let decoder = JSONDecoder()
                        let baseResponse = try decoder.decode(AcountInfoResponse.self, from: json)
                        
                        print("value:\(response.value)")
                        if baseResponse.success == false{
                            completion(AcountInfoResponse(success: false, code: baseResponse.code ?? "401", message: baseResponse.message ?? ["Something Wrong"], data: nil))
                        }else{
                                completion(baseResponse)

                        }
                        
                        
                    }catch let err{
                        print(err)
                        completion(AcountInfoResponse(success: false, code: "100", message: [String](), data: nil))
                    }
                }
            }
    }
    
    
    func getConfig(completion:@escaping(_ response : ConfigResponse)-> Void) {
        
        AFManager.request("\(Constants.BASE_URL)cmnAppConfiguration", method: .get, parameters: nil ,encoding: URLEncoding(), headers: self.getDefaultHeaders())
            .responseJSON { response in
                if let json = response.data {
                    do {
                        let decoder = JSONDecoder()
                        let baseResponse = try decoder.decode(ConfigResponse.self, from: json)
                        completion(baseResponse)
                    }catch let err{
                        print(err)
                        completion(ConfigResponse(success: false, code: "100", message: [String](), data: nil))
                    }
                }
            }
    }
    
    func getRemittanceSettings(token : String,completion:@escaping(_ response : RemittanceSettingsResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        AFManager.request("\(Constants.BASE_URL)remRemittanceSettings", method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
                        let decoder = JSONDecoder()
                        let baseResponse = try decoder.decode(RemittanceSettingsResponse.self, from: json)
                        completion(baseResponse)
                    }catch let err{
                        print(err)
                        completion(RemittanceSettingsResponse(success: false, code: "100", message: [String](), data: nil))
                    }
                }
            }
    }
    
    func getRemittanceById(token : String, remId : String ,completion:@escaping(_ response : RemittanceDynamicDetailsResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        AFManager.request("\(Constants.BASE_URL)Remittance/GetByRemittanceIdWithOptions?Id=\(remId)", method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
                        let decoder = JSONDecoder()
                        let baseResponse = try decoder.decode(RemittanceDynamicDetailsResponse.self, from: json)
                        completion(baseResponse)
                    }catch let err{
                        print(err)
                        completion(RemittanceDynamicDetailsResponse(success: false, code: "100", message: [String](), data: nil))
                    }
                }
            }
    }
    
    
    //for reg
    func getCountries(completion:@escaping(_ response : CountriesResponse)-> Void) {
                AFManager.request("\(Constants.BASE_URL)cmnCountries", method: .get, parameters: nil ,encoding: URLEncoding(), headers: self.getDefaultHeaders())
            .responseJSON { response in
                if let json = response.data {
                    do {
               
                            print("Response \(response.value)")

                        
                        
                            let decoder = JSONDecoder()
                            let baseResponse = try decoder.decode(CountriesResponse.self, from: json)
                            completion(baseResponse)
                        
                        
                    }catch let err{
                        print(err)
                        completion(CountriesResponse(success: false, code: "100", message: [String](), data: [CountryDatum]()))

                    }
                }
            }
    }
    
//step 5
    func getMGCountries(token : String, completion:@escaping(_ response : MGCountriesResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        AFManager.request("\(Constants.BASE_URL)MG/Common/GetCountries", method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
                        

                        let statusCode = response.response?.statusCode
                        if (statusCode == 401) {

                            completion(MGCountriesResponse(success: false, code: "401", message: [String](), data: [MGCountryDatum]()))
                        }else {

                            let decoder = JSONDecoder()
                            let baseResponse = try decoder.decode(MGCountriesResponse.self, from: json)
                            completion(baseResponse)
                        }
                    }catch let err{
                        print(err)
                        completion(MGCountriesResponse(success: false, code: "100", message: [String](), data: [MGCountryDatum]()))
                    }
                }
            }
    }
    
    
    func getMGSendCountries(token : String, completion:@escaping(_ response : MGCountriesResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        AFManager.request("\(Constants.BASE_URL)MG/Send/GetCountries", method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
                        
                        print("DAta:\(response.value)")

                    let decoders = JSONDecoder()
                    let baseResponses = try decoders.decode(MGCountriesResponse.self, from: json)
                    completion(baseResponses)
                     
                    }catch let err{
                        print(err)
                        completion(MGCountriesResponse(success: false, code: "100", message: [String](), data: [MGCountryDatum]()))
                    }
                }
            }
    }
    
    func saveMGReward(token : String, address : String, city : String, country : String, dob : String, firstName : String, lastName : String, phone : String, smsOn : Bool, optOn : Bool,completion:@escaping(_ response : SaveRewardResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        var smsOnStr = "false"
        if (smsOn) {
            smsOnStr = "true"
        }
        
        var optOnStr = "false"
        if (optOn) {
            optOnStr = "true"
        }
        
        let all : [String : Any] = ["ConsumerAddress" : address,
                                    "ConsumerCity" : city,
                                    "ConsumerCountry" : country,
                                    "ConsumerDOB" : dob.replacedArabicDigitsWithEnglish,
                                    "ConsumerFirstName" : firstName,
                                    "ConsumerHomePhone" : phone,
                                    "ConsumerLastName" : lastName,
                                    "MarketingBySMS" : smsOnStr,
                                    "MarketingOptIn": optOnStr]
        
        AFManager.request("\(Constants.BASE_URL)MG/Reward/SaveReward", method: .post, parameters: all ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
                        let statusCode = response.response?.statusCode
                        if (statusCode == 401) {
                            completion(SaveRewardResponse(success: false, code: "401", message: [String](), data: ""))
                        }else {
                            let decoder = JSONDecoder()
                            let baseResponse = try decoder.decode(SaveRewardResponse.self, from: json)
                            completion(baseResponse)
                        }
                    }catch let err{
                        print(err)
                        completion(SaveRewardResponse(success: false, code: "100", message: [String](), data: ""))
                    }
                }
            }
    }
    
    
    //nationalty
    func getCountryCodes(completion:@escaping(_ response : CountryCodesResponse)-> Void) {
        
        AFManager.request("\(Constants.BASE_URL)cmnAvailableCountries", method: .get, parameters: nil ,encoding: URLEncoding(), headers: self.getDefaultHeaders())
            .responseJSON { response in
                if let json = response.data {
                    do {
                        let decoder = JSONDecoder()
                        let baseResponse = try decoder.decode(CountryCodesResponse.self, from: json)
                        completion(baseResponse)
                    }catch let err{
                        print(err)
                        completion(CountryCodesResponse(success: false, code: "100", message: [String](), data: [CountryCodeDatum]()))
                    }
                }
            }
    }
    
    
    func getOccupation(completion:@escaping(_ response : OccupationsResponse)-> Void) {
        
        AFManager.request("\(Constants.BASE_URL)cmnOccupations", method: .get, parameters: nil ,encoding: URLEncoding(), headers: self.getDefaultHeaders())
            .responseJSON { response in
                if let json = response.data {
                    do {
                        let decoder = JSONDecoder()
                        let baseResponse = try decoder.decode(OccupationsResponse.self, from: json)
                        completion(baseResponse)
                    }catch let err{
                        print(err)
                        completion(OccupationsResponse(success: false, code: "100", message: [String](), data: [OccupationDatum]()))
                    }
                }
            }
    }
    
    func getIdTypes(completion:@escaping(_ response : IDTypesResponse)-> Void) {
        
        AFManager.request("\(Constants.BASE_URL)cmnIdentityTypes", method: .get, parameters: nil ,encoding: URLEncoding(), headers: self.getDefaultHeaders())
            .responseJSON { response in
                if let json = response.data {
                    do {
                        let decoder = JSONDecoder()
                        let baseResponse = try decoder.decode(IDTypesResponse.self, from: json)
                        completion(baseResponse)
                    }catch let err{
                        print(err)
                        completion(IDTypesResponse(success: false, code: "100", message: [String](), data: [IdTypeDatum]()))
                    }
                }
            }
    }
    
    
    
    func getReasonOfRegistrations(completion:@escaping(_ response : ReasonsOfRegResponse)-> Void) {
        
        AFManager.request("\(Constants.BASE_URL)cmnReasonOfRegistration", method: .get, parameters: nil ,encoding: URLEncoding(), headers: self.getDefaultHeaders())
            .responseJSON { response in
                if let json = response.data {
                    do {
                        let decoder = JSONDecoder()
                        let baseResponse = try decoder.decode(ReasonsOfRegResponse.self, from: json)
                        completion(baseResponse)
                    }catch let err{
                        print(err)
                        completion(ReasonsOfRegResponse(success: false, code: "100", message: [String](), data: [ReasonOfRegDatum]()))
                    }
                }
            }
    }
    
    
    func register(mModel : RegisterModel?,completion:@escaping(_ response : RegisterResponse)-> Void) {
        
        var mobile = mModel?.mobileNumber ?? ""
        if (!mobile.starts(with: "0")) {
            mobile = "0\(mobile)"
        }
        
        var isResidantStr = "false"
        if (mModel?.residence ?? false) {
            isResidantStr = "true"
        }
        
        var all : [String : Any] = ["FirstNameEn": mModel?.firstName ?? "",
                                    "SecondNameEn" : mModel?.middleName ?? "",
                                    "ThirdNameEn" : mModel?.thirdName ?? "",
                                    "LastNameEn" : mModel?.familyName ?? "",
                                    "CountryOfBirthId" : mModel?.countryOfBirth?.id ?? "",
                                    "BirthOfDate" : (mModel?.dateOfBirth ?? "").replacedArabicDigitsWithEnglish,
                                    "NationalityId" : mModel?.nationality?.id ?? "",
                                    "NationalNumber" : (mModel?.nationalNumber ?? "").replacedArabicDigitsWithEnglish,
                                    "IdentityTypeId" : mModel?.idType?.id ?? "",
                                    "IdentityNumber" :  (mModel?.idNumber ?? "").replacedArabicDigitsWithEnglish,
                                    "IdentityExpireDate" : (mModel?.idExpiryDate ?? "").replacedArabicDigitsWithEnglish,
                                    "IdentityIssueData" : (mModel?.idIssueDate ?? "").replacedArabicDigitsWithEnglish,
                                    "IdentityIssueCountryId" : mModel?.idIssueCountry?.id ?? "",
                                    "IdentityFrontImage" : mModel?.frontIdImage?.optimizedIfNeeded()?.toBase64() ?? "",
                                    "IdentityBackImage" : mModel?.backIdImage?.optimizedIfNeeded()?.toBase64() ?? "",
                                    "OccupationId" : mModel?.occupation?.id ?? "",
                                    "CountryId" : mModel?.yourCountry?.id ?? "",
                                    "Address" : mModel?.address ?? "",
                                    "City" : mModel?.city ?? "",
                                    "Street" : mModel?.street ?? "",
                                    "YouImage" : mModel?.faceImage?.optimizedIfNeeded()?.toBase64() ?? "",
                                    "Phone" : (mModel?.phone ?? "").replacedArabicDigitsWithEnglish,
                                    "Building" : mModel?.building ?? "",
                                    "ReasonOfRegistrationId" : mModel?.reason?.reasonOfRegistrationID ?? "",
                                    "Mobile" : mobile.replacedArabicDigitsWithEnglish,
                                    "EmailAddress" : mModel?.email ?? "",
                                    "Username" : (mobile.replacedArabicDigitsWithEnglish).toBase64(),
                                    "Password" : (mModel?.password ?? "").toBase64(),
                                    "Resident" : isResidantStr]
        
        
//
//        var all : [String : Any] = ["FirstNameEn": mModel?.firstName ?? "",
//                                    "SecondNameEn" : mModel?.middleName ?? "",
//                                    "ThirdNameEn" : mModel?.thirdName ?? "",
//                                    "LastNameEn" : mModel?.familyName ?? "",
//                                    "CountryOfBirthId" : mModel?.countryOfBirth?.id ?? "",
//                                    "BirthOfDate" : (mModel?.dateOfBirth ?? "").replacedArabicDigitsWithEnglish,
//                                    "NationalityId" : mModel?.nationality?.id ?? "",
//                                    "NationalNumber" : (mModel?.nationalNumber ?? "").replacedArabicDigitsWithEnglish,
//                                    "IdentityTypeId" : mModel?.idType?.id ?? "",
//                                    "IdentityNumber" :  (mModel?.idNumber ?? "").replacedArabicDigitsWithEnglish,
//                                    "IdentityExpireDate" : (mModel?.idExpiryDate ?? "").replacedArabicDigitsWithEnglish,
//                                    "IdentityIssueData" : (mModel?.idIssueDate ?? "").replacedArabicDigitsWithEnglish,
//                                    "IdentityIssueCountryId" : mModel?.idIssueCountry?.id ?? "",
//                                    "IdentityFrontImage" : mModel?.frontIdImage?.toBase64() ?? "",
//                                    "IdentityBackImage" : mModel?.backIdImage?.toBase64() ?? "",
//                                    "OccupationId" : mModel?.occupation?.id ?? "",
//                                    "CountryId" : mModel?.yourCountry?.id ?? "",
//                                    "Address" : mModel?.address ?? "",
//                                    "City" : mModel?.city ?? "",
//                                    "Street" : mModel?.street ?? "",
//                                    "YouImage" : mModel?.faceImage?.toBase64() ?? "",
//                                    "Phone" : (mModel?.phone ?? "").replacedArabicDigitsWithEnglish,
//                                    "Building" : mModel?.building ?? "",
//                                    "ReasonOfRegistrationId" : mModel?.reason?.reasonOfRegistrationID ?? "",
//                                    "Mobile" : mobile.replacedArabicDigitsWithEnglish,
//                                    "EmailAddress" : mModel?.email ?? "",
//                                    "Username" : (mobile.replacedArabicDigitsWithEnglish).toBase64(),
//                                    "Password" : (mModel?.password ?? "").toBase64(),
//                                    "Resident" : isResidantStr]
        
        if (mModel?.videoUrl != nil) {
            if let videoData = try? Data.init(contentsOf: (mModel?.videoUrl)!) {
               // do {
//                    if #available(iOS 13.0, *) {
//                        let compressedData = try (videoData as NSData).compressed(using: .lzfse)
//                        let videoBase64 = compressedData.base64EncodedString()
//                        all["Video"] = videoBase64
//                        // all["Video"] = "Video"
//                    } else {
//                        let videoBase64 = videoData.base64EncodedString()
//                        all["Video"] = videoBase64
//                        // all["Video"] = "Video"
//                    }
//                } catch {
//                    print(error.localizedDescription)
//                    all["Video"] = "Video"
//                }
                
                let videoBase64 = videoData.base64EncodedString()
                all["Video"] = "videoBase64"
                
            }
        }
        
        AFManager.request("\(Constants.BASE_URL)custCustomers", method: .post, parameters: all ,encoding: URLEncoding(), headers: self.getDefaultHeaders())
            .responseJSON { response in
                if let json = response.data {
                    do {
                        let decoder = JSONDecoder()
                        let baseResponse = try decoder.decode(RegisterResponse.self, from: json)
                        completion(baseResponse)
                    }catch let err{
                        print(err)
                        completion(RegisterResponse(success: false, code: "100", message: [String](), data: nil))
                    }
                }
            }
    }
    
    func login(mobile : String, password : String,completion:@escaping(_ response : RegisterResponse)-> Void) {
        
        var mobile = mobile.replacedArabicDigitsWithEnglish
        if (!mobile.starts(with: "0")) {
            mobile = "0\(mobile)"
        }
        
        let all = ["Username" : mobile.trim().toBase64(),
                   "Password" : password.toBase64()]
        
        AFManager.request("\(Constants.BASE_URL)Login", method: .post, parameters: all ,encoding: URLEncoding(), headers: self.getDefaultHeaders())
            .responseJSON { response in
                if let json = response.data {
                    do {
                        let decoder = JSONDecoder()
                        let baseResponse = try decoder.decode(RegisterResponse.self, from: json)
                        completion(baseResponse)
                        
                    }catch let err {
                        print(err)
                        completion(RegisterResponse(success: false, code: "100", message: [String](), data: nil))
                    }
                }
            }
    }
    
    func requestOneTimePassword(
mobile : String, password : String,completion:@escaping(_ response : OneTimePasswordResponse)-> Void) {
        
        var mobile = mobile.replacedArabicDigitsWithEnglish
        if (!mobile.starts(with: "0")) {
            mobile = "0\(mobile)"
        }
        
        let all = ["Username" : mobile.trim().toBase64(),
                   "Password" : password.toBase64()]
        
        AFManager.request("\(Constants.BASE_URL)CustomerVerificationLogin/GetLoginResult", method: .post, parameters: all ,encoding: URLEncoding(), headers: self.getDefaultHeaders())
            .responseJSON { response in
                if let json = response.data {
                    do {
                        let decoder = JSONDecoder()
                        let baseResponse = try decoder.decode(OneTimePasswordResponse.self, from: json)
                        completion(baseResponse)
                    }catch let err {
                        print(err)
                        completion(OneTimePasswordResponse(success: false, code: "100", message: [String](), data: nil))
                    }
                }
            }
    }
    
    
    func oneTimeAuthorize(customerId : String, pinCode : String,completion:@escaping(_ response : OnTimeAuthorizeResponse)-> Void) {
        
        AFManager.request("\(Constants.BASE_URL)CustomerVerificationLogin/VerfiyLoginVerificationCode?value=\(pinCode)&customerId=\(customerId)", method: .get, parameters: nil ,encoding: URLEncoding(), headers: self.getDefaultHeaders())
            .responseJSON { response in
                if let json = response.data {
                    do {
                        let decoder = JSONDecoder()
                        let baseResponse = try decoder.decode(OnTimeAuthorizeResponse.self, from: json)
                        completion(baseResponse)
                    }catch let err {
                        print(err)
                        completion(OnTimeAuthorizeResponse(success: false, code: "100", message: [String](), data: nil))
                    }
                }
            }
    }
    
    func updateDeviceInfo(token : String, regId : String,completion:@escaping(_ response : RegisterResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        let all = ["DeviceId" : getVenderId(),
                   "DeviceType" : "2",
                   "DeviceOS" : "ios - \(UIDevice.modelName)",
                   "DeviceToken" : regId,
                   "DeviceVersion" : "ios - \(UIDevice.current.systemVersion)"]
        
        AFManager.request("\(Constants.BASE_URL)RegisterMobile", method: .post, parameters: all ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
                        let decoder = JSONDecoder()
                        let baseResponse = try decoder.decode(RegisterResponse.self, from: json)
                        completion(baseResponse)
                    }catch let err{
                        print(err)
                        completion(RegisterResponse(success: false, code: "100", message: [String](), data: nil))
                    }
                }
            }
    }
    
    func sendVerificationCode(token : String,completion:@escaping(_ response : BaseResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        AFManager.request("\(Constants.BASE_URL)VerificationCode", method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(BaseResponse(success: false, code: "401", message: [String]()))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(BaseResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        print("value\(response.value)")

                        let decoder = JSONDecoder()
                        let baseResponse = try decoder.decode(BaseResponse.self, from: json)

                        print("message\(baseResponse.message)")

                        if baseResponse.success == false{
                            completion(BaseResponse(success: false, code:baseResponse.code ?? "401", message: baseResponse.message ?? ["Something Wrong"]))

                        }else{
                            completion(baseResponse)

                        }
                        
                        
                        
                    }catch let err{
                        print(err)
                        completion(BaseResponse(success: false, code: "100", message: [String]()))
                    }
                }
            }
    }
    
    
    func verifyCode(token : String, code : String,completion:@escaping(_ response : BaseResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        let all = ["VerificationCode" : code.replacedArabicDigitsWithEnglish]
        
        AFManager.request("\(Constants.BASE_URL)VerificationCode/Verify", method: .post, parameters: all ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(BaseResponse(success: false, code: "401", message: [String]()))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(BaseResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        
                        let decoder = JSONDecoder()
                         let baseResponse = try decoder.decode(BaseResponse.self, from: json)
                        
                        
                        if baseResponse.success == false{
                            
                            completion(BaseResponse(success: false, code: baseResponse.code ?? "401", message: baseResponse.message ?? ["Something Wrong"]))

                            print("BaseResponse:\(baseResponse.message)")
                        }else{
                            completion(baseResponse)

                        }
                        
                    }catch let err{
                        print(err)
                        completion(BaseResponse(success: false, code: "100", message: [String]()))
                    }
                }
            }
    }
    
    
    func forgotPassword(mobile : String,completion:@escaping(_ response : ForgotPasswordResponse)-> Void) {
        
        let all = ["MobileParam" : mobile]
        
        AFManager.request("\(Constants.BASE_URL)custCustomersForgotPasswordActivationCodes", method: .post, parameters: all ,encoding: URLEncoding(), headers: self.getDefaultHeaders())
            .responseJSON { response in
                if let json = response.data {
                    do {
                        let decoder = JSONDecoder()
                        let baseResponse = try decoder.decode(ForgotPasswordResponse.self, from: json)
                        completion(baseResponse)
                    }catch let err{
                        print(err)
                        completion(ForgotPasswordResponse(success: false, code: "100", message: [String](), data: ""))
                    }
                }
            }
    }
    
    
    func changePassword(id : String, password : String, mobile : String, code : String,completion:@escaping(_ response : BaseResponse)-> Void) {
        
        let all = ["id" : id,
                   "password" : password,
                   "Mobile" : mobile,
                   "code" : code.replacedArabicDigitsWithEnglish]
        
        AFManager.request("\(Constants.BASE_URL)custCustomers/UpdatePassword", method: .post, parameters: all ,encoding: URLEncoding(), headers: self.getDefaultHeaders())
            .responseJSON { response in
                if let json = response.data {
                    do {
                        let decoder = JSONDecoder()
                        let baseResponse = try decoder.decode(BaseResponse.self, from: json)
                        completion(baseResponse)
                    }catch let err{
                        print(err)
                        completion(BaseResponse(success: false, code: "100", message: [String]()))
                    }
                }
            }
    }
    
    //service providers
    func getServiceProviders(token : String,completion:@escaping(_ response : ServicesResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        AFManager.request("\(Constants.BASE_URL)remServicesProviders", method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(ServicesResponse(success: false, code: "401", message: [String](), data: [ServiceDatum]()))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(ServicesResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        

                    let decoder = JSONDecoder()
                    let baseResponsess = try decoder.decode(ServicesResponse.self, from: json)
                        
                        
                        
                        if baseResponsess.success == false{
                            completion(ServicesResponse(success: false, code: baseResponsess.code ?? "401", message: baseResponsess.message ?? ["Something Wrong"], data: [ServiceDatum]()))
                        }else{
                            
                        let decoder = JSONDecoder()
                        let baseResponse = try decoder.decode(ServicesResponse.self, from: json)
                        completion(baseResponse)
                        }
                        
                        
                        
                        

                        
                    }catch let err{
                        print(err)
                        completion(ServicesResponse(success: false, code: "100", message: [String](), data: [ServiceDatum]()))
                    }
                }
            }
    }
    
    //flashcards
    func getFlashCards(token : String,completion:@escaping(_ response : FlashCardsResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        AFManager.request("\(Constants.BASE_URL)cmnFlashCards", method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
                        //SNUFF
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(FlashCardsResponse(success: false, code: "401", message: [String](), data: [FlashCardDatum]()))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(FlashCardsResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        let decoder = JSONDecoder()
                        let baseResponse = try decoder.decode(FlashCardsResponse.self, from: json)
                        
                        
                        if baseResponse.success == false {
          
                            
                            completion(FlashCardsResponse(success: false, code: baseResponse.code ?? "401", message: baseResponse.message ?? ["Something Wrong"], data: [FlashCardDatum]()))

                        }else{
                        
                            completion(baseResponse)

                        }
                        

                        
                    }catch let err{
                        print(err)
                        completion(FlashCardsResponse(success: false, code: "100", message: [String](), data: [FlashCardDatum]()))
                    }
                }
            }
    }
    
    
    //branches
    func getBranches(token : String,completion:@escaping(_ response : BranchesResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        AFManager.request("\(Constants.BASE_URL)cmnBranches", method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(BranchesResponse(success: false, code: "401", message: [String](), data: [BranchDatum]()))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(BranchesResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                let decoder = JSONDecoder()
                let baseResponse = try decoder.decode(BranchesResponse.self, from: json)
                        
                        
                        if baseResponse.success == false{
                            completion(BranchesResponse(success: false, code: baseResponse.code ?? "401", message: baseResponse.message ?? ["Something Wrong"], data: [BranchDatum]()))

                        }else{
                        completion(baseResponse)

                        }
                        
                        
                        

                    }catch let err{
                        print(err)
                        completion(BranchesResponse(success: false, code: "100", message: [String](), data: [BranchDatum]()))
                    }
                }
            }
    }
    
    func getAfsBranches(token : String,completion:@escaping(_ response : BranchesResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        AFManager.request("\(Constants.BASE_URL)AFS/Common/GetBranches", method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(BranchesResponse(success: false, code: "401", message: [String](), data: [BranchDatum]()))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(BranchesResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        let decoder = JSONDecoder()
                        let baseResponse = try decoder.decode(BranchesResponse.self, from: json)
                        
                        
                        
                        if baseResponse.success == false {
                            completion(BranchesResponse(success: false, code: baseResponse.code ?? "401", message: baseResponse.message ?? ["Something Wrong"], data: [BranchDatum]()))
                        }else{
                            completion(baseResponse)

                        }
                        
                    }catch let err{
                        print(err)
                        completion(BranchesResponse(success: false, code: "100", message: [String](), data: [BranchDatum]()))
                    }
                }
            }
    }
    
    func getNotifications(token : String,completion:@escaping(_ response : NotificationsResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        AFManager.request("\(Constants.BASE_URL)SendDataNotification/GetData", method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(NotificationsResponse(success: false, code: "401", message: [String](), data: [NotificationDatum]()))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(NotificationsResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        
                        
                        let decoder = JSONDecoder()
                        let baseResponse = try decoder.decode(NotificationsResponse.self, from: json)
                        
                        if baseResponse.success == false{
                            completion(NotificationsResponse(success: false, code: baseResponse.code ?? "401", message: baseResponse.message ?? ["Somthing Wrong"], data: [NotificationDatum]()))

                            
                        }else{
                           completion(baseResponse)
                        }
                        
                        
                    }catch let err {
                        print(err)
                        completion(NotificationsResponse(success: false, code: "100", message: [String](), data: [NotificationDatum]()))
                    }
                }
            }
    }
    
    func getRejectionReasons(token : String, remittanceId: String,isSend : Bool,isCancel: Bool ,completion:@escaping(_ response : RejectionReasonsResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        AFManager.request("\(Constants.BASE_URL)Remittance/GetReasons?RemittanceId=\(remittanceId)&IsSend=\(isSend)&IsCancel=\(isCancel)", method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(RejectionReasonsResponse(success: false, code: "401", message: [String](), data: [RejectionReasonDatum]()))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(RejectionReasonsResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        

                            let decoder = JSONDecoder()
                            let baseResponse = try decoder.decode(RejectionReasonsResponse.self, from: json)
                        
                        
                        if baseResponse.success == false {
                            completion(RejectionReasonsResponse(success: false, code: baseResponse.code ?? "401", message: baseResponse.message ?? ["Something Wrong"], data: [RejectionReasonDatum]()))

                        }else{
                           completion(baseResponse)

                        }
                        
                        
                        
                        
                        
                        
                        
                    }catch let err{
                        print(err)
                        completion(RejectionReasonsResponse(success: false, code: "100", message: [String](), data: [RejectionReasonDatum]()))
                    }
                }
            }
    }
    
    //pay in methods
    func getPayInMethods(token : String,completion:@escaping(_ response : PayInMethodsResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        AFManager.request("\(Constants.BASE_URL)remPayMethods", method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(PayInMethodsResponse(success: false, code: "401", message: [String](), data: [PayInMethodDatum]()))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(PayInMethodsResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        
                 

                    let decoder = JSONDecoder()
                    let baseResponse = try decoder.decode(PayInMethodsResponse.self, from: json)
                        
                        if baseResponse.success == false{
                            
                            completion(PayInMethodsResponse(success: false, code: baseResponse.code ?? "401", message: baseResponse.message ?? ["Something Wrong"], data: [PayInMethodDatum]()))

                            
                        }else{
                                completion(baseResponse)
                        }
                        
                        
                        
                        
                        
                    }catch let err{
                        print(err)
                        completion(PayInMethodsResponse(success: false, code: "100", message: [String](), data: [PayInMethodDatum]()))
                    }
                }
            }
    }
    
    
    //pay out methods
    func getPayOutMethods(token : String,completion:@escaping(_ response : PayOutMethodsResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        AFManager.request("\(Constants.BASE_URL)remPayoutMethods", method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
                        
                        
//                        if (statusCode == 401) {
//                            completion(PayOutMethodsResponse(success: false, code: "401", message: [String](), data: [PayOutMethodDatum]()))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(PayOutMethodsResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        
                        print("response.value\(response.value)")
                        
                let decoder = JSONDecoder()
                let baseResponse = try decoder.decode(PayOutMethodsResponse.self, from: json)
                    
                        if baseResponse.success == false {
                            completion(PayOutMethodsResponse(success: false, code: baseResponse.code ?? "401", message:baseResponse.message ?? ["Something Wrong"], data: [PayOutMethodDatum]()))

                            
                        }else{
                      completion(baseResponse)
                        }
                        
                completion(baseResponse)

                    }catch let err{
                        print(err)
                        completion(PayOutMethodsResponse(success: false, code: "100", message: [String](), data: [PayOutMethodDatum]()))
                    }
                }
            }
    }
    
    //service options
    func getMoneyGramServiceOptions(token : String, sendModel : SendMoneyMGModel?,AmountIncludingFee : Double, ReceiveCountry: String, payOptionId: Int,  promocode : String, isSend : Bool,completion:@escaping(_ response : MoneyGramServiceOptionsResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        var isSendStr = "false"
        
        if (isSend) {
            isSendStr = "true"
        }
        
        var url = "\(Constants.BASE_URL)MG/Send/GetServiceOption?Amount=\(AmountIncludingFee)&ReceiveCountry=\(ReceiveCountry)&PayMethodId=\(payOptionId)&HasIncludingFee=true&IsSendAmount=\(isSendStr)"
        
        if (App.shared.sendMoneyMG?.feeType ?? 1 == 1) { //exclude
            url = "\(Constants.BASE_URL)MG/Send/GetServiceOption?Amount=\(AmountIncludingFee)&ReceiveCountry=\(ReceiveCountry)&PayMethodId=\(payOptionId)&HasIncludingFee=false&IsSendAmount=\(isSendStr)"
        }
        
        //wallet
        if (sendModel?.walletProvider?.walletsProvidersID?.count ?? 0 > 0) {
            url = "\(url)&WalletProviderId=\(sendModel?.walletProvider?.walletsProvidersID ?? "")&WalletNumber=\(sendModel?.walletNumber ?? "")"
        }
        
        //DTD
        if (sendModel?.senderRegion?.count ?? 0 > 0) {
            url = "\(url)&DTDRegion=\(sendModel?.senderRegion ?? "")"
        }
        if (sendModel?.senderCity?.count ?? 0 > 0) {
            url = "\(url)&DTDCity=\(sendModel?.senderCity ?? "")"
        }
        if (sendModel?.senderStreet?.count ?? 0 > 0) {
            url = "\(url)&DTDStreet=\(sendModel?.senderStreet ?? "")"
        }
        if (sendModel?.senderBuildingNumber?.count ?? 0 > 0) {
            url = "\(url)&DTDBuilding=\(sendModel?.senderBuildingNumber ?? "")"
        }
        if (sendModel?.senderAddress?.count ?? 0 > 0) {
            url = "\(url)&DTDAddress=\(sendModel?.senderAddress ?? "")"
        }
        
        if (promocode.count > 0) {
            url = "\(url)&PromoCodeValues=\(promocode.replacedArabicDigitsWithEnglish)"
        }
        
        AFManager.request(url, method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(MoneyGramServiceOptionsResponse(success: false, code: "401", message: [String](), data: [MoneyGramServiceOptionsDatum]()))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(MoneyGramServiceOptionsResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        
                        print("data: \(response.value)")
                        
                        
                let decoders = JSONDecoder()
                let baseResponses = try decoders.decode(MoneyGramServiceOptionsResponse.self, from: json)
                        
                        if baseResponses.success == false{
                            completion(MoneyGramServiceOptionsResponse(success: false, code: "\(baseResponses.code ?? "401")", message: baseResponses.message ?? ["Try Agin"], data: [MoneyGramServiceOptionsDatum]()))
                        }else{
//                                                        let decoder = JSONDecoder()
//                                                        let baseResponse = try decoder.decode(MoneyGramServiceOptionsResponse.self, from: json)
                                                        completion(baseResponses)
                            
                        }
                        
                        
                        
                    }catch let err{
                        print(err)
                        completion(MoneyGramServiceOptionsResponse(success: false, code: "100", message: [String](), data: [MoneyGramServiceOptionsDatum]()))
                    }
                }
            }
    }
    
    //reason of transfer
    func getReasonsOfTransfer(token : String,completion:@escaping(_ response : ReasonsOfTransferResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        AFManager.request("\(Constants.BASE_URL)cmnReasonOfTransfer", method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(ReasonsOfTransferResponse(success: false, code: "401", message: [String](), data: [ReasonOfTransferDatum]()))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(ReasonsOfTransferResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        
                        let decoder = JSONDecoder()
                        let baseResponse = try decoder.decode(ReasonsOfTransferResponse.self, from: json)
                        
                        if baseResponse.success == false {
                            completion(ReasonsOfTransferResponse(success: false, code: baseResponse.code ?? "401", message: baseResponse.message ?? ["Something Wrong"], data: [ReasonOfTransferDatum]()))
                        }else{
                            completion(baseResponse)

                        }
                        
                        
                        
                    }catch let err{
                        print(err)
                        completion(ReasonsOfTransferResponse(success: false, code: "100", message: [String](), data: [ReasonOfTransferDatum]()))
                    }
                }
            }
    }
    
    func getMGReasonsOfTransfer(token : String,completion:@escaping(_ response : MGReasonsOfTransferResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        AFManager.request("\(Constants.BASE_URL)MG/Send/GetReasonOfTransfer", method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(MGReasonsOfTransferResponse(success: false, code: "401", message: [String](), data: [MGReasonOfTransferDatum]()))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(MGReasonsOfTransferResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        
                        
                        let decoder = JSONDecoder()
                        let baseResponse = try decoder.decode(MGReasonsOfTransferResponse.self, from: json)
                        
                        if baseResponse.success == false {
                            completion(MGReasonsOfTransferResponse(success: false, code: baseResponse.code ?? "401", message: baseResponse.message ?? ["Something Wrong"], data: [MGReasonOfTransferDatum]()))
                        }else{
                            completion(baseResponse)

                        }
                        
                    }catch let err{
                        print(err)
                        completion(MGReasonsOfTransferResponse(success: false, code: "100", message: [String](), data: [MGReasonOfTransferDatum]()))
                    }
                }
            }
    }
    
    func getMGBeneficiaries(token : String, countryId : String,completion:@escaping(_ response : MGBeneficiriesResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        AFManager.request("\(Constants.BASE_URL)Beneficiaries/Get?CountryId=\(countryId)", method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(MGBeneficiriesResponse(success: false, code: "401", message: [String](), data: [MGBeneficiaryDatum]()))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(MGBeneficiriesResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        
                        let decoder = JSONDecoder()
                        let baseResponse = try decoder.decode(MGBeneficiriesResponse.self, from: json)
                        
                        if baseResponse.success == false {
                            completion(MGBeneficiriesResponse(success: false, code: baseResponse.code ?? "401", message: baseResponse.message ?? ["Something Wrong"], data: [MGBeneficiaryDatum]()))
                        }else{
                            completion(baseResponse)

                        }
                        
                        
                        
                    }catch let err{
                        print(err)
                        completion(MGBeneficiriesResponse(success: false, code: "100", message: [String](), data: [MGBeneficiaryDatum]()))
                    }
                }
            }
    }
    
    //relation to receiver
    func getRelationToReceiver(token : String,completion:@escaping(_ response : RelationToReceiverResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        AFManager.request("\(Constants.BASE_URL)remRelationToReceiver", method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(RelationToReceiverResponse(success: false, code: "401", message: [String](), data: [RelationToReceiverDatum]()))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(RelationToReceiverResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        
                        let decoder = JSONDecoder()
                        let baseResponse = try decoder.decode(RelationToReceiverResponse.self, from: json)
                        
                        if baseResponse.success == false {
                            completion(RelationToReceiverResponse(success: false, code: baseResponse.code ?? "401", message: baseResponse.message ?? ["Something Wrong"], data: [RelationToReceiverDatum]()))
                        }else{
                            completion(baseResponse)

                        }
                        
                        
                        
                    }catch let err{
                        print(err)
                        completion(RelationToReceiverResponse(success: false, code: "100", message: [String](), data: [RelationToReceiverDatum]()))
                    }
                }
            }
    }
    
    func getMGRelationToReceiver(token : String,completion:@escaping(_ response : MGRelationToReceiverResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        AFManager.request("\(Constants.BASE_URL)MG/Send/GetRelationships", method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(MGRelationToReceiverResponse(success: false, code: "401", message: [String](), data: [MGRelationToReceiverDatum]()))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(MGRelationToReceiverResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        
                        let decoder = JSONDecoder()
                        let baseResponse = try decoder.decode(MGRelationToReceiverResponse.self, from: json)
                        
                        if baseResponse.success == false {
                            completion(MGRelationToReceiverResponse(success: false, code: baseResponse.code ?? "401", message: baseResponse.message ?? ["Something Wrong"], data: [MGRelationToReceiverDatum]()))
                        }else{
                            completion(baseResponse)

                        }
                        
                        
                    }catch let err{
                        print(err)
                        completion(MGRelationToReceiverResponse(success: false, code: "100", message: [String](), data: [MGRelationToReceiverDatum]()))
                    }
                }
            }
    }
    
    func getRCVReasonsOfTransfer(token : String, providerId : String,completion:@escaping(_ response : RCVReasonsOfTransferResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        AFManager.request("\(Constants.BASE_URL)RCV/GetReasonOfTransfer?providerId=\(providerId)", method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(RCVReasonsOfTransferResponse(success: false, code: "401", message: [String](), data: [RCVReasonOfTransfer]()))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(RCVReasonsOfTransferResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        
                        
                        let decoder = JSONDecoder()
                        let baseResponse = try decoder.decode(RCVReasonsOfTransferResponse.self, from: json)
                        
                        if baseResponse.success == false {
                            completion(RCVReasonsOfTransferResponse(success: false, code: baseResponse.code ?? "401", message: baseResponse.message ?? ["Something Wrong"], data: [RCVReasonOfTransfer]()))
                        }else{
                            completion(baseResponse)

                        }
                        
                        
                        
                    }catch let err{
                        print(err)
                        completion(RCVReasonsOfTransferResponse(success: false, code: "100", message: [String](), data: [RCVReasonOfTransfer]()))
                    }
                }
            }
    }
    
    func getRCVRelationships(token : String, providerId : String,completion:@escaping(_ response : RCVRelationshipsResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        AFManager.request("\(Constants.BASE_URL)RCV/GetRelationships?providerId=\(providerId)", method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(RCVRelationshipsResponse(success: false, code: "401", message: [String](), data: [RCVRelationship]()))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(RCVRelationshipsResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                      
                        let decoder = JSONDecoder()
                        let baseResponse = try decoder.decode(RCVRelationshipsResponse.self, from: json)
                        
                        if baseResponse.success == false {
                            completion(RCVRelationshipsResponse(success: false, code: baseResponse.code ?? "401", message: baseResponse.message ?? ["Something Wrong"], data: [RCVRelationship]()))
                        }else{
                            completion(baseResponse)

                        }
                        
                        
                    }catch let err{
                        print(err)
                        completion(RCVRelationshipsResponse(success: false, code: "100", message: [String](), data: [RCVRelationship]()))
                    }
                }
            }
    }
    
    //source of funds
    func getSourceOfFunds(token : String,completion:@escaping(_ response : SourceOfFundsResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        AFManager.request("\(Constants.BASE_URL)remSourceOfFunds", method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(SourceOfFundsResponse(success: false, code: "401", message: [String](), data: [SourceOfFundsDatum]()))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(SourceOfFundsResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        
                        let decoder = JSONDecoder()
                        let baseResponse = try decoder.decode(SourceOfFundsResponse.self, from: json)
                        
                        if baseResponse.success == false {
                            completion(SourceOfFundsResponse(success: false, code: baseResponse.code ?? "401", message: baseResponse.message ?? ["Something Wrong"], data: [SourceOfFundsDatum]()))
                        }else{
                            completion(baseResponse)

                        }
                        
                        
                        
                    }catch let err{
                        print(err)
                        completion(SourceOfFundsResponse(success: false, code: "100", message: [String](), data: [SourceOfFundsDatum]()))
                    }
                }
            }
    }
    
    func getMGSourceOfFunds(token : String,completion:@escaping(_ response : MGSourceOfFundsResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        AFManager.request("\(Constants.BASE_URL)MG/Send/GetSourcesOfFunds", method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(MGSourceOfFundsResponse(success: false, code: "401", message: [String](), data: [MGSourceOfFundsDatum]()))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(MGSourceOfFundsResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        
                        let decoder = JSONDecoder()
                        let baseResponse = try decoder.decode(MGSourceOfFundsResponse.self, from: json)
                        
                        if baseResponse.success == false {
                            completion(MGSourceOfFundsResponse(success: false, code: baseResponse.code ?? "401", message: baseResponse.message ?? ["Something Wrong"], data: [MGSourceOfFundsDatum]()))
                        }else{
                            completion(baseResponse)

                        }
                        
                        
                    }catch let err{
                        print(err)
                        completion(MGSourceOfFundsResponse(success: false, code: "100", message: [String](), data: [MGSourceOfFundsDatum]()))
                    }
                }
            }
    }
    
    
    //service commissions (for confirm step)
    func getSourceOfFunds(token : String,ServiceProviderId : String, Amount : Double,completion:@escaping(_ response : ServiceCommisionsResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        AFManager.request("\(Constants.BASE_URL)remServiceProviderCommissions/GetCommission?ServiceProviderId=\(ServiceProviderId)&Amount=\(Amount)", method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(ServiceCommisionsResponse(success: false, code: "401", message: [String](), data: nil))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(ServiceCommisionsResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        
                        
                        let decoder = JSONDecoder()
                        let baseResponse = try decoder.decode(ServiceCommisionsResponse.self, from: json)
                        
                        if baseResponse.success == false {
                            completion(ServiceCommisionsResponse(success: false, code: baseResponse.code ?? "401", message: baseResponse.message ?? ["Something Wrong"], data: nil))
                        }else{
                            completion(baseResponse)

                        }
                        
                    }catch let err{
                        print(err)
                        completion(ServiceCommisionsResponse(success: false, code: "100", message: [String](), data: nil))
                    }
                }
            }
    }
    
    
    //eWallet types
    func getWalletProviders(token : String,isInternal:Bool,completion:@escaping(_ response : WalletProvidersResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        AFManager.request("\(Constants.BASE_URL)remWalletsProviders?isInternal=\(isInternal)", method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(WalletProvidersResponse(success: false, code: "401", message: [String](), data: [WalletProviderDatum]()))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(WalletProvidersResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        
                        let decoder = JSONDecoder()
                        let baseResponse = try decoder.decode(WalletProvidersResponse.self, from: json)
                        
                        if baseResponse.success == false {
                            completion(WalletProvidersResponse(success: false, code: baseResponse.code ?? "401", message: baseResponse.message ?? ["Something Wrong"], data: [WalletProviderDatum]()))
                        }else{
                            completion(baseResponse)

                        }
                        
                    }catch let err{
                        print(err)
                        completion(WalletProvidersResponse(success: false, code: "100", message: [String](), data: [WalletProviderDatum]()))
                    }
                }
            }
    }
    
    func getBanks(token : String,completion:@escaping(_ response : BanksResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        AFManager.request("\(Constants.BASE_URL)cmnBanks", method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(BanksResponse(success: false, code: "401", message: [String](), data: [BankDatum]()))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(BanksResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        
                        let decoder = JSONDecoder()
                        let baseResponse = try decoder.decode(BanksResponse.self, from: json)
                        
                        if baseResponse.success == false {
                            completion(BanksResponse(success: false, code: baseResponse.code ?? "401", message: baseResponse.message ?? ["Something Wrong"], data: [BankDatum]()))
                        }else{
                            completion(baseResponse)

                        }
                        
                    }catch let err{
                        print(err)
                        completion(BanksResponse(success: false, code: "100", message: [String](), data: [BankDatum]()))
                    }
                }
            }
    }
    
    func getDynamicFields(token : String, beneficiaryId : String, sendModel : SendMoneyMGModel? ,completion:@escaping(_ response : DynamicFieldsResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        let url = "\(Constants.BASE_URL)MG/Send/GetFieldsForProduct?MGSendServiceOptionRequestId=\(sendModel?.selectedServiceOption?.mgSendTransactionID ?? "")&MGGuid=\(sendModel?.selectedServiceOption?.mgGUID ?? "")&BeneficiaryId=\(beneficiaryId)"
        
        AFManager.request(url, method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {

                        let decoder = JSONDecoder()
                        let baseResponse = try decoder.decode(DynamicFieldsResponse.self, from: json)
                        
                        if baseResponse.success == false {
                            completion(DynamicFieldsResponse(success: false, code: baseResponse.code ?? "401", message: baseResponse.message ?? ["Something Wrong"], data: nil))
                        }else{
                            completion(baseResponse)

                        }


                
                        
                    }catch let err{
                        print(err)
                        completion(DynamicFieldsResponse(success: false, code: "100", message: [String](), data: nil))
                    }
                }
            }
    }
    
    func getServiceProviderCommission(token : String, sendModel : SendMoneyMGModel? ,completion:@escaping(_ response : ServiceProviderCommissionResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        let url = "\(Constants.BASE_URL)remServiceProviderCommissions/GetCommission?ServiceProviderId=\(sendModel?.serviceProviderId ?? "")&Amount=\(sendModel?.amount ?? 0.0)"
        
        AFManager.request(url, method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
                        let statusCode = response.response?.statusCode
                        if (statusCode == 401) {
                            completion(ServiceProviderCommissionResponse(success: false, code: "401", message: [String](), data: nil))
                        }else {
                            let decoder = JSONDecoder()
                            let baseResponse = try decoder.decode(ServiceProviderCommissionResponse.self, from: json)
                            completion(baseResponse)
                        }
                        
                    }catch let err{
                        print(err)
                        completion(ServiceProviderCommissionResponse(success: false, code: "100", message: [String](), data: nil))
                    }
                }
            }
    }
    
    
    func getServiceProviderCommissionAFS(token : String, sendModel : SendMoneyAFSModel? ,completion:@escaping(_ response : ServiceProviderCommissionResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        let url = "\(Constants.BASE_URL)remServiceProviderCommissions/GetCommission?ServiceProviderId=\(sendModel?.serviceProviderId ?? "")&Amount=\((sendModel?.amount ?? "0.0").replacedArabicDigitsWithEnglish)"
        
        AFManager.request(url, method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
                        let statusCode = response.response?.statusCode
                        if (statusCode == 401) {
                            completion(ServiceProviderCommissionResponse(success: false, code: "401", message: [String](), data: nil))
                        }else {
                            let decoder = JSONDecoder()
                            let baseResponse = try decoder.decode(ServiceProviderCommissionResponse.self, from: json)
                            completion(baseResponse)
                        }
                        
                    }catch let err{
                        print(err)
                        completion(ServiceProviderCommissionResponse(success: false, code: "100", message: [String](), data: nil))
                    }
                }
            }
    }
    
    
    
    func getPaymentMethodCommission(token : String, sendModel : SendMoneyMGModel? ,completion:@escaping(_ response : PaymentMethodCommissionResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        let url = "\(Constants.BASE_URL)remPayMethodsCommission?Amount=\(sendModel?.amount ?? 0.0)&PayMethodId=\(sendModel?.payInOption?.payMethodsResponseID ?? 0)"
        
        AFManager.request(url, method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
                        let statusCode = response.response?.statusCode
                        if (statusCode == 401) {
                            completion(PaymentMethodCommissionResponse(success: false, code: "401", message: [String](), data: nil))
                        }else {
                            let decoder = JSONDecoder()
                            let baseResponse = try decoder.decode(PaymentMethodCommissionResponse.self, from: json)
                            completion(baseResponse)
                        }
                        
                    }catch let err{
                        print(err)
                        completion(PaymentMethodCommissionResponse(success: false, code: "100", message: [String](), data: nil))
                    }
                }
            }
    }
    
    func getPaymentMethodCommissionAFS(token : String, sendModel : SendMoneyAFSModel? ,completion:@escaping(_ response : PaymentMethodCommissionResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        let url = "\(Constants.BASE_URL)remPayMethodsCommission?Amount=\((sendModel?.amount ?? "0.0".replacedArabicDigitsWithEnglish))&PayMethodId=\(sendModel?.payInOption?.payMethodsResponseID ?? 0)"
        
        AFManager.request(url, method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
                        let statusCode = response.response?.statusCode
                        if (statusCode == 401) {
                            completion(PaymentMethodCommissionResponse(success: false, code: "401", message: [String](), data: nil))
                        }else {
                            let decoder = JSONDecoder()
                            let baseResponse = try decoder.decode(PaymentMethodCommissionResponse.self, from: json)
                            completion(baseResponse)
                        }
                        
                    }catch let err{
                        print(err)
                        completion(PaymentMethodCommissionResponse(success: false, code: "100", message: [String](), data: nil))
                    }
                }
            }
    }
    
    
    func getDoorToDoorCommission(token : String ,completion:@escaping(_ response : DoorToDoorCommissionResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        let url = "\(Constants.BASE_URL)remRemittanceSettings/GetDoorToDoorCommission"
        
        AFManager.request(url, method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
                        let statusCode = response.response?.statusCode
                        if (statusCode == 401) {
                            completion(DoorToDoorCommissionResponse(success: false, code: "401", message: [String](), data: nil))
                        }else {
                            let decoder = JSONDecoder()
                            let baseResponse = try decoder.decode(DoorToDoorCommissionResponse.self, from: json)
                            completion(baseResponse)
                        }
                        
                    }catch let err{
                        print(err)
                        completion(DoorToDoorCommissionResponse(success: false, code: "100", message: [String](), data: nil))
                    }
                }
            }
    }
    
    
    
    func getMGPaymentDetails(token : String, sendModel : SendMoneyMGModel? ,completion:@escaping(_ response : MGPaymentDetailsResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        var all : [String : Any] = ["MGSendServiceOptionRequestId" : sendModel?.selectedServiceOption?.mgSendTransactionID ?? "",
                                    "MGGuid" : sendModel?.selectedServiceOption?.mgGUID ?? "",
                                    "CountryId" : sendModel?.destinationCountry?.countryId ?? "",
                                    "ReasonOfTransferId" : sendModel?.selectedReasonOfTransfer?.reasonOfTransferID ?? "",
                                    "SourceOfFundId" : sendModel?.selectedSourceOfFund?.sourceOfFundID ?? "",
                                    "RelationshipsId" : sendModel?.selectedRelationship?.relationshipsID ?? "",
                                    "ReceiverFirstName" : sendModel?.receiverFirstName ?? "",
                                    "ReceiverLastName" : sendModel?.receiverLastName ?? ""]
        
        
        if(sendModel?.receiverSecondName?.count ?? 0 > 0) {
            all["ReceiverSecondName"] = sendModel?.receiverSecondName ?? ""
        }
        if(sendModel?.receiverSecondName?.count ?? 0 > 0) {
            all["ReceiverThirdName"] = sendModel?.receiverThirdName ?? ""
        }
        
        if (sendModel?.supportDocument != nil) {
            all["SupportDocument"] = sendModel?.supportDocument?.toBase64() ?? ""
        }
        
        AFManager.request("\(Constants.BASE_URL)MG/Send/ConfirmInfo", method: .post, parameters: all ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {

                        
                        let decoders = JSONDecoder()
                        let baseResponsess = try decoders.decode(MGPaymentDetailsResponse.self, from: json)
         

                        if baseResponsess.success == false{
                            completion(MGPaymentDetailsResponse(success: false, code: "\(baseResponsess.code ?? "401")", message: baseResponsess.message ?? ["Something Wrong"], data: nil))
                            
                        }else{

                            completion(baseResponsess)
                        }
                        
                        
                    }catch let err{
                        print(err)
                        completion(MGPaymentDetailsResponse(success: false, code: "100", message: [String](), data: nil))
                    }
                }
            }
    }
    
    
    func getAFSPaymentDetails(token : String, sendModel : SendMoneyAFSModel? ,completion:@escaping(_ response : AFSPaymentDetailsResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        let url = "\(Constants.BASE_URL)AFS/Send/ConfirmInfo"
        
        let all : [String : Any] = [
            "DestinationBranchId" : sendModel?.alamiBranch?.branchID ?? "",
            "FeeTypeId" : sendModel?.feeType ?? 1,
            "AmountByJOD" : sendModel?.amount ?? 0.0,
            "PurposeOfTransferId" : sendModel?.purpose?.reasonOfTransferID ?? "",
            "RelationToReceiverId" : sendModel?.relationship?.relationToReceiverID ?? "",
            "SourceOfFundId" : sendModel?.sourceOfFunds?.sourceOfFundsID ?? "",
            "ReceiverFirstNameEn" : sendModel?.selectedBeneficiary?.firstNameEn ?? "",
            "ReceiverSecondNameEn" : sendModel?.selectedBeneficiary?.secondNameEn ?? "",
            "ReceiverMiddleNameEn" : sendModel?.selectedBeneficiary?.thirdNameEn ?? "",
            "ReceiverLastNameEn" : sendModel?.selectedBeneficiary?.lastNameEn ?? "",
            "ReceiverPhoneNumber" : sendModel?.selectedBeneficiary?.mobile ?? "",
            "PayMethodId" : sendModel?.payInOption?.payMethodsResponseID ?? 0,
            
            //wallet
            "WalletProviderId" : sendModel?.walletProvider?.walletsProvidersID ?? "",
            "WalletNumber" : sendModel?.walletNumber ?? "",
            
            //DTD
            "DTDCity" : sendModel?.senderCity ?? "",
            "DTDRegion" : sendModel?.senderRegion ?? "",
            "DTDStreet" : sendModel?.senderStreet ?? "",
            "DTDBuilding" : sendModel?.senderBuildingNumber ?? "",
            "DTDAddress" : sendModel?.senderAddress ?? "",
            
            "PromotionCode" : ""
        ]
        
        AFManager.request(url, method: .post, parameters: all ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    print("value\(response.value)")
                    do {
                        let statusCode = response.response?.statusCode
                        if (statusCode == 401) {
                            completion(AFSPaymentDetailsResponse(success: false, code: "401", message: [String](), data: nil))
                        }else {
                            let decoder = JSONDecoder()
                            let baseResponse = try decoder.decode(AFSPaymentDetailsResponse.self, from: json)
                            completion(baseResponse)
                        }
                        
                    }catch let err{
                        print(err)
                        completion(AFSPaymentDetailsResponse(success: false, code: "100", message: [err.localizedDescription], data: nil))
                    }
                }
            }
    }
    
    func sendMoneyMG(token : String, sendModel : SendMoneyMGModel?,completion:@escaping(_ response : SendMoneyResponse)-> Void) {
        
        var headers = self.getJSONDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        var all : [String : Any] = ["MGSendServiceOptionRequestId" : sendModel?.selectedServiceOption?.mgSendTransactionID ?? "",
                                    "MGGuid" : sendModel?.selectedServiceOption?.mgGUID ?? "",
                                    "Note" : "MoneyGram Send Transaction from iOS App",]
        
        if (sendModel?.otpCode?.count ?? 0 > 0) {
            all["OTP"] = (sendModel?.otpCode ?? "").trim().replacedArabicDigitsWithEnglish
        }
        var dynamicFields : [[String : Any]] = [[String : Any]]()
        for dynamicField in sendModel?.dynamicFields ?? [DynamicFieldDatum]() {
            var isDynamic = false
            if (dynamicField.datumDynamic ?? false) {
                isDynamic = true
            }
            
            let all : [String : Any] = ["Label" : dynamicField.label ?? "",
                       "Value" : (dynamicField.value ?? "").trim(),
                       "XmlTag" : (dynamicField.xmlTag ?? "").trim(),
                       "DisplayOrder" : dynamicField.displayOrder ?? "",
                       "Dynamic" : isDynamic]
            
            dynamicFields.append(all)
        }
        
        
        all["MGSendSaveFieldsForProductRequests"] = dynamicFields
        
        
        AFManager.request("\(Constants.BASE_URL)MG/Send/SaveRemittance", method: .post, parameters: all ,encoding: JSONEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
                        
                        let decoder = JSONDecoder()
                        let baseResponses = try decoder.decode(SendMoneyResponse.self, from: json)
                        
                        print("Value:\(response.value)")

                        if baseResponses.success == false{
                            
                            
                        
                        completion(SendMoneyResponse(success: false, code: "\(baseResponses.code)", message: baseResponses.message ?? ["Something Wrong"], data: [MGSentDatum]()))
                            
                            
                            
                        }else{

                        completion(baseResponses)
                            
                        }
                        
                        
                        
                    }catch let err{
                        print(err)
                        completion(SendMoneyResponse(success: false, code: "100", message: [String](), data: [MGSentDatum]()))
                    }
                }
            }
    }
    
    
    
    
    func sendMoneyMG2(token : String, sendModel : SendMoneyMGModel?,completion:@escaping(_ response : SendMoneyResponse)-> Void) {
        
        var headers = self.getJSONDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        var all : [String : Any] = ["MGSendServiceOptionRequestId" : sendModel?.selectedServiceOption?.mgSendTransactionID ?? "",
                                    "MGGuid" : sendModel?.selectedServiceOption?.mgGUID ?? "",
                                    "Note" : "MoneyGram Send Transaction from iOS App",]
        
        if (sendModel?.otpCode?.count ?? 0 > 0) {
            all["OTP"] = (sendModel?.otpCode ?? "").trim().replacedArabicDigitsWithEnglish
        }
        var dynamicFields : [[String : Any]] = [[String : Any]]()
        for dynamicField in sendModel?.dynamicFields ?? [DynamicFieldDatum]() {
            var isDynamic = false
            if (dynamicField.datumDynamic ?? false) {
                isDynamic = true
            }
            
            let all : [String : Any] = ["Label" : dynamicField.label ?? "",
                       "Value" : (dynamicField.value ?? "").trim(),
                       "XmlTag" : (dynamicField.xmlTag ?? "").trim(),
                       "DisplayOrder" : dynamicField.displayOrder ?? "",
                       "Dynamic" : isDynamic]
            
            dynamicFields.append(all)
        }
        
        
        all["MGSendSaveFieldsForProductRequests"] = dynamicFields
        
        
        AFManager.request("\(Constants.BASE_URL)MG/Send/ConfirmInfo2", method: .post, parameters: all ,encoding: JSONEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
                        print("Value::::\(response.value)")

                        let decoders = JSONDecoder()
                        let baseResponsess = try decoders.decode(SendMoneyResponse.self, from: json)
         

                        if baseResponsess.success == false{
                            completion(SendMoneyResponse(success: false, code: "\(baseResponsess.code ?? "401")", message: baseResponsess.message ?? ["Something Wrong"], data: nil))
                            
                        }else{

                        completion(baseResponsess)
                        }
                        
                    }catch let err{
                        print(err)
                        completion(SendMoneyResponse(success: false, code: "100", message: [String](), data: [MGSentDatum]()))
                    }
                }
            }
    }

    

   
    
    
    func sendMoneyAFS(token : String, sendModel : SendMoneyAFSModel?,completion:@escaping(_ response : AFSSendMoneyResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        var all : [String : Any] = ["AFSGuid" : sendModel?.afsGuid ?? ""]
        
        let otpCode = sendModel?.otpCode ?? ""
        if (otpCode.count > 0) {
            all["OTP"] = otpCode.replacedArabicDigitsWithEnglish
        }
        
        AFManager.request("\(Constants.BASE_URL)AFS/Send/SaveRemittance", method: .post, parameters: all ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(AFSSendMoneyResponse(success: false, code: "401", message: [String](), data: nil))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(AFSSendMoneyResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        
                        let decoders = JSONDecoder()
                        let baseResponsess = try decoders.decode(AFSSendMoneyResponse.self, from: json)
         

                        if baseResponsess.success == false{
                            completion(AFSSendMoneyResponse(success: false, code: "\(baseResponsess.code ?? "401")", message: baseResponsess.message ?? ["Something Wrong"], data: nil))
                            
                        }else{

                        completion(baseResponsess)
                        }
                        
                        
                    }catch let err{
                        print(err)
                        completion(AFSSendMoneyResponse(success: false, code: "100", message: [String](), data: nil))
                    }
                }
            }
    }
    
    //final update
    
    func resendRcvOtpCode(token : String, rcvGuid : String,completion:@escaping(_ response : BaseResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        let all : [String : Any] = ["RCVGuid" : rcvGuid]
        
        AFManager.request("\(Constants.BASE_URL)AFS/RCV/ReSendOTPCode", method: .post, parameters: all ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(BaseResponse(success: false, code: "401", message: [String]()))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(BaseResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        
                        let decoders = JSONDecoder()
                        let baseResponsess = try decoders.decode(BaseResponse.self, from: json)
         

                        if baseResponsess.success == false{
                            completion(BaseResponse(success: false, code: baseResponsess.code ?? "401", message: baseResponsess.message ?? ["Something Wrong"]))
                            
                        }else{

                        completion(baseResponsess)
                        }
                        
                    }catch let err{
                        print(err)
                        completion(BaseResponse(success: false, code: "100", message: [String]()))
                    }
                }
            }
    }
    
    func resendAfsOtpCode(token : String, afsGuid : String,completion:@escaping(_ response : BaseResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        let all : [String : Any] = ["AFSGuid" : afsGuid]
        
        AFManager.request("\(Constants.BASE_URL)AFS/Send/ReSendOTPCode", method: .post, parameters: all ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(BaseResponse(success: false, code: "401", message: [String]()))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(BaseResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        let decoders = JSONDecoder()
                        let baseResponsess = try decoders.decode(BaseResponse.self, from: json)
         

                        if baseResponsess.success == false{
                            completion(BaseResponse(success: false, code: baseResponsess.code ?? "401", message: baseResponsess.message ?? ["Something Wrong"]))
                            
                        }else{

                        completion(baseResponsess)
                        }
                        
                        
                    }catch let err{
                        print(err)
                        completion(BaseResponse(success: false, code: "100", message: [String]()))
                    }
                }
            }
    }
    
    
    func resendMGOtpCode(token : String, mgGuid : String,completion:@escaping(_ response : BaseResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        let all : [String : Any] = ["MGGuid" : mgGuid]
        
        AFManager.request("\(Constants.BASE_URL)MG/Send/ReSendOTPCode", method: .post, parameters: all ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(BaseResponse(success: false, code: "401", message: [String]()))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(BaseResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        

                        let decoders = JSONDecoder()
                        let baseResponsess = try decoders.decode(BaseResponse.self, from: json)
                        print("Messssasasa:\(baseResponsess.message)")


                        if baseResponsess.success == false{
                            completion(BaseResponse(success: false, code: baseResponsess.code ?? "401", message: baseResponsess.message ?? ["Something Wrong"]))
                            
                        }else{

                        completion(baseResponsess)
                        }
                    }catch let err{
                        print(err)
                        completion(BaseResponse(success: false, code: "100", message: [String]()))
                    }
                }
            }
    }
    
//    func getRCVPaymentDetails2(token : String, receiveModel : ReceiveMoneyModel?,serviceProviderId:String?,requestRemittanceNumber:String?,damanPAYNO:String?,damanServiceType:String?,payoutMethodId:String?,completion:@escaping(_ response : RCVPaymentDetailsResponse)-> Void) {
//
//        var headers = self.getDefaultHeaders()
//        headers["Authorization"] = "Bearer \(token)"
//
//
//        let all : [String : Any] = [
//
//
//                                    "ServicesProviderId" : receiveModel?.serviceProviderId ?? "",
//                                    "RequestRemittanceNumber":receiveModel?.requestRemittanceNumber ?? "",
//                                    "DamanPAYNO":receiveModel?.damanPAYNO ?? "",
//                                    "DamanServiceType":receiveModel?.damanServiceType ?? "",
//                                    "PayoutMethodId":receiveModel?.payoutMethodId ?? ""
//
//
//
////                                    "ServicesProviderId" : serviceProviderId ?? "",
////                                    "RequestRemittanceNumber":requestRemittanceNumber ?? "",
////                                    "DamanPAYNO":damanPAYNO ?? "",
////                                    "DamanServiceType":damanServiceType ?? "",
////                                    "PayoutMethodId":payoutMethodId ?? ""
//
//        ]
//
//
//        AFManager.request("\(Constants.BASE_URL)RCV/Confirm", method: .post, parameters: all ,encoding: URLEncoding(), headers: headers)
//            .responseJSON { response in
//                if let json = response.data {
//                    do {
////                        let statusCode = response.response?.statusCode
////                        if (statusCode == 401) {
////                            completion(RCVPaymentDetailsResponse(success: false, code: "401", message: [String](), data: nil))
////                        }else {
////                            let decoder = JSONDecoder()
////                            let baseResponse = try decoder.decode(RCVPaymentDetailsResponse.self, from: json)
////                            completion(baseResponse)
////                        }
//
//
//                        let decoders = JSONDecoder()
//                        let baseResponsess = try decoders.decode(RCVPaymentDetailsResponse.self, from: json)
//
//
//                        if baseResponsess.success == false{
//                            completion(RCVPaymentDetailsResponse(success: false, code: baseResponsess.code ?? "401", message: baseResponsess.message ?? ["Something Wrong"], data: nil))
//
//                        }else{
//
//                        completion(baseResponsess)
//                        }
//
//                    }catch let err{
//                        print(err)
//                        completion(RCVPaymentDetailsResponse(success: false, code: "100", message: [String](), data: nil))
//                    }
//                }
//            }
//    }
//
    
    
    
    func getRCVPaymentDetails2(token : String, receiveModel : ReceiveMoneyModel?,completion:@escaping(_ response : RCVPaymentDetailsResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        
        let all : [String : Any] = [
            
            
                                    "ServicesProviderId" : receiveModel?.serviceProviderId ?? "",
                                    "RequestRemittanceNumber":receiveModel?.requestRemittanceNumber ?? "",
                                    "DamanPAYNO":receiveModel?.damanPAYNO ?? "",
                                    "DamanServiceType":receiveModel?.damanServiceType ?? "",
                                    "PayoutMethodId":receiveModel?.payoutMethodId ?? ""
        
            
            
//                                    "ServicesProviderId" : serviceProviderId ?? "",
//                                    "RequestRemittanceNumber":requestRemittanceNumber ?? "",
//                                    "DamanPAYNO":damanPAYNO ?? "",
//                                    "DamanServiceType":damanServiceType ?? "",
//                                    "PayoutMethodId":payoutMethodId ?? ""
        
        ]
        
        
        AFManager.request("\(Constants.BASE_URL)RCV/Confirm", method: .post, parameters: all ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(RCVPaymentDetailsResponse(success: false, code: "401", message: [String](), data: nil))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(RCVPaymentDetailsResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        
                        let decoders = JSONDecoder()
                        let baseResponsess = try decoders.decode(RCVPaymentDetailsResponse.self, from: json)
         

                        if baseResponsess.success == false{
                            completion(RCVPaymentDetailsResponse(success: false, code: baseResponsess.code ?? "401", message: baseResponsess.message ?? ["Something Wrong"], data: nil))
                            
                        }else{

                        completion(baseResponsess)
                        }
                        
                    }catch let err{
                        print(err)
                        completion(RCVPaymentDetailsResponse(success: false, code: "100", message: [String](), data: nil))
                    }
                }
            }
    }
    
    
    
    
    func getRCVPaymentDetails(token : String, receiveModel : ReceiveMoneyModel?,completion:@escaping(_ response : RCVPaymentDetailsResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        
        let all : [String : Any] = ["ServicesProviderId" : receiveModel?.serviceProviderId ?? "",
                                    "RequestRemittanceNumber" : (receiveModel?.remittanceNo ?? "").replacedArabicDigitsWithEnglish,
                                    "PurposeOfTransferId" : receiveModel?.selectedPurpose?.reasonOfTransferID ?? "",
                                    "RelationToReceiverId" : receiveModel?.selectedRelationship?.relationshipsID ?? "",
                                    "PayoutMethodId" : receiveModel?.payoutOption?.payoutMethodID ?? 0,
                                   
                                    //doot to door
                                    "DTDCity" : receiveModel?.ReceiverCity ?? "",
                                    "DTDRegion" : receiveModel?.ReceiverRegion ?? "",
                                    "DTDStreet" : receiveModel?.ReceiverStreet ?? "",
                                    "DTDBuilding" : receiveModel?.ReceiverBuildingNumber ?? "",
                                    "DTDAddress" : receiveModel?.ReceiverAddress ?? "",
                                    
                                    //bank
                                    "BankId" : receiveModel?.selectedBank?.bankID ?? "",
                                    "BankIBAN" : receiveModel?.IBAN ?? "",
                                    "BankAccountNumber" : receiveModel?.accountNumber ?? "",
                                   
                                    //wallet
                                    "WalletProviderId" : receiveModel?.walletProvider?.walletsProvidersID ?? "",
                                    "WalletNumber" : (receiveModel?.walletNumber ?? "").trim().replacedArabicDigitsWithEnglish,
                                    
//                                    
//                                    "RequestRemittanceNumber":receiveModel?.requestRemittanceNumber ?? "",
//                                    "DamanPAYNO":receiveModel?.damanPAYNO ?? "",
//                                    "DamanServiceType":receiveModel?.damanServiceType ?? ""
        
        
        
        ]
        
        
        AFManager.request("\(Constants.BASE_URL)RCV/Confirm", method: .post, parameters: all ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(RCVPaymentDetailsResponse(success: false, code: "401", message: [String](), data: nil))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(RCVPaymentDetailsResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        
                        let decoders = JSONDecoder()
                        let baseResponsess = try decoders.decode(RCVPaymentDetailsResponse.self, from: json)
         

                        if baseResponsess.success == false{
                            completion(RCVPaymentDetailsResponse(success: false, code: baseResponsess.code ?? "401", message: baseResponsess.message ?? ["Something Wrong"], data: nil))
                            
                        }else{

                        completion(baseResponsess)
                        }
                        
                    }catch let err{
                        print(err)
                        completion(RCVPaymentDetailsResponse(success: false, code: "100", message: [String](), data: nil))
                    }
                }
            }
    }
    
    
    
    
    func getDamanServiceType(token:String,reqtype:String,completion:@escaping(_ response : DamanServiceTypeResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        AFManager.request("\(Constants.BASE_URL)RCV/DamanServiceType?reqtype=\(reqtype)", method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {


                    let decoder = JSONDecoder()
                    let baseResponsess = try decoder.decode(DamanServiceTypeResponse.self, from: json)
                        
                        
                        
                        if baseResponsess.success == false{
                            completion(DamanServiceTypeResponse(success: false, code: baseResponsess.code ?? "401", message: baseResponsess.message ?? ["Something Wrong"], data: [DamanServiceType]()))
                        }else{
                            
                        let decoder = JSONDecoder()
                        let baseResponse = try decoder.decode(DamanServiceTypeResponse.self, from: json)
                        completion(baseResponse)
                        }
                        
                        
                        
                        

                        
                    }catch let err{
                        print(err)
                        completion(DamanServiceTypeResponse(success: false, code: "100", message: [String](), data: [DamanServiceType]()))
                    }
                }
            }
        
    }
//    func getServiceProviders(token : String,completion:@escaping(_ response : ServicesResponse)-> Void) {
//
//        var headers = self.getDefaultHeaders()
//        headers["Authorization"] = "Bearer \(token)"
//
//        AFManager.request("\(Constants.BASE_URL)remServicesProviders", method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
//            .responseJSON { response in
//                if let json = response.data {
//                    do {
////                        let statusCode = response.response?.statusCode
////                        if (statusCode == 401) {
////                            completion(ServicesResponse(success: false, code: "401", message: [String](), data: [ServiceDatum]()))
////                        }else {
////                            let decoder = JSONDecoder()
////                            let baseResponse = try decoder.decode(ServicesResponse.self, from: json)
////                            completion(baseResponse)
////                        }
//
//
//                    let decoder = JSONDecoder()
//                    let baseResponsess = try decoder.decode(ServicesResponse.self, from: json)
//
//
//
//                        if baseResponsess.success == false{
//                            completion(ServicesResponse(success: false, code: baseResponsess.code ?? "401", message: baseResponsess.message ?? ["Something Wrong"], data: [ServiceDatum]()))
//                        }else{
//
//                        let decoder = JSONDecoder()
//                        let baseResponse = try decoder.decode(ServicesResponse.self, from: json)
//                        completion(baseResponse)
//                        }
//
//
//
//
//
//
//                    }catch let err{
//                        print(err)
//                        completion(ServicesResponse(success: false, code: "100", message: [String](), data: [ServiceDatum]()))
//                    }
//                }
//            }
//    }
    
    func submitRCVRequest(token : String, receiveModel : ReceiveMoneyModel? ,completion:@escaping(_ response : ReceiveMoneyResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        var all : [String : Any] = ["RCVGuid" : receiveModel?.rcvGuid ?? ""]
        
        let code = receiveModel?.otpCode ?? ""
        if (code.count > 0) {
            all["OTP"] = (receiveModel?.otpCode ?? "").trim().replacedArabicDigitsWithEnglish
        }
        
        AFManager.request("\(Constants.BASE_URL)RCV/Save", method: .post, parameters: all ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(ReceiveMoneyResponse(success: false, code: "401", message: [String](), data: nil))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(ReceiveMoneyResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        
                        let decoders = JSONDecoder()
                        let baseResponsess = try decoders.decode(ReceiveMoneyResponse.self, from: json)
         

                        if baseResponsess.success == false{
                            completion(ReceiveMoneyResponse(success: false, code: baseResponsess.code ?? "401", message: baseResponsess.message ?? ["Something Wrong"], data: nil))
                            
                        }else{

                        completion(baseResponsess)
                        }
                        
                        
                    }catch let err{
                        print(err)
                        completion(ReceiveMoneyResponse(success: false, code: "100", message: [err.localizedDescription], data: nil))
                    }
                }
            }
    }
    
    func getTransactionDetails(token : String, transactionId : String ,completion:@escaping(_ response : TransactionDetailsResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        let url = "\(Constants.BASE_URL)remInternalTransfer?Id=\(transactionId)"
        
        AFManager.request(url, method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
                        let statusCode = response.response?.statusCode
                        if (statusCode == 401) {
                            completion(TransactionDetailsResponse(success: false, code: "401", message: [String](), data: nil))
                        }else {
                            let decoder = JSONDecoder()
                            let baseResponse = try decoder.decode(TransactionDetailsResponse.self, from: json)
                            completion(baseResponse)
                        }
                        
                    }catch let err{
                        print(err)
                        completion(TransactionDetailsResponse(success: false, code: "100", message: [String](), data: nil))
                    }
                }
            }
    }
    
    
    func getBeneficiaries(token : String ,completion:@escaping(_ response : BeneficiariesResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        let url = "\(Constants.BASE_URL)custCustomers/GetBeneficiary"
        
        AFManager.request(url, method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(BeneficiariesResponse(success: false, code: "401", message: [String](), data: [BeneficiaryDatum]()))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(BeneficiariesResponse.self, from: json)
//                            completion(baseResponse)
//                        }
//
                        
                        let decoders = JSONDecoder()
                        let baseResponsess = try decoders.decode(BeneficiariesResponse.self, from: json)
         

                        if baseResponsess.success == false{
                            completion(BeneficiariesResponse(success: false, code: baseResponsess.code ?? "401", message: baseResponsess.message ?? ["Something Wrong"], data:  [BeneficiaryDatum]()))
                            
                        }else{

                        completion(baseResponsess)
                        }
                        
                        
                    }catch let err{
                        print(err)
                        completion(BeneficiariesResponse(success: false, code: "100", message: [String](), data: [BeneficiaryDatum]()))
                    }
                }
            }
    }
    
    func getMyBeneficiaries(token : String ,completion:@escaping(_ response : MyBeneficiariesResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        let url = "\(Constants.BASE_URL)Beneficiaries/Get"
        
        AFManager.request(url, method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(MyBeneficiariesResponse(success: false, code: "401", message: [String](), data: [MyBeneficiaryDatum]()))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(MyBeneficiariesResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        let decoders = JSONDecoder()
                        let baseResponsess = try decoders.decode(MyBeneficiariesResponse.self, from: json)
         

                        if baseResponsess.success == false{
                            completion(MyBeneficiariesResponse(success: false, code: baseResponsess.code ?? "401", message: baseResponsess.message ?? ["Something Wrong"], data:  [MyBeneficiaryDatum]()))
                            
                        }else{

                        completion(baseResponsess)
                        }
                        
                    }catch let err{
                        print(err)
                        completion(MyBeneficiariesResponse(success: false, code: "100", message: [String](), data: [MyBeneficiaryDatum]()))
                    }
                }
            }
    }
    
    //check moneygram reward
    func checkMGReward(token : String,completion:@escaping(_ response : MGRewardResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        AFManager.request("\(Constants.BASE_URL)MG/Reward/CheckReward", method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(MGRewardResponse(success: false, code: "401", message: [String](), data: ""))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(MGRewardResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        
                        let decoders = JSONDecoder()
                        let baseResponsess = try decoders.decode(MGRewardResponse.self, from: json)
         

                        if baseResponsess.success == false{
                            completion(MGRewardResponse(success: false, code: baseResponsess.code ?? "401", message: baseResponsess.message ?? ["Something Wrong"], data:  ""))
                            
                        }else{

                        completion(baseResponsess)
                        }
                        
                    }catch let err{
                        print(err)
                        completion(MGRewardResponse(success: false, code: "100", message: [String](), data: ""))
                    }
                }
            }
    }
    
    func getRewardSuggestions(token : String,completion:@escaping(_ response : RewardSuggestionsResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        AFManager.request("\(Constants.BASE_URL)MG/Reward/getSuggestionInfo", method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(RewardSuggestionsResponse(success: false, code: "401", message: [String](), data: nil))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(RewardSuggestionsResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        
                        
                        let decoders = JSONDecoder()
                        let baseResponsess = try decoders.decode(RewardSuggestionsResponse.self, from: json)
         

                        if baseResponsess.success == false{
                            completion(RewardSuggestionsResponse(success: false, code: baseResponsess.code ?? "401", message: baseResponsess.message ?? ["Something Wrong"], data:  nil))
                            
                        }else{

                        completion(baseResponsess)
                        }
                        
                    }catch let err{
                        print(err)
                        completion(RewardSuggestionsResponse(success: false, code: "100", message: [String](), data: nil))
                    }
                }
            }
    }
    
    func getRecentTransactions(token : String,completion:@escaping(_ response : TransactionsResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        AFManager.request("\(Constants.BASE_URL)remInternalTransfer", method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
                        
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(TransactionsResponse(success: false, code: "401", message: [String](), data: [TransactionDatum]()))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(TransactionsResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        let decoders = JSONDecoder()
                        let baseResponsess = try decoders.decode(TransactionsResponse.self, from: json)
         

                        if baseResponsess.success == false{
                            completion(TransactionsResponse(success: false, code: baseResponsess.code ?? "401", message: baseResponsess.message ?? ["Something Wrong"], data:  nil))
                            
                        }else{

                        completion(baseResponsess)
                        }
                        
                    }catch let err{
                        print(err)
                        completion(TransactionsResponse(success: false, code: "100", message: [String](), data: [TransactionDatum]()))
                    }
                }
            }
    }
    
    func getAllTransactions(token : String, filter : TransactionsFilter?, tab : TransactionTabs,completion:@escaping(_ response : TransactionsResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        var params : [String : Any] = ["PageNumber" : filter?.PageNumber ?? 1,
                                       "PageSize" : 10000]
        
        if (filter?.fromInsertDate?.count ?? 0 > 0) {
            params["fromInsertDate"] = filter?.fromInsertDate ?? ""
        }
        if (filter?.toInsertDate?.count ?? 0 > 0) {
            params["toInsertDate"] = filter?.toInsertDate ?? ""
        }
        if (filter?.remittanceStatusId?.count ?? 0 > 0) {
            params["remittanceStatusId"] = filter?.remittanceStatusId ?? [Int]()
        }
        if (filter?.servicesProviderId ?? 0 > 0) {
            params["servicesProviderId"] = filter?.servicesProviderId ?? 0
        }
        if (filter?.payMethodId ?? 0 > 0) {
            params["payMethodId"] = filter?.payMethodId ?? 0
        }
        if (filter?.remittanceNumber?.count ?? 0 > 0) {
            params["remittanceNumber"] = (filter?.remittanceNumber ?? "").replacedArabicDigitsWithEnglish
        }
        if (filter?.country?.id?.count ?? 0 > 0) {
            params["countryId"] = filter?.country?.id ?? ""
        }
        
        var url = "\(Constants.BASE_URL)remInternalTransfer/GetBySearchOptions"
        
        if (tab == .received) {
            url = "\(Constants.BASE_URL)remRemittanceReceives/GetBySearchOptions"
        }
        
        AFManager.request(url, method: .get, parameters: params ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(TransactionsResponse(success: false, code: "401", message: [String](), data: [TransactionDatum]()))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(TransactionsResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        
                        let decoders = JSONDecoder()
                        let baseResponsess = try decoders.decode(TransactionsResponse.self, from: json)
         

                        if baseResponsess.success == false{
                            completion(TransactionsResponse(success: false, code: baseResponsess.code ?? "401", message: baseResponsess.message ?? ["Something Wrong"], data:  nil))
                            
                        }else{

                        completion(baseResponsess)
                        }
                        
                        
                    }catch let err{
                        print(err)
                        completion(TransactionsResponse(success: false, code: "100", message: [String](), data: [TransactionDatum]()))
                    }
                }
            }
    }
    
    
    func changePasswordUsingCurrentPassword(token : String, currentPassword : String, newPassword : String,completion:@escaping(_ response : BaseResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        let all : [String : Any] = ["CurrentPassword" : currentPassword.trim().toBase64(),
                                    "NewPassword" : newPassword.trim().toBase64(),
                                    "RepeatPassword" : newPassword.trim().toBase64()]
        
        
        AFManager.request("\(Constants.BASE_URL)custCustomers/ChangePassword", method: .post, parameters: all ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(BaseResponse(success: false, code: "401", message: [String]()))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(BaseResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        
                        let decoders = JSONDecoder()
                        let baseResponsess = try decoders.decode(BaseResponse.self, from: json)
         

                        if baseResponsess.success == false{
                            completion(BaseResponse(success: false, code: baseResponsess.code ?? "401", message: baseResponsess.message ?? ["Something Wrong"]))
                            
                        }else{

                        completion(baseResponsess)
                        }
                        
                        
                    }catch let err{
                        print(err)
                        completion(BaseResponse(success: false, code: "100", message: [String]()))
                    }
                }
            }
    }
    
    func addNewBeneficiary(token : String, firstName : String, secondName : String, thirdName : String, lastName : String, countryId : String, mobile : String,completion:@escaping(_ response : AddNewBeneficiaryResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        let all : [String : Any] = ["FirstNameEn" : firstName.trim(),
                                    "SecondNameEn" : secondName.trim(),
                                    "ThirdNameEn" : thirdName.trim(),
                                    "LastNameEn" : lastName.trim(),
                                    "CountryId" : countryId,
                                    "Mobile" : mobile.replacedArabicDigitsWithEnglish]
        
        
        AFManager.request("\(Constants.BASE_URL)Beneficiaries/AddNew", method: .post, parameters: all ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(AddNewBeneficiaryResponse(success: false, code: "401", message: [String](), data: [AddBeneDatum]()))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(AddNewBeneficiaryResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        
                        let decoders = JSONDecoder()
                        let baseResponsess = try decoders.decode(AddNewBeneficiaryResponse.self, from: json)
         

                        if baseResponsess.success == false{
                            completion(AddNewBeneficiaryResponse(success: false, code: baseResponsess.code ?? "401", message: baseResponsess.message ?? ["Something Wrong"], data:  nil))
                            
                        }else{

                        completion(baseResponsess)
                        }
                        
                        
                        
                    }catch let err{
                        print(err)
                        completion(AddNewBeneficiaryResponse(success: false, code: "100", message: [String](), data: [AddBeneDatum]()))
                    }
                }
            }
    }
    
    func updatePersonalInformation(token : String, firstNameAr : String, secondNameAr : String, thirdNameAr : String, lastNameAr : String, countryId : String, dob : String, nationalityId : String,occupationId : String ,completion:@escaping(_ response : UpdateProfileResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        let all = ["FirstNameAr" : firstNameAr,
                   "SecondNameAr" : secondNameAr,
                   "ThirdNameAr" : thirdNameAr,
                   "LastNameAr" : lastNameAr,
                   "CountryOfBirthId" : countryId,
                   "BirthOfDate" : dob.replacedArabicDigitsWithEnglish,
                   "NationalityId" : nationalityId,
                   "OccupationId" : occupationId]
        
        AFManager.request("\(Constants.BASE_URL)UpdateProfile/PersonalInformation", method: .post, parameters: all ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(UpdateProfileResponse(success: false, code: "401", message: [String](), data: nil))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(UpdateProfileResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        
                        let decoders = JSONDecoder()
                        let baseResponsess = try decoders.decode(UpdateProfileResponse.self, from: json)
         

                        if baseResponsess.success == false{
                            completion(UpdateProfileResponse(success: false, code: baseResponsess.code ?? "401", message: baseResponsess.message ?? ["Something Wrong"], data:  nil))
                            
                        }else{

                        completion(baseResponsess)
                        }
                        
                        
                    }catch let err{
                        print(err)
                        completion(UpdateProfileResponse(success: false, code: "100", message: [String](), data: nil))
                    }
                }
            }
    }
    
    func updateIdentificationDetails(token : String, idTypeId : String,idIssueCountryId : String, idNumber : String, idIssueDate : String, idExpiryDate : String, nationalNumber : String, residence : Bool, gender : Int, idFrontImage : UIImage?, idBackImage : UIImage? ,completion:@escaping(_ response : UpdateProfileResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        let all = ["IdentityTypeId" : idTypeId,
                   "IdentityIssueCountryId" : idIssueCountryId,
                   "IdentityNumber" : idNumber,
                   "IdentityIssueData" : idIssueDate.replacedArabicDigitsWithEnglish,
                   "IdentityExpireDate" : idExpiryDate.replacedArabicDigitsWithEnglish,
                   "NationalNumber" : nationalNumber.replacedArabicDigitsWithEnglish,
                   "IdentityFrontImage" : idFrontImage?.toBase64() ?? "",
                   "IdentityBackImage" : idBackImage?.toBase64() ?? ""]
        
        AFManager.request("\(Constants.BASE_URL)UpdateProfile/IdentificationDetails", method: .post, parameters: all ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(UpdateProfileResponse(success: false, code: "401", message: [String](),data: nil))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(UpdateProfileResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        
                        
                        let decoders = JSONDecoder()
                        let baseResponsess = try decoders.decode(UpdateProfileResponse.self, from: json)
         

                        if baseResponsess.success == false{
                            completion(UpdateProfileResponse(success: false, code: baseResponsess.code ?? "401", message: baseResponsess.message ?? ["Something Wrong"], data:  nil))
                            
                        }else{

                        completion(baseResponsess)
                        }
                        
                        

                    }catch let err{
                        print(err)
                        completion(UpdateProfileResponse(success: false, code: "100", message: [String](), data: nil))
                    }
                }
            }
    }
    
    
    func updateContactInformation(token : String, countryId : String, city : String, street : String, building : String, address : String, phone : String, faceImage : UIImage? ,completion:@escaping(_ response : UpdateProfileResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        let all = ["CountryId" : countryId,
                   "City" : city,
                   "Street" : street,
                   "Building" : building,
                   "Address" : address,
                   "Phone" : phone.replacedArabicDigitsWithEnglish,
                   "YouImage" : faceImage?.toBase64() ?? ""]
        
        AFManager.request("\(Constants.BASE_URL)UpdateProfile/ContactInformation", method: .post, parameters: all ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(UpdateProfileResponse(success: false, code: "401", message: [String](), data: nil))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(UpdateProfileResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        
                        let decoders = JSONDecoder()
                        let baseResponsess = try decoders.decode(UpdateProfileResponse.self, from: json)
         

                        if baseResponsess.success == false{
                            completion(UpdateProfileResponse(success: false, code: baseResponsess.code ?? "401", message: baseResponsess.message ?? ["Something Wrong"], data:  nil))
                            
                        }else{

                        completion(baseResponsess)
                        }
                        
                        
                    }catch let err{
                        print(err)
                        completion(UpdateProfileResponse(success: false, code: "100", message: [String](), data: nil))
                    }
                }
            }
    }
    
    
    func getMailCounts(token : String,completion:@escaping(_ response : MailCountResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        AFManager.request("\(Constants.BASE_URL)custCustomersEmailsRequest/GetCount", method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(MailCountResponse(success: false, code: "401", message: [String](), data: nil))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(MailCountResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        
                        let decoders = JSONDecoder()
                        let baseResponsess = try decoders.decode(MailCountResponse.self, from: json)
         

                        if baseResponsess.success == false{
                            completion(MailCountResponse(success: false, code: baseResponsess.code ?? "401", message: baseResponsess.message ?? ["Something Wrong"], data:  nil))
                            
                        }else{

                        completion(baseResponsess)
                        }
                        
                    }catch let err{
                        print(err)
                        completion(MailCountResponse(success: false, code: "100", message: [String](), data: nil))
                    }
                }
            }
    }
    
    func getMails(token : String,completion:@escaping(_ response : MailsResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        AFManager.request("\(Constants.BASE_URL)custCustomersEmailsRequest", method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(MailsResponse(success: false, code: "401", message: [String](), data: [MailDatum]()))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(MailsResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        
                        let decoders = JSONDecoder()
                        let baseResponsess = try decoders.decode(MailsResponse.self, from: json)
         

                        if baseResponsess.success == false{
                            completion(MailsResponse(success: false, code: baseResponsess.code ?? "401", message: baseResponsess.message ?? ["Something Wrong"], data:  nil))
                            
                        }else{

                        completion(baseResponsess)
                        }
                        
                    }catch let err{
                        print(err)
                        completion(MailsResponse(success: false, code: "100", message: [String](), data: [MailDatum]()))
                    }
                }
            }
    }
    
    
    func contactUs(token : String, name : String, phone : String, email : String, message : String ,completion:@escaping(_ response : BaseResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        let all = ["CustomerName" : name,
                   "CustomerPhone" : phone.replacedArabicDigitsWithEnglish,
                   "CustomerEmail" : email,
                   "MessageBody" : message]
        
        AFManager.request("\(Constants.BASE_URL)custContactUs", method: .post, parameters: all ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(BaseResponse(success: false, code: "401", message: [String]()))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(BaseResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        let decoders = JSONDecoder()
                        let baseResponsess = try decoders.decode(BaseResponse.self, from: json)
         

                        if baseResponsess.success == false{
                            completion(BaseResponse(success: false, code: baseResponsess.code ?? "401", message: baseResponsess.message ?? ["Something Wrong"]))
                            
                        }else{

                        completion(baseResponsess)
                        }

                        
                    }catch let err{
                        print(err)
                        completion(BaseResponse(success: false, code: "100", message: [String]()))
                    }
                }
            }
    }
    
    
    func ammendmentRequest(token : String, firstNameEn : String, secondNameEn : String, thirdNameEn : String, lastNameEn : String, mobile : String, remittanceId : String, reasonId : String, isSend : Bool,completion:@escaping(_ response : AddNewBeneficiaryResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        var isSendStr = "false"
        if (isSend) {
            isSendStr = "true"
        }
        let all = ["FirstName" : firstNameEn.trim(),
                   "SecondName" : secondNameEn.trim(),
                   "ThirdName" : thirdNameEn.trim(),
                   "LastName" : lastNameEn.trim(),
                   "RemittanceId" : remittanceId,
                   "Reason" : reasonId,
                   "IsSend" : isSendStr]
        
        AFManager.request("\(Constants.BASE_URL)Remittance/Amend", method: .post, parameters: all ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(AddNewBeneficiaryResponse(success: false, code: "401", message: [String](), data : nil))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(AddNewBeneficiaryResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        let decoders = JSONDecoder()
                        let baseResponsess = try decoders.decode(AddNewBeneficiaryResponse.self, from: json)
         

                        if baseResponsess.success == false{
                            completion(AddNewBeneficiaryResponse(success: false, code: baseResponsess.code ?? "401", message: baseResponsess.message ?? ["Something Wrong"], data: nil))
                            
                        }else{

                        completion(baseResponsess)
                        }
                        
                    }catch let err{
                        print(err)
                        completion(AddNewBeneficiaryResponse(success: false, code: "100", message: [String](), data : nil))
                    }
                }
            }
    }
    
    func cancelRequest(token : String, remittanceId : String, reasonId : String, isSend : Bool ,completion:@escaping(_ response : AddNewBeneficiaryResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        var isSendStr = "false"
        if (isSend) {
            isSendStr = "true"
        }
        
        let all = ["RemittanceId" : remittanceId,
                   "Reason" : reasonId,
                   "IsSend" : isSendStr]
        
        AFManager.request("\(Constants.BASE_URL)Remittance/Cancel", method: .post, parameters: all ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(AddNewBeneficiaryResponse(success: false, code: "401", message: [String](), data : nil))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(AddNewBeneficiaryResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        
                        let decoders = JSONDecoder()
                        let baseResponsess = try decoders.decode(AddNewBeneficiaryResponse.self, from: json)
         

                        if baseResponsess.success == false{
                            completion(AddNewBeneficiaryResponse(success: false, code: baseResponsess.code ?? "401", message: baseResponsess.message ?? ["Something Wrong"], data: nil))
                            
                        }else{

                        completion(baseResponsess)
                        }
                        
                        
                        
                    }catch let err{
                        print(err)
                        completion(AddNewBeneficiaryResponse(success: false, code: "100", message: [String](), data : nil))
                    }
                }
            }
    }
    
    
    func getAvailableSendAmount(token : String,completion:@escaping(_ response : AvailableAmountsResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        AFManager.request("\(Constants.BASE_URL)custCustomers/GetAvailableSendAmount", method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(AvailableAmountsResponse(success: false, code: "401", message: [String](), data: 0.0))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(AvailableAmountsResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        
                        let decoders = JSONDecoder()
                        let baseResponsess = try decoders.decode(AvailableAmountsResponse.self, from: json)
         

                        if baseResponsess.success == false{
                            completion(AvailableAmountsResponse(success: false, code: baseResponsess.code ?? "401", message: baseResponsess.message ?? ["Something Wrong"], data: 0.0))
                            
                        }else{

                        completion(baseResponsess)
                        }
                        
                        
                    }catch let err{
                        print(err)
                        completion(AvailableAmountsResponse(success: false, code: "100", message: [String](), data: 0.0))
                    }
                }
            }
    }
    
    func getAvailableReceiveAmount(token : String,completion:@escaping(_ response : AvailableAmountsResponse)-> Void) {
        
        var headers = self.getDefaultHeaders()
        headers["Authorization"] = "Bearer \(token)"
        
        AFManager.request("\(Constants.BASE_URL)custCustomers/GetAvailableReceiveAmount", method: .get, parameters: nil ,encoding: URLEncoding(), headers: headers)
            .responseJSON { response in
                if let json = response.data {
                    do {
//                        let statusCode = response.response?.statusCode
//                        if (statusCode == 401) {
//                            completion(AvailableAmountsResponse(success: false, code: "401", message: [String](), data: 0.0))
//                        }else {
//                            let decoder = JSONDecoder()
//                            let baseResponse = try decoder.decode(AvailableAmountsResponse.self, from: json)
//                            completion(baseResponse)
//                        }
                        
                        let decoders = JSONDecoder()
                        let baseResponsess = try decoders.decode(AvailableAmountsResponse.self, from: json)
         

                        if baseResponsess.success == false{
                            completion(AvailableAmountsResponse(success: false, code: baseResponsess.code ?? "401", message: baseResponsess.message ?? ["Something Wrong"], data: 0.0))
                            
                        }else{

                        completion(baseResponsess)
                        }
                        
                        
                    }catch let err{
                        print(err)
                        completion(AvailableAmountsResponse(success: false, code: "100", message: [String](), data: 0.0))
                    }
                }
            }
    }
    
    
    func getStringFromDate(date : Date, outputFormat : String) -> String {
        let dateFinal = date.toFormat(outputFormat)
        return dateFinal
    }
    
    func getDateFromString(dateStr : String) -> Date {
        return dateStr.toDate()?.date ?? Date()
    }
    
    var bundleID = Bundle.main.bundleIdentifier
    var uuidValue = UIDevice.current.identifierForVendor!.uuidString
    
    func setVenderId() {
        let keychain = Keychain(service: bundleID!)
        
        do {
            try keychain.set(uuidValue as String, key: bundleID!)
        }
        catch let error {
            print("Could not save data in Keychain : \(error)")
        }
    }
    
    func getVenderId() -> String {
        var token : String = ""
        let keychain = Keychain(service: bundleID!)
        if(try! keychain.get(bundleID!) != nil){
            token = try! keychain.get(self.bundleID!)!
        }else {
            setVenderId()
            DispatchQueue.main.async(execute: {
                token = try! keychain.get(self.bundleID!)!
            })
        }
        print(token)
        return token
        //return token
    }
    
}

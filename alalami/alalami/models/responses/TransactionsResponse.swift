//
//  TransactionsResponse.swift
//  alalami
//
//  Created by Zaid Khaled on 9/27/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation

// MARK: - TransactionsResponse
struct TransactionsResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: [TransactionDatum]?
}

// MARK: - Datum
struct TransactionDatum: Codable {
    let id: String?
    let code, remittanceStatusID: Int?
    let remittanceStatusName, remittanceNo, remittanceRefNo, remittanceConfirmNo: String?
    let servicesProviderID, servicesProviderName, destinationCountryID, destinationCountryName: String?
    let destinationBranchID, destinationBranchName: String?
    let amount: Double?
    let feeTypeID: Int?
    let feeTypeName: String?
    let sendAmount, feesAmount, expectedAmount, amountToBeReceived: Double?
    let promotionCode, senderID, senderFirstNameAr, senderSecondNameAr: String?
    let senderThirdNameAr, senderLastNameAr, senderFirstNameEn, senderSecondNameEn: String?
    let senderThirdNameEn, senderLastNameEn, senderEmailAddress, senderCountry: String?
    let senderCity, senderStreet, senderBuilding, senderAddress: String?
    let senderNationalNumber, senderIdentityType, senderIdentityNumber, senderIdentityIssueCountry: String?
    let senderIdentityIssuePlace, senderIdentityIssueData, senderIdentityExpireDate, senderResident: String?
    let senderPlaceOfBirth, senderBirthOfDate, senderCountryOfBirth, senderPhone: String?
    let senderMobile, senderNationality, senderOccupation, receiverID: String?
    let receiverFullNameAr, receiverFullNameEn, receiverFirstNameAr, receiverSecondNameAr: String?
    let receiverThirdNameAr, receiverLastNameAr, receiverFirstNameEn, receiverSecondNameEn: String?
    let receiverThirdNameEn, receiverLastNameEn, receiverEmailAddress, receiverCountry: String?
    let receiverCity, receiverStreet, receiverBuilding, receiverAddress: String?
    let receiverNationalNumber, receiverIdentityType, receiverIdentityNumber, receiverIdentityIssueCountry: String?
    let receiverIdentityIssuePlace, receiverIdentityIssueData, receiverIdentityExpireDate, receiverResident: String?
    let receiverPlaceOfBirth, receiverBirthOfDate, receiverCountryOfBirth, receiverPhone: String?
    let receiverMobile, receiverNationality, receiverOccupation, purposeOfTransferID: String?
    let purposeOfTransferName, sourceOfFundsID, sourceOfFundsName, supportedDocument: String?
    let relationToReceiverID, relationToReceiverName: String?
    let payMethodID: Int?
    let payMethodName, eFAWATEERcomBillingNumber, eFAWATEERcomPaidDate: String?
   // let eFAWATEERcomIsPaid : String?
    let eFAWATEERcomPaidRequestID, eFAWATEERcomPaidRequestInternalID: String?
    let eFAWATEERcomTotalAmount, eFAWATEERcomFeeAmount: Double?
    let dtdSenderCity, dtdSenderRegion, dtdSenderStreet, dtdSenderBuildingName: String?
    let dtdSenderBuildingNumber, dtdSenderAppartment, dtdSenderAddressFree, dtdReceiverCity: String?
    let dtdReceiverRegion, dtdReceiverStreet, dtdReceiverBuildingName, dtdReceiverBuildingNumber: String?
    let dtdReceiverAppartment, dtdReceiverAddressFree, walletProviderID, walletProviderName: String?
    let walletNumber: String?
    let isPaid: Bool?
    let paidDate, paidBy, moneyGramRefNo, moneyGramConfirmNo: String?
    let moneyGramConfirmedDate, moneyGramConfirmedBy: String?
    let moneyGramAmount, moneyGramSendFees: Double?
    let insertDate: String?
    let amountCurrency, sendAmountCurrency, amountToBeReceivedCurrency: String?
    let senderFullName : String?
    
    let accountNumber, bankName, iban, expectedAmountCurrency : String?
    let payoutMethodName : String?
    let requestRemittanceNumber : String?
    let fromCountryName : String?
    let senderCountryNameAr, senderCountryNameEn : String?
    let receiverCountryNameAr, receiverCountryNameEn: String?

    enum CodingKeys: String, CodingKey {
        case receiverCountryNameAr, receiverCountryNameEn
        case senderCountryNameAr, senderCountryNameEn
        case expectedAmount = "expectedAmount"
        case senderFullName = "senderFullName"
        case accountNumber = "accountNumber"
        case bankName = "bankName"
        case iban = "iban"
        case expectedAmountCurrency = "expectedAmountCurrency"
        case payoutMethodName = "payoutMethodName"
        case requestRemittanceNumber = "requestRemittanceNumber"
        case fromCountryName = "fromCountryName"
        
        case amountCurrency, sendAmountCurrency, amountToBeReceivedCurrency
        case id, code
        case remittanceStatusID = "remittanceStatusId"
        case remittanceStatusName, remittanceNo, remittanceRefNo, remittanceConfirmNo
        case servicesProviderID = "servicesProviderId"
        case servicesProviderName
        case destinationCountryID = "destinationCountryId"
        case destinationCountryName
        case destinationBranchID = "destinationBranchId"
        case destinationBranchName, amount
        case feeTypeID = "feeTypeId"
        case feeTypeName, sendAmount, feesAmount, amountToBeReceived, promotionCode
        case senderID = "senderId"
        case senderFirstNameAr, senderSecondNameAr, senderThirdNameAr, senderLastNameAr, senderFirstNameEn, senderSecondNameEn, senderThirdNameEn, senderLastNameEn, senderEmailAddress, senderCountry, senderCity, senderStreet, senderBuilding, senderAddress, senderNationalNumber, senderIdentityType, senderIdentityNumber, senderIdentityIssueCountry, senderIdentityIssuePlace, senderIdentityIssueData, senderIdentityExpireDate, senderResident, senderPlaceOfBirth, senderBirthOfDate, senderCountryOfBirth, senderPhone, senderMobile, senderNationality, senderOccupation
        case receiverID = "receiverId"
        case receiverFullNameAr, receiverFullNameEn, receiverFirstNameAr, receiverSecondNameAr, receiverThirdNameAr, receiverLastNameAr, receiverFirstNameEn, receiverSecondNameEn, receiverThirdNameEn, receiverLastNameEn, receiverEmailAddress, receiverCountry, receiverCity, receiverStreet, receiverBuilding, receiverAddress, receiverNationalNumber, receiverIdentityType, receiverIdentityNumber, receiverIdentityIssueCountry, receiverIdentityIssuePlace, receiverIdentityIssueData, receiverIdentityExpireDate, receiverResident, receiverPlaceOfBirth, receiverBirthOfDate, receiverCountryOfBirth, receiverPhone, receiverMobile, receiverNationality, receiverOccupation
        case purposeOfTransferID = "purposeOfTransferId"
        case purposeOfTransferName
        case sourceOfFundsID = "sourceOfFundsId"
        case sourceOfFundsName, supportedDocument
        case relationToReceiverID = "relationToReceiverId"
        case relationToReceiverName
        case payMethodID = "payMethodId"
        case payMethodName, eFAWATEERcomBillingNumber, eFAWATEERcomPaidDate
      //  case eFAWATEERcomIsPaid
        case eFAWATEERcomPaidRequestID = "eFAWATEERcomPaidRequestId"
        case eFAWATEERcomPaidRequestInternalID = "eFAWATEERcomPaidRequestInternalId"
        case eFAWATEERcomTotalAmount, eFAWATEERcomFeeAmount, dtdSenderCity, dtdSenderRegion, dtdSenderStreet, dtdSenderBuildingName, dtdSenderBuildingNumber, dtdSenderAppartment, dtdSenderAddressFree, dtdReceiverCity, dtdReceiverRegion, dtdReceiverStreet, dtdReceiverBuildingName, dtdReceiverBuildingNumber, dtdReceiverAppartment, dtdReceiverAddressFree
        case walletProviderID = "walletProviderId"
        case walletProviderName, walletNumber, isPaid, paidDate, paidBy, moneyGramRefNo, moneyGramConfirmNo, moneyGramConfirmedDate, moneyGramConfirmedBy, moneyGramAmount, moneyGramSendFees
        case insertDate = "insertDate"
    }
}

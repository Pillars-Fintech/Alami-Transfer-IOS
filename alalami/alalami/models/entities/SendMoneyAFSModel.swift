//
//  SendMoneyAFSModel.swift
//  alalami
//
//  Created by Zaid Khaled on 9/13/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation
class SendMoneyAFSModel: NSObject {
    
    //service provider
    var serviceProviderId : String?
    
    //step1
    var destinationCountry : CountryDatum?
    var amount : String?
    var feeType : Int?
    var sendCurrency : String?
    var receiveCurrency : String?
    var alamiBranch : BranchDatum?
    var purpose : ReasonOfTransferDatum?
    var sourceOfFunds : SourceOfFundsDatum?
    var relationship : RelationToReceiverDatum?
    var promotionCode : String?
    
    //-----
    
    //step3
    var selectedBeneficiary : BeneficiaryDatum?
    //-----
    
    //step4
    var payInOption : PayInMethodDatum?
    //door to door
    var senderRegion : String?
    var senderCity: String?
    var senderStreet : String?
    var senderBuildingName: String?
    var senderBuildingNumber: String?
    var senderApartment: String?
    var senderAddress: String?
    var ReceiverRegion : String?
    var ReceiverCity: String?
    var ReceiverStreet : String?
    var ReceiverBuildingName: String?
    var ReceiverBuildingNumber: String?
    var ReceiverApartment: String?
    var ReceiverAddress: String?
    //eWallet
    var walletProvider : WalletProviderDatum?
    var walletNumber : String?
    //-------
    
    
    
    //step5
    var afsGuid: String?
    var otpCode : String?
    //-------
    
}

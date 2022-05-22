//
//  ReceiveMoneyModel.swift
//  alalami
//
//  Created by Zaid Khaled on 9/16/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation
class ReceiveMoneyModel : NSObject {
    
    //selected service provider
    var serviceProviderId : String?
    
    //step1
    var remittanceNo : String?
    var selectedPurpose : RCVReasonOfTransfer?
    var selectedRelationship : RCVRelationship?
    //----
    
    //step2
    var payoutOption : PayOutMethodDatum?
    //door to door
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
    //bank
    var selectedBank : BankDatum?
    var IBAN : String?
    var accountNumber : String?
    //-------
    
    //-------
    var rcvGuid : String?
    var otpCode : String?
    
    
    
    
    
    
    
    //daman
    var requestRemittanceNumber:String?
    var damanPAYNO:String?
    var damanServiceType:String?
    var reqtype:String?
    var payoutMethodId:String?
    
    
    

    
    
    
}

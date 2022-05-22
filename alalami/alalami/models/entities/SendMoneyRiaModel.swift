//
//  SendMoneyRiaModel.swift
//  alalami
//
//  Created by Osama Abu Hdba on 13/11/2021.
//  Copyright © 2021 technzone. All rights reserved.
//

import Foundation
import UIKit

class SendMoneyRiaModel: NSObject {
    
    //service provider
    var serviceProviderId : String?
    
    //step1
    var destinationCountry : MGCountryDatum?
    var feeType : Int?
    var amount : Double?
    var promotionCode : String?
    var isSend : Bool?
    //-------
    
    
    
    //step2
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
    
    
    
    
    //step3
    var selectedServiceOption : MoneyGramServiceOptionsDatum?
    //-------
    
    
    
    //step4
    var selectedReasonOfTransfer : MGReasonOfTransferDatum?
    var selectedRelationship : MGRelationToReceiverDatum?
    var selectedSourceOfFund : MGSourceOfFundsDatum?
    var supportDocument : UIImage?
    //-------
    
    
    //step5
    var dynamicFields = [DynamicFieldDatum]()
        //receiver
    var receiverFirstName: String?
    var receiverSecondName: String?
    var receiverThirdName: String?
    var receiverLastName: String?
    //-------
    
    
    //step6
    var sendAmount: Double?
    var feeAmount: Double?
    var amountToBeReceived: Double?
    
    var eFawatercomTotalAmount: Double?
    var eFawatercomFeeAmount: Double?
    var moneyGramAmount: Double?
    var moneyGramSendFees: Double?
    
    var otpCode : String?
    //-------
}

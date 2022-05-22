//
//  App.swift
//  alalami
//
//  Created by Zaid Khaled on 9/1/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation
import CoreFoundation

class App: NSObject {
    //notifications
    var notificationType: String?
    var notificationValue: String?
    
    //dashboard vals
    var availableSendAmount : Double?
    var availableReceiveAmount : Double?
    
    var config : ConfigClass?
    var remittanceSettings : [RemittanceSettingsDatum]?
    var registerModel : RegisterModel?
    var access_token : String?
    
    //sending money
    var sendMoneyMG : SendMoneyMGModel?
    var sendMoneyAFS : SendMoneyAFSModel?
    
    //-----
    
    //receive money
    var receiveMoney: ReceiveMoneyModel?
    
    var receiveMonesy: ReceiveMoneyModel?


    //-----
    
    var accountInfo : AcountInfoClass?
    
    // MARK:- Singleton
    static var shared : App = {
        let instance = App()
        return instance
    }()
    
}

//
//  TransactionsFilter.swift
//  alalami
//
//  Created by Zaid Khaled on 9/30/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation
class TransactionsFilter : NSObject {
    var fromInsertDate : String?
    var toInsertDate : String?
    var country : CountryDatum?
    var PageNumber : Int?
    var remittanceStatusId: [Int]?
    var servicesProviderId: Int?
    var payMethodId: Int?
    var remittanceNumber: String?
}

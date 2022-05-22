//
//  DamanServiceTypeResponse.swift
//  alalami
//
//  Created by Pillars Fintech on 28/04/2022.
//  Copyright © 2022 technzone. All rights reserved.
//

import Foundation



struct DamanServiceTypeResponse: Codable {
    let success: Bool?
    let code: String?
    let message: [String]?
    let data: [DamanServiceType]?
}

struct DamanServiceType: Codable {

    
    let SERVICE:Int
    let SERVICE_DESC:String
    let SERVICE_ENG_DESC:String
    let TYPE:Int
    

    enum CodingKeys: String, CodingKey {
        case SERVICE = "SERVICE"
        case SERVICE_DESC = "SERVICE_DESC"
        case SERVICE_ENG_DESC = "SERVICE_ENG_DESC"
        case TYPE = "TYPE"

    }
    
    
    
}

//
//  PayInBranchCell.swift
//  alalami
//
//  Created by Zaid Khaled on 9/7/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit

class PayInBranchCell: UITableViewCell {

    @IBOutlet weak var lblTitle: MyUILabel!
    
    @IBOutlet weak var lblAddress: MyUILabel!
    
    @IBOutlet weak var btnNavigate: UIButton!
    
    @IBOutlet weak var lblPhone: MyUILabel!
    
    @IBOutlet weak var lblFax: MyUILabel!
    
    var onNavigate : (() -> Void)? = nil
    @IBAction func navigateAction(_ sender: Any) {
        if let onNavigate = self.onNavigate {
            onNavigate()
        }
    }
    
}

//
//  DynamicBooleanCell.swift
//  alalami
//
//  Created by Zaid Khaled on 9/9/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit

class DynamicBooleanCell: UITableViewCell {

    @IBOutlet weak var lblTitle: MyUILabel!
    
    @IBOutlet weak var ivYes: UIImageView!
    @IBOutlet weak var lblYes: MyUILabel!
    
    @IBOutlet weak var lblNo: MyUILabel!
    @IBOutlet weak var ivNo: UIImageView!
    
    var selectedValue = false
    var field : DynamicFieldDatum?
    
    func setup(field : DynamicFieldDatum) {
        if (field.isMand ?? false) {
            self.lblTitle.text = "\(field.label ?? "") *"
        }else {
            self.lblTitle.text = field.label ?? ""
        }
    }
    
    @IBAction func selectYes(_ sender: Any) {
        self.yesUI()
    }
    
    @IBAction func selectNo(_ sender: Any) {
        self.noUI()
    }
    
    func yesUI() {
        self.ivYes.image = UIImage(named: "ic_language_selected")
        self.ivNo.image = UIImage(named: "ic_language_unselected")
        self.selectedValue = true
    }
    
    func noUI() {
        self.ivYes.image = UIImage(named: "ic_language_unselected")
        self.ivNo.image = UIImage(named: "ic_language_selected")
        self.selectedValue = false
    }
    
}

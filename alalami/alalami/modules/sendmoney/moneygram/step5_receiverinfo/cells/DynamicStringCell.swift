//
//  DynamicStringCell.swift
//  alalami
//
//  Created by Zaid Khaled on 9/9/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit

class DynamicStringCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: MyUILabel!
    
    @IBOutlet weak var cvField: CardView!
    
    @IBOutlet weak var fieldContent: MyUITextField!
    
    var delegate : ValidateDynamicProtocol?
    
    var field : DynamicFieldDatum?
    
    
    func setup(field : DynamicFieldDatum) {
        if (field.isMand ?? false) {
            self.lblTitle.text = "\(field.label ?? "") *"
        }else {
            self.lblTitle.text = field.label ?? ""
        }
        self.fieldContent.text = field.defaultValue ?? ""
        self.fieldContent.placeholder = ""
        self.fieldContent.delegate = self
    }
    
    func setUp() {
        self.fieldContent.delegate = self
    }
    
}

extension DynamicStringCell : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.fieldContent) {
            self.cvField.backgroundColor = UIColor.card_focused_color
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == self.fieldContent) {
            self.cvField.backgroundColor = UIColor.card_color
            self.delegate?.validateFieldsTriggered()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == self.fieldContent) {
            self.fieldContent.resignFirstResponder()
        }
        return false
    }
    
}

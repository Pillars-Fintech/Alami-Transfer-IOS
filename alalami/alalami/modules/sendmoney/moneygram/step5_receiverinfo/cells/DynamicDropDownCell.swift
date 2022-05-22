//
//  DynamicDropDownCell.swift
//  alalami
//
//  Created by Zaid Khaled on 9/9/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit
import DropDown

class DynamicDropDownCell: UITableViewCell {

    @IBOutlet weak var lblTitle: MyUILabel!
    
    @IBOutlet weak var cvField: CardView!
    
    var delegate : ValidateDynamicProtocol?
    
    
    
    @IBOutlet weak var fieldContent: MyUITextField!
    var dropItems = [FieldsForProductEnumDetail]()
    var itemsDropDown : DropDown?
    var selectedItem : FieldsForProductEnumDetail?
    
    var field : DynamicFieldDatum?
    
    @IBAction func selectAction(_ sender: Any) {
        self.itemsDropDown?.show()
    }
    
    func setup(field : DynamicFieldDatum) {
        if (field.isMand ?? false) {
            self.lblTitle.text = "\(field.label ?? "") *"
        }else {
            self.lblTitle.text = field.label ?? ""
        }
        self.dropItems.removeAll()
        self.dropItems.append(contentsOf: field.fieldsForProductEnumDetails ?? [FieldsForProductEnumDetail]())
        
        self.itemsDropDown = DropDown()
        self.itemsDropDown?.anchorView = self.cvField
        var arr = [String]()
        for item in self.dropItems {
            arr.append(item.label ?? "")
        }
        self.itemsDropDown?.dataSource = arr
        
        self.itemsDropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectedItem = self.dropItems[index]
            self.fieldContent.text = self.selectedItem?.label ?? ""
            self.cvField.backgroundColor = UIColor.card_color
            self.delegate?.validateFieldsTriggered()
        }
    }
    
}

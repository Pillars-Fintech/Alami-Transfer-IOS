//
//  DynamicCountryCell.swift
//  alalami
//
//  Created by Zaid Khaled on 9/9/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit
import DropDown

class DynamicCountryCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: MyUILabel!
    
    @IBOutlet weak var cvField: CardView!
    
    @IBOutlet weak var ivField: UIImageView!
    
    @IBOutlet weak var fieldContent: MyUITextField!
    var itemsDropDown : DropDown?
    
    var delegate : ValidateDynamicProtocol?
    
    var countries = [MGCountryDatum]()
    var selectedCountry : MGCountryDatum?
    
    var field : DynamicFieldDatum?
    
    @IBAction func selectAction(_ sender: Any) {
        self.itemsDropDown?.show()
    }
    
    func setup(field : DynamicFieldDatum, countries : [MGCountryDatum]) {
        self.countries.removeAll()
        self.countries.append(contentsOf: countries)
        
        if (field.isMand ?? false) {
            self.lblTitle.text = "\(field.label ?? "") *"
        }else {
            self.lblTitle.text = field.label ?? ""
        }
        
        self.itemsDropDown = DropDown()
        self.itemsDropDown?.anchorView = self.cvField
        var arr = [String]()
        for item in self.countries {
            arr.append(item.countryName ?? "")
        }
        self.itemsDropDown?.dataSource = arr
        
        self.itemsDropDown?.cellNib = UINib(nibName: "ImageDropDownCell", bundle: nil)
        
        self.itemsDropDown?.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
           guard let cell = cell as? ImageDropDownCell else { return }
            let url = URL(string: "\(Constants.IMAGE_URL)\(self.countries[index].flag ?? "")")
            cell.ivLogo.kf.setImage(with: url, placeholder: UIImage(named: ""))
        }
        
        self.itemsDropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectedCountry = self.countries[index]
            self.fieldContent.text = self.selectedCountry?.countryName ?? ""
            let url = URL(string: "\(Constants.IMAGE_URL)\(self.selectedCountry?.flag ?? "")")
            self.ivField.kf.setImage(with: url, placeholder: UIImage(named: ""))
            self.delegate?.validateFieldsTriggered()
            self.cvField.backgroundColor = UIColor.card_color
        }
    }
}

//
//  DynamicDateTimeCell.swift
//  alalami
//
//  Created by Zaid Khaled on 9/9/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit
import DatePickerDialog

class DynamicDateTimeCell: UITableViewCell {

    @IBOutlet weak var lblTitle: MyUILabel!
    
    @IBOutlet weak var cvField: CardView!
    
    @IBOutlet weak var fieldContent: MyUITextField!
    
    var delegate : ValidateDynamicProtocol?
    
    var field : DynamicFieldDatum?
    var selectedDate : String = ""

    @IBAction func selectAction(_ sender: Any) {
        self.showDatePicker()
    }
    
    func setup(field : DynamicFieldDatum) {
        if (field.isMand ?? false) {
            self.lblTitle.text = "\(field.label ?? "") *"
        }else {
            self.lblTitle.text = field.label ?? ""
        }
    }
    
    func showDatePicker() {
        let maxDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())!
        let picker = DatePickerDialog()
        if #available(iOS 13.4, *) {
            picker.datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        picker.show(self.field?.label ?? "", doneButtonTitle: "done".localized, cancelButtonTitle: "cancel".localized, defaultDate: maxDate, minimumDate: "01/01/1950".toDate()!.date, maximumDate: maxDate, datePickerMode: .date) { (date) in
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            let year = formatter.string(from: date ?? Date())
            formatter.dateFormat = "MM"
            let month = formatter.string(from: date ?? Date())
            formatter.dateFormat = "dd"
            let day = formatter.string(from: date ?? Date())
            
            let selectedDate = "\(day)/\(month)/\(year)"
            self.fieldContent.text = selectedDate
            self.delegate?.validateFieldsTriggered()
            self.cvField.backgroundColor = UIColor.card_color
            self.selectedDate = self.getStringFromDate(date: date ?? Date(), outputFormat: Constants.DATE_FORMATS.api_date)
        }
    }
    
    func getStringFromDate(date : Date, outputFormat : String) -> String {
        let dateFinal = date.toFormat(outputFormat)
        return dateFinal
    }
    
}

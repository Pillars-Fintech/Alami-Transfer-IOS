//
//  FilterVC.swift
//  alalami
//
//  Created by Zaid Khaled on 10/11/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit
import TagListView
import DatePickerDialog

protocol TransactionFilterDelegate {
    func onApply(filter : TransactionsFilter?)
    func onClear()
}
class FilterVC: BaseVC, TagListViewDelegate {
    
    @IBOutlet weak var btnBack: UIButton!
    
    var dateDest = 1
    
    var delegate : TransactionFilterDelegate?
    
    //from date
    @IBOutlet weak var cvFromDate: CardView!
    @IBOutlet weak var fieldFromDate: MyUITextField!
    var selectedFromDate = ""
    
    //to date
    @IBOutlet weak var cvToDate: CardView!
    @IBOutlet weak var fieldToDate: MyUITextField!
    var selectedToDate = ""
    
    //reference number
    @IBOutlet weak var cvReferenceNumber: CardView!
    @IBOutlet weak var fieldReferenceNumber: MyUITextField!
    
    //country
    @IBOutlet weak var fieldCountry: MyUITextField!
    @IBOutlet weak var cvCountry: CardView!
    @IBOutlet weak var ivCountry: UIImageView!
    var selectedCountry : CountryDatum?
    
    //tags
    var tags = [StatusFilterItem]()
    @IBOutlet weak var statusTagsView: TagListView!
    @IBOutlet weak var viewTagsHeight: NSLayoutConstraint!
    
    
    //actions
    @IBOutlet weak var cvClear: CardView!
    @IBOutlet weak var btnClear: MyUIButton!
    
    @IBOutlet weak var cvApply: CardView!
    @IBOutlet weak var btnApply: MyUIButton!
    
    //filter obj
    var filter : TransactionsFilter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
        }
        
        self.fieldReferenceNumber.delegate = self
        
        self.tags.append(contentsOf: Constants.getFilterTransactionStatuses())
        
        for selectedTag in self.filter?.remittanceStatusId ?? [Int]() {
            for tag in self.tags {
                if (tag.value == selectedTag) {
                    tag.isChecked = true
                }
            }
        }
        
        self.fillPassedFilter()
        
        statusTagsView.textFont = UIFont(name: self.getFontName(type: Constants.FONT_TYPE.medium), size: 12.0)!
        self.statusTagsView.delegate = self
        
        for tag in self.tags {
           let tagView = self.statusTagsView.addTag(tag.title ?? "")
            if (tag.isChecked ?? false) {
                tagView.isSelected = true
            }
        }
        self.viewTagsHeight.constant = (self.statusTagsView.intrinsicContentSize.height) + 50
        
    }
    
    func fillPassedFilter() {
        if (self.filter != nil) {
            self.selectedFromDate = self.filter?.fromInsertDate ?? ""
            self.fieldFromDate.text = self.getStringDateWithFormat(dateStr: self.filter?.fromInsertDate ?? "", outputFormat: Constants.DATE_FORMATS.dd_mm_yyyy)
            
            self.selectedToDate = self.filter?.toInsertDate ?? ""
            self.fieldToDate.text = self.getStringDateWithFormat(dateStr: self.filter?.toInsertDate ?? "", outputFormat: Constants.DATE_FORMATS.dd_mm_yyyy)
            
            self.fieldReferenceNumber.text = (self.filter?.remittanceNumber ?? "").replacedArabicDigitsWithEnglish
            
            self.fieldCountry.text = self.filter?.country?.name ?? ""
            self.selectedCountry = self.filter?.country
            
            for tag in self.tags {
                for passedTagIds in self.filter?.remittanceStatusId ?? [Int]() {
                    if (tag.value ?? 0 == passedTagIds) {
                        tag.isChecked = true
                    }
                }
            }
        }
    }
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        for tag in self.tags {
            if(tag.title == title) {
                tag.isChecked = !(tag.isChecked ?? false)
                if (tag.isChecked ?? false) {
                    tagView.tagBackgroundColor = UIColor.tag_selected
                    tagView.textColor = UIColor.white
                    tagView.isSelected = true
                }else {
                    tagView.tagBackgroundColor = UIColor.tag_unselected
                    tagView.textColor = UIColor.text_dark
                    tagView.isSelected = false
                }
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func selectFromDateAction(_ sender: Any) {
        self.dateDest = 1
        self.showDatePicker()
    }
    
    @IBAction func selectToDateAction(_ sender: Any) {
        self.dateDest = 2
        self.showDatePicker()
    }
    
    func showDatePicker() {
        let minimumDate = Calendar.current.date(byAdding: .year, value: -10, to: Date())!
        let maxDate = Date()
        
        let currentDate = Date()
        
        self.getDatePicker().show("select_date".localized, doneButtonTitle: "done".localized, cancelButtonTitle: "cancel".localized, defaultDate: currentDate, minimumDate: minimumDate, maximumDate: maxDate, datePickerMode: .date) { (date) in
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            let year = formatter.string(from: date ?? Date())
            formatter.dateFormat = "MM"
            let month = formatter.string(from: date ?? Date())
            formatter.dateFormat = "dd"
            let day = formatter.string(from: date ?? Date())
            
            let selectedDate = "\(day)/\(month)/\(year)"
            if (self.dateDest == 1) {
                self.fieldFromDate.text = selectedDate
                self.cvFromDate.backgroundColor = UIColor.card_color
                self.selectedFromDate = self.getStringFromDate(date: date ?? Date(), outputFormat: Constants.DATE_FORMATS.api_date)
            }else {
                self.fieldToDate.text = selectedDate
                self.cvToDate.backgroundColor = UIColor.card_color
                self.selectedToDate = self.getStringFromDate(date: date ?? Date(), outputFormat: Constants.DATE_FORMATS.api_date)
            }
            
        }
    }
    
    @IBAction func selectCountryAction(_ sender: Any) {
        let vc : SelectCountryVC = self.getStoryBoard(name: Constants.STORYBOARDS.authentication).instantiateViewController(withIdentifier: "SelectCountryVC")
            as! SelectCountryVC
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func clearAction(_ sender: Any) {
        self.delegate?.onClear()
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func applyAction(_ sender: Any) {
        self.fillFilter()
        self.delegate?.onApply(filter: self.filter)
        self.navigationController?.popViewController(animated: true)
    }
    
    func fillFilter() {
        if (self.filter == nil) {
            self.filter = TransactionsFilter()
        }
        filter?.fromInsertDate = self.selectedFromDate
        filter?.toInsertDate = self.selectedToDate
        filter?.remittanceNumber = (self.fieldReferenceNumber.text ?? "").trim().replacedArabicDigitsWithEnglish
        filter?.country = self.selectedCountry
        filter?.remittanceStatusId = [Int]()
        
        let selectedIds = self.tags.filter { (tag) -> Bool in
            tag.isChecked ?? false == true
        }
        filter?.remittanceStatusId?.append(contentsOf: selectedIds.map { ($0.value ?? 0) })
    }
    
}

extension FilterVC : CountryDelegate {
    func didSelectCountry(country: CountryDatum) {
        self.selectedCountry = country
        self.fieldCountry.text = country.name ?? ""
        let url = URL(string: "\(Constants.IMAGE_URL)\(country.flag ?? "")")
        ivCountry.kf.setImage(with: url, placeholder: UIImage(named: ""))
        self.cvCountry.backgroundColor = UIColor.card_color
    }
}

extension FilterVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.fieldReferenceNumber) {
            self.cvReferenceNumber.backgroundColor = UIColor.card_focused_color
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == self.fieldReferenceNumber) {
            self.cvReferenceNumber.backgroundColor = UIColor.card_color
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == self.fieldReferenceNumber) {
            self.fieldReferenceNumber.resignFirstResponder()
        }
        return false
    }
    
}

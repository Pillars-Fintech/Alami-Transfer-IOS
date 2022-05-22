//
//  RegisterStep1.swift
//  alalami
//
//  Created by Zaid Khaled on 8/31/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit
import DatePickerDialog
import DropDown

class RegisterStep1: BaseVC {
    @IBOutlet weak var lRegister: MyUILabel!
    
    @IBOutlet weak var btnBack: UIButton!
    
    //first name
    @IBOutlet weak var cvFirstName: CardView!
    @IBOutlet weak var fieldFirstName: MyUITextField!
    
    
    //middle name
    @IBOutlet weak var cvMiddleName: CardView!
    @IBOutlet weak var fieldMiddleName: MyUITextField!
    
    //third name
    @IBOutlet weak var cvThirdName: CardView!
    @IBOutlet weak var fieldThirdName: MyUITextField!
    
    //family name
    @IBOutlet weak var cvFamilyName: CardView!
    @IBOutlet weak var fieldFamilyName: MyUITextField!
    
    //country of birth
    @IBOutlet weak var cvCountryOfBirth: CardView!
    @IBOutlet weak var fieldCountryOfBirth: MyUITextField!
    @IBOutlet weak var ivCountryOfBirth: UIImageView!
    var selectedCountryOfBirth : CountryDatum?
    
    //date of birth
    @IBOutlet weak var cvBirthDate: CardView!
    @IBOutlet weak var fieldBirthDate: MyUITextField!
    var selectedBirthDate = ""
    
    var countryDest = 1
    
    //nationality
    @IBOutlet weak var cvNationality: CardView!
    @IBOutlet weak var fieldNationality: MyUITextField!
    @IBOutlet weak var ivNationality: UIImageView!
    var selectedNationality : CountryDatum?
    
    //occupation
    @IBOutlet weak var cvOccupation: CardView!
    @IBOutlet weak var fieldOccupation: MyUITextField!
    var occupations = [OccupationDatum]()
    var occupationsDropdown : DropDown?
    var selectedOccupation : OccupationDatum?
    
    //next
    @IBOutlet weak var cvNext: CardView!
    @IBOutlet weak var btnNext: MyUIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
        }
        
        lRegister.textAlignment = .right

        
        if (isArabic()) {
  
            lRegister.textAlignment = .right
        }else{
            lRegister.textAlignment = .left

        }
        
        self.retreiveData()
        self.fieldFirstName.delegate = self
        self.fieldMiddleName.delegate = self
        self.fieldThirdName.delegate = self
        self.fieldFamilyName.delegate = self
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.fillData()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func countryOfBirthAction(_ sender: Any) {
        self.countryDest = 1
        self.openCountryPicker()
    }
    
    @IBAction func birthdateAction(_ sender: Any) {
        self.showDatePicker()
    }
    
    @IBAction func nationalityAction(_ sender: Any) {
        self.countryDest = 2
        self.openCountryPicker()
    }
    
    func openCountryPicker() {
        let vc : SelectCountryVC = self.getStoryBoard(name: Constants.STORYBOARDS.authentication).instantiateViewController(withIdentifier: "SelectCountryVC")
            as! SelectCountryVC
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func occupationAction(_ sender: Any) {
        self.showLoading()
        self.getApiManager().getOccupation { (response) in
            self.hideLoading()
            self.occupationsDropdown = DropDown()
            self.occupationsDropdown?.anchorView = self.cvOccupation
            var arr = [String]()
            self.occupations.removeAll()
            self.occupations.append(contentsOf: response.data ?? [OccupationDatum]())
            for item in self.occupations {
                arr.append(item.name ?? "")
            }
            self.occupationsDropdown?.dataSource = arr
            self.occupationsDropdown?.show()
            
            self.occupationsDropdown?.selectionAction = { [unowned self] (index: Int, item: String) in
                self.selectedOccupation = self.occupations[index]
                self.fieldOccupation.text = self.selectedOccupation?.name ?? ""
                self.cvOccupation.backgroundColor = UIColor.card_color
                self.validateFields()
            }
        }
    }
    
    
    @IBAction func nextAction(_ sender: Any) {
        
        if (self.validate()) {
            self.fillData()
            self.pushVC(name: "RegisterStep2", sb: Constants.STORYBOARDS.authentication)
        }
        
    }
    
    func validate() -> Bool {
        let firstName = (self.fieldFirstName.text ?? "").trim()
        let middleName = (self.fieldMiddleName.text ?? "").trim()
        let thirdName = (self.fieldThirdName.text ?? "").trim()
        let familyName = (self.fieldFamilyName.text ?? "").trim()
        
        let country = (self.fieldCountryOfBirth.text ?? "").trim()
        let birthdate = (self.fieldBirthDate.text ?? "").trim()
        let nationality = (self.fieldNationality.text ?? "").trim()
        let occupation = (self.fieldOccupation.text ?? "").trim()
        
        
        if (firstName.count < 2) {
            self.showBanner(title: "alert".localized, message: "enter_valid_firstname".localized, style: UIColor.INFO)
            self.cvFirstName.backgroundColor = UIColor.app_red
            return false
        }
        
        if (!isPureText(text: firstName)) {
            self.showBanner(title: "alert".localized, message: "text_regex_firstname".localized, style: UIColor.INFO)
            self.cvFirstName.backgroundColor = UIColor.app_red
            return false
        }
        //        if (middleName.count < 2) {
        //            self.showBanner(title: "alert".localized, message: "enter_valid_middlename".localized, style: UIColor.INFO)
        //            self.cvMiddleName.backgroundColor = UIColor.app_red
        //            return false
        //        }
            if (!isPureText(text: middleName)) {
                self.showBanner(title: "alert".localized, message: "text_regex_middlename".localized, style: UIColor.INFO)
                self.cvMiddleName.backgroundColor = UIColor.app_red
                return false
            }
        //        if (thirdName.count < 2) {
        //            self.showBanner(title: "alert".localized, message: "enter_valid_thirdname".localized, style: UIColor.INFO)
        //            self.cvThirdName.backgroundColor = UIColor.app_red
        //            return false
        //        }
            if (!isPureText(text: thirdName)) {
                self.showBanner(title: "alert".localized, message: "text_regex_thirdname".localized, style: UIColor.INFO)
                self.cvThirdName.backgroundColor = UIColor.app_red
                return false
            }
        
        if (familyName.count < 2) {
            self.showBanner(title: "alert".localized, message: "enter_valid_familyname".localized, style: UIColor.INFO)
            self.cvFamilyName.backgroundColor = UIColor.app_red
            return false
        }
        if (!isPureText(text: familyName)) {
            self.showBanner(title: "alert".localized, message: "text_regex_familyname".localized, style: UIColor.INFO)
            self.cvFamilyName.backgroundColor = UIColor.app_red
            return false
        }
        if (country.count == 0) {
            self.showBanner(title: "alert".localized, message: "select_valid_country".localized, style: UIColor.INFO)
            self.cvCountryOfBirth.backgroundColor = UIColor.app_red
            return false
        }
        if (birthdate.count == 0) {
            self.showBanner(title: "alert".localized, message: "select_birthdate".localized, style: UIColor.INFO)
            self.cvBirthDate.backgroundColor = UIColor.app_red
            return false
        }
        if (nationality.count == 0) {
            self.showBanner(title: "alert".localized, message: "select_nationality".localized, style: UIColor.INFO)
            self.cvNationality.backgroundColor = UIColor.app_red
            return false
        }
        if (occupation.count == 0) {
            self.showBanner(title: "alert".localized, message: "select_occupation".localized, style: UIColor.INFO)
            self.cvOccupation.backgroundColor = UIColor.app_red
            return false
        }
        return true
    }
    
    func validateFields() {
        let firstName = (self.fieldFirstName.text ?? "").trim()
        let middleName = (self.fieldMiddleName.text ?? "").trim()
        let thirdName = (self.fieldThirdName.text ?? "").trim()
        let familyName = (self.fieldFamilyName.text ?? "").trim()
        
        let country = (self.fieldCountryOfBirth.text ?? "").trim()
        let birthdate = (self.fieldBirthDate.text ?? "").trim()
        let nationality = (self.fieldNationality.text ?? "").trim()
        let occupation = (self.fieldOccupation.text ?? "").trim()
        
        
        let isValidFirstName = (firstName.count >= 2 && isPureText(text: firstName))
        let isValidMiddleName = isPureText(text: middleName)
        let isValidThirdName = isPureText(text: thirdName)
        let isValidFamilyName = (familyName.count >= 2 && isPureText(text: familyName))
        let isValidCountry = country.count > 0
        let isValidBirthdate = birthdate.count > 0
        let isValidNationality = nationality.count > 0
        let isValidOccupation = occupation.count > 0
        
        
        if (isValidFirstName && isValidMiddleName && isValidThirdName && isValidFamilyName && isValidCountry && isValidBirthdate && isValidNationality && isValidOccupation) {
            self.enableNext(flag: true)
        }else {
            self.enableNext(flag: false)
        }
    }
    
    func showDatePicker() {
        let maxDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())!
        self.getDatePicker().show("select_birth_date".localized, doneButtonTitle: "done".localized, cancelButtonTitle: "cancel".localized, defaultDate: maxDate, minimumDate: "01/01/1950".toDate()!.date, maximumDate: maxDate, datePickerMode: .date) { (date) in
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            let year = formatter.string(from: date ?? Date())
            formatter.dateFormat = "MM"
            let month = formatter.string(from: date ?? Date())
            formatter.dateFormat = "dd"
            let day = formatter.string(from: date ?? Date())
            
            let selectedDate = "\(day)/\(month)/\(year)"
            self.fieldBirthDate.text = selectedDate
            self.cvBirthDate.backgroundColor = UIColor.card_color
            self.selectedBirthDate = self.getStringFromDate(date: date ?? Date(), outputFormat: Constants.DATE_FORMATS.api_date)
            self.validateFields()
        }
    }
    
    func enableNext(flag : Bool) {
        if (flag) {
            self.cvNext.backgroundColor = UIColor.enabled
            self.btnNext.setTitleColor(UIColor.enabled_text, for: .normal)
            btnNext.isEnabled = true
        }else {
            self.cvNext.backgroundColor = UIColor.disabled
            self.btnNext.setTitleColor(UIColor.disabled_text, for: .normal)
            if (Constants.SHOULD_DISABLE_BUTTON) {
                btnNext.isEnabled = false
            }
        }
    }
    
    
    func fillData() {
        if (App.shared.registerModel == nil) {
            App.shared.registerModel = RegisterModel()
        }
        App.shared.registerModel?.firstName = (self.fieldFirstName.text ?? "").trim()
        App.shared.registerModel?.middleName = (self.fieldMiddleName.text ?? "").trim()
        App.shared.registerModel?.thirdName = (self.fieldThirdName.text ?? "").trim()
        App.shared.registerModel?.familyName = (self.fieldFamilyName.text ?? "").trim()
        App.shared.registerModel?.countryOfBirth = self.selectedCountryOfBirth
        App.shared.registerModel?.dateOfBirth = self.selectedBirthDate
        App.shared.registerModel?.nationality = self.selectedNationality
        App.shared.registerModel?.occupation = self.selectedOccupation
    }
    
    func retreiveData() {
        let mModel = App.shared.registerModel
        self.fieldFirstName.text = mModel?.firstName ?? ""
        self.fieldMiddleName.text = mModel?.middleName ?? ""
        self.fieldThirdName.text = mModel?.thirdName ?? ""
        self.fieldFamilyName.text = mModel?.familyName ?? ""
        
        self.selectedCountryOfBirth = mModel?.countryOfBirth
        self.fieldCountryOfBirth.text = self.selectedCountryOfBirth?.name ?? ""
        
        self.selectedBirthDate = mModel?.dateOfBirth ?? ""
        self.fieldBirthDate.text = self.getStringDateWithFormat(dateStr: self.selectedBirthDate, outputFormat: Constants.DATE_FORMATS.dd_mm_yyyy)
        
        self.selectedNationality = mModel?.nationality
        self.fieldNationality.text = self.selectedNationality?.name ?? ""
        
        self.selectedOccupation = mModel?.occupation
        self.fieldOccupation.text = self.selectedOccupation?.name ?? ""
        
        self.validateFields()
    }
    
    @IBAction func firstNameChanged(_ sender: Any) {
        self.validateFields()
    }
    
    @IBAction func middleNameChanged(_ sender: Any) {
        self.validateFields()
    }
    
    @IBAction func familyNameChanged(_ sender: Any) {
        self.validateFields()
    }
    
    
}
extension RegisterStep1 : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.fieldFirstName) {
            self.cvFirstName.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldMiddleName) {
            self.cvMiddleName.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldFamilyName) {
            self.cvFamilyName.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldThirdName) {
            self.cvThirdName.backgroundColor = UIColor.card_focused_color
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == self.fieldFirstName) {
            self.cvFirstName.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldMiddleName) {
            self.cvMiddleName.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldFamilyName) {
            self.cvFamilyName.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldThirdName) {
            self.cvThirdName.backgroundColor = UIColor.card_color
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == self.fieldFirstName) {
            self.fieldMiddleName.becomeFirstResponder()
        }else if (textField == self.fieldMiddleName) {
            self.fieldThirdName.becomeFirstResponder()
        }else if (textField == self.fieldThirdName) {
            self.fieldFamilyName.becomeFirstResponder()
        }else if (textField == self.fieldFamilyName) {
            self.fieldFamilyName.resignFirstResponder()
        }
        return false
    }
}

extension RegisterStep1 : CountryDelegate {
    func didSelectCountry(country: CountryDatum) {
        if (self.countryDest == 1) {
            self.selectedCountryOfBirth = country
            self.fieldCountryOfBirth.text = country.name ?? ""
            let url = URL(string: "\(Constants.IMAGE_URL)\(country.flag ?? "")")
            ivCountryOfBirth.kf.setImage(with: url, placeholder: UIImage(named: ""))
            self.cvCountryOfBirth.backgroundColor = UIColor.card_color
        }else {
            self.selectedNationality = country
            self.fieldNationality.text = country.name ?? ""
            let url = URL(string: "\(Constants.IMAGE_URL)\(country.flag ?? "")")
            ivNationality.kf.setImage(with: url, placeholder: UIImage(named: ""))
            self.cvNationality.backgroundColor = UIColor.card_color
            App.shared.registerModel?.idType = nil
        }
        self.validateFields()
    }
}

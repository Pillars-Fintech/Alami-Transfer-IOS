//
//  mg_AddRewardVC.swift
//  alalami
//
//  Created by Zaid Khaled on 9/24/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit
import DatePickerDialog

class mg_AddRewardVC: BaseVC {
    
    @IBOutlet weak var btnBack: UIButton!

    //first name
    @IBOutlet weak var cvFirstName: CardView!
    @IBOutlet weak var fieldFirstName: MyUITextField!
    
    //last name
    @IBOutlet weak var cvLastName: CardView!
    @IBOutlet weak var fieldLastName: MyUITextField!
    
    //address
    @IBOutlet weak var cvAddress: CardView!
    @IBOutlet weak var fieldAddress: MyUITextField!
    
    //country
    @IBOutlet weak var cvCountry: CardView!
    @IBOutlet weak var fieldCountry: MyUITextField!
    @IBOutlet weak var ivCountry: UIImageView!
    var selectedCountry : MGCountryDatum?
    
    
    //city
    @IBOutlet weak var cvCity: CardView!
    @IBOutlet weak var fieldCity: MyUITextField!
    
    //date of birth
    @IBOutlet weak var cvDateOfBirth: CardView!
    @IBOutlet weak var fieldDateOfBirth: MyUITextField!
    var selectedBirthDate = ""
    
    //phone number
    @IBOutlet weak var cvPhone: CardView!
    @IBOutlet weak var fieldPhone: MyUITextField!
    
    //markering SMS
    @IBOutlet weak var ivMarketingSMSYes: UIImageView!
    @IBOutlet weak var ivMarketingSMSNo: UIImageView!
    var isSMSSelected : Bool = true
    
    //opt in
    @IBOutlet weak var ivOptInYes: UIImageView!
    @IBOutlet weak var ivOptInNo: UIImageView!
    var isOptInSelected : Bool = true
    
    //action
    @IBOutlet weak var cvContinue: CardView!
    @IBOutlet weak var btnContinue: MyUIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
        }
        
        self.fieldFirstName.delegate = self
        self.fieldLastName.delegate = self
        self.fieldAddress.delegate = self
        self.fieldCity.delegate = self
        self.fieldPhone.delegate = self
        
        self.enableNext(flag: false)
        self.loadSuggestions()
        
        if (isArabic()) {
            btnContinue.setTitle(App.shared.config?.moneyGramSettings?.rewardButtonTitlteAr ?? "", for: .normal)
        }else {
            btnContinue.setTitle(App.shared.config?.moneyGramSettings?.rewardButtonTitlteEn ?? "", for: .normal)
        }
        
    }
    
    func loadSuggestions() {
        self.showLoading()
        self.getApiManager().getRewardSuggestions(token: self.getAccessToken()) { (response) in
            self.hideLoading()
            self.fieldFirstName.text = response.data?.consumerFirstName ?? ""
            self.fieldLastName.text = response.data?.consumerLastName ?? ""
            self.fieldAddress.text = response.data?.consumerAddress ?? ""
            self.fieldCity.text = response.data?.consumerCity ?? ""
            self.selectedBirthDate = response.data?.consumerDOB ?? ""
            self.fieldDateOfBirth.text = self.getStringDateWithFormat(dateStr: response.data?.consumerDOB ?? "", outputFormat: Constants.DATE_FORMATS.dd_mm_yyyy)
            self.fieldPhone.text = response.data?.consumerHomePhone ?? ""
            
            let countryObj = MGCountryDatum(countryCode: response.data?.consumerCountry ?? "", countryName: response.data?.consumerCountryName ?? "", countryId: "", countryPhoneCode: "", flag: response.data?.consumerCountryFlag ?? "", curencyIso3: "")
            
            self.selectedCountry = countryObj
            
            self.fieldCountry.text = self.selectedCountry?.countryName ?? ""
            let url = URL(string: "\(Constants.IMAGE_URL)\(self.selectedCountry?.flag ?? "")")
            self.ivCountry.kf.setImage(with: url, placeholder: UIImage(named: ""))
            self.cvCountry.backgroundColor = UIColor.card_color
            
            self.validateFields()
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectCountryAction(_ sender: Any) {
        let vc : SelectMGCountryVC = self.getStoryBoard(name: Constants.STORYBOARDS.money_gram).instantiateViewController(withIdentifier: "SelectMGCountryVC")
            as! SelectMGCountryVC
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func selectDateOfBirthAction(_ sender: Any) {
        self.showDatePicker()
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
            self.fieldDateOfBirth.text = selectedDate
            self.cvDateOfBirth.backgroundColor = UIColor.card_color
            self.selectedBirthDate = self.getStringFromDate(date: date ?? Date(), outputFormat: Constants.DATE_FORMATS.api_date)
            self.validateFields()
        }
    }
    
    //check boxes
    @IBAction func smsYes(_ sender: Any) {
        self.ivMarketingSMSYes.image = UIImage(named: "ic_language_selected")
        self.ivMarketingSMSNo.image = UIImage(named: "ic_language_unselected")
        self.isSMSSelected = true
    }
    
    @IBAction func smsNo(_ sender: Any) {
        self.ivMarketingSMSYes.image = UIImage(named: "ic_language_unselected")
        self.ivMarketingSMSNo.image = UIImage(named: "ic_language_selected")
        self.isSMSSelected = false
    }
    
    @IBAction func optInYes(_ sender: Any) {
        self.ivOptInYes.image = UIImage(named: "ic_language_selected")
        self.ivOptInNo.image = UIImage(named: "ic_language_unselected")
        self.isOptInSelected = true
    }
    
    @IBAction func optInNo(_ sender: Any) {
        self.ivOptInYes.image = UIImage(named: "ic_language_unselected")
        self.ivOptInNo.image = UIImage(named: "ic_language_selected")
        self.isOptInSelected = false
    }
    
    @IBAction func fieldEntryChanged(_ sender: Any) {
        self.validateFields()
    }
    
    @IBAction func continueAction(_ sender: Any) {
        if (self.validate()) {
            //join reward api
            self.saveRewardApi()
        }
    }
    
    func saveRewardApi() {
        let firstName = (self.fieldFirstName.text ?? "").trim()
        let lastName = (self.fieldLastName.text ?? "").trim()
        let address = (self.fieldAddress.text ?? "").trim()
        let city = (self.fieldCity.text ?? "").trim()
        let phone = (self.fieldPhone.text ?? "").trim()
        
        self.showLoading()
        self.getApiManager().saveMGReward(token: self.getAccessToken(), address: address, city: city, country: self.selectedCountry?.countryCode ?? "", dob: self.selectedBirthDate, firstName: firstName, lastName: lastName, phone: phone.replacedArabicDigitsWithEnglish, smsOn: self.isSMSSelected, optOn: self.isOptInSelected) { (response) in
            self.hideLoading()
            if (response.success ?? false) {
                self.showRewardCode(code: response.data ?? "")
            }else {
                self.handleError(code : response.code ?? "", message : response.message)
            }
        }
        
    }
    
    func showRewardCode(code : String) {
        var title = App.shared.config?.moneyGramSettings?.availableRewardEn ?? ""
        if (self.isArabic()) {
            title = App.shared.config?.moneyGramSettings?.availableRewardAr ?? ""
        }
        self.showAlert(title: title, message: code, buttonText: "ok".localized) {
            self.pushVC(name: "mg_RemittanceInfoVC", sb: Constants.STORYBOARDS.money_gram)
            self.navigationController?.viewControllers.remove(at: 1)
        }
    }
    
    
    func validate() -> Bool {
        let firstName = (self.fieldFirstName.text ?? "").trim()
        let lastName = (self.fieldLastName.text ?? "").trim()
        let address = (self.fieldAddress.text ?? "").trim()
        let city = (self.fieldCity.text ?? "").trim()
        let phone = (self.fieldPhone.text ?? "").trim()
        if (firstName.count == 0) {
            self.showBanner(title: "alert".localized, message: "enter_first_name".localized, style: UIColor.INFO)
            self.cvFirstName.backgroundColor = UIColor.app_red
            return false
        }
        if (!isPureText(text: firstName)) {
            self.showBanner(title: "alert".localized, message: "text_regex_firstname".localized, style: UIColor.INFO)
            self.cvFirstName.backgroundColor = UIColor.app_red
            return false
        }
        
        if (lastName.count == 0) {
            self.showBanner(title: "alert".localized, message: "enter_last_name".localized, style: UIColor.INFO)
            self.cvLastName.backgroundColor = UIColor.app_red
            return false
        }
        
        if (!isPureText(text: lastName)) {
            self.showBanner(title: "alert".localized, message: "text_regex_familyname".localized, style: UIColor.INFO)
            self.cvLastName.backgroundColor = UIColor.app_red
            return false
        }
        
        if (address.count == 0) {
            self.showBanner(title: "alert".localized, message: "enter_valid_address".localized, style: UIColor.INFO)
            self.cvAddress.backgroundColor = UIColor.app_red
            return false
        }
        if (!isPureText(text: address)) {
            self.showBanner(title: "alert".localized, message: "text_regex_address".localized, style: UIColor.INFO)
            self.cvAddress.backgroundColor = UIColor.app_red
            return false
        }
        if (self.selectedCountry?.countryName?.count ?? 0 == 0) {
            self.showBanner(title: "alert".localized, message: "select_valid_country".localized, style: UIColor.INFO)
            self.cvCountry.backgroundColor = UIColor.app_red
            return false
        }
        if (city.count == 0) {
            self.showBanner(title: "alert".localized, message: "enter_valid_city".localized, style: UIColor.INFO)
            self.cvCity.backgroundColor = UIColor.app_red
            return false
        }
        if (!isPureText(text: city)) {
            self.showBanner(title: "alert".localized, message: "text_regex_city".localized, style: UIColor.INFO)
            self.cvCity.backgroundColor = UIColor.app_red
            return false
        }
        if (self.selectedBirthDate.count == 0) {
            self.showBanner(title: "alert".localized, message: "select_birthdate".localized, style: UIColor.INFO)
            self.cvDateOfBirth.backgroundColor = UIColor.app_red
            return false
        }
        if (phone.count == 0) {
            self.showBanner(title: "alert".localized, message: "enter_mobile_number".localized, style: UIColor.INFO)
            self.cvPhone.backgroundColor = UIColor.app_red
            return false
        }
        
        return true
    }
    
    func validateFields() {
        let firstName = (self.fieldFirstName.text ?? "").trim()
        let lastName = (self.fieldLastName.text ?? "").trim()
        let address = (self.fieldAddress.text ?? "").trim()
        let city = (self.fieldCity.text ?? "").trim()
        let phone = (self.fieldPhone.text ?? "").trim()
        if (firstName.count == 0) {
            self.enableNext(flag: false)
            return
        }
        if (!isPureText(text: [firstName, lastName, city, address])) {
            self.enableNext(flag: false)
            return
        }
        if (lastName.count == 0) {
            self.enableNext(flag: false)
            return
        }
        if (address.count == 0) {
            self.enableNext(flag: false)
            return
        }
        if (self.selectedCountry?.countryName?.count ?? 0 == 0) {
            self.enableNext(flag: false)
            return
        }
        if (city.count == 0) {
            self.enableNext(flag: false)
            return
        }
        if (self.selectedBirthDate.count == 0) {
            self.enableNext(flag: false)
            return
        }
        if (phone.count == 0) {
            self.enableNext(flag: false)
            return
        }
        
        self.enableNext(flag: true)
    }
    
    func enableNext(flag : Bool) {
        if (flag) {
            self.cvContinue.backgroundColor = UIColor.enabled
            self.btnContinue.setTitleColor(UIColor.enabled_text, for: .normal)
            btnContinue.isEnabled = true
        }else {
            self.cvContinue.backgroundColor = UIColor.disabled
            self.btnContinue.setTitleColor(UIColor.disabled_text, for: .normal)
            if (Constants.SHOULD_DISABLE_BUTTON) {
                btnContinue.isEnabled = false
            }
        }
    }
}

extension mg_AddRewardVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.fieldFirstName) {
            self.cvFirstName.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldLastName) {
            self.cvLastName.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldAddress) {
            self.cvAddress.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldCity) {
            self.cvCity.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldPhone) {
            self.cvPhone.backgroundColor = UIColor.card_focused_color
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == self.fieldFirstName) {
            self.cvFirstName.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldLastName) {
            self.cvLastName.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldAddress) {
            self.cvAddress.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldCity) {
            self.cvCity.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldPhone) {
            self.cvPhone.backgroundColor = UIColor.card_color
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == self.fieldFirstName) {
            self.fieldLastName.becomeFirstResponder()
        }else if (textField == self.fieldLastName) {
            self.fieldAddress.becomeFirstResponder()
        }else if (textField == self.fieldAddress) {
            self.fieldCity.becomeFirstResponder()
        }else if (textField == self.fieldCity) {
            self.fieldCity.resignFirstResponder()
        }else if (textField == self.fieldPhone) {
            self.fieldPhone.resignFirstResponder()
        }
        return false
    }
}

extension mg_AddRewardVC : MGCountryDelegate {
    func didSelectCountry(country: MGCountryDatum) {
        self.selectedCountry = country
        self.fieldCountry.text = country.countryName ?? ""
        let url = URL(string: "\(Constants.IMAGE_URL)\(country.flag ?? "")")
        ivCountry.kf.setImage(with: url, placeholder: UIImage(named: ""))
        self.cvCountry.backgroundColor = UIColor.card_color
        self.validateFields()
    }
}

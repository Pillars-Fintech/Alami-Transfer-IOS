//
//  PersonalInformationVC.swift
//  alalami
//
//  Created by Zaid Khaled on 10/1/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit
import DropDown

class PersonalInformationVC: BaseVC {
    
    
    
    @IBOutlet weak var lPersonalInformation: MyUILabel!
    
    
    @IBOutlet weak var btnBack: UIButton!
    
    
    //firstname
    @IBOutlet weak var fieldFirstName: MyUITextField!
    
    //secondname
    @IBOutlet weak var fieldSecondName: MyUITextField!
    
    //thirdname
    @IBOutlet weak var fieldThirdName: MyUITextField!
    
    //lastname
    @IBOutlet weak var fieldLastName: MyUITextField!
    
    
    //arabic first name
    @IBOutlet weak var cvArabicFirstName: CardView!
    @IBOutlet weak var fieldArabicFirstName: MyUITextField!
    
    //arabic second name
    @IBOutlet weak var cvArabicSecondName: CardView!
    @IBOutlet weak var fieldArabicSecondName: MyUITextField!
    
    //arabic third name
    @IBOutlet weak var cvArabicThirdName: CardView!
    @IBOutlet weak var fieldArabicThirdName: MyUITextField!
    
    //arabic last name
    @IBOutlet weak var cvArabicLastName: CardView!
    @IBOutlet weak var fieldArabicLastName: MyUITextField!
    
    //country of birth
    @IBOutlet weak var cvCountryOfBirth: CardView!
    @IBOutlet weak var fieldCountryOfBirth: MyUITextField!
    @IBOutlet weak var ivCountryOfBirth: UIImageView!
    var selectedCountryOfBirth : CountryDatum?
    
    //date of birth
    @IBOutlet weak var fieldDateOfBirth: MyUITextField!
    
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
    
    //action
    @IBOutlet weak var cvContinue: CardView!
    @IBOutlet weak var btnContinue: MyUIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
        }
        if (isArabic()) {
            lPersonalInformation.textAlignment = .right
        }else{
            lPersonalInformation.textAlignment = .left

        }
        
        
        self.fieldArabicFirstName.delegate = self
        self.fieldArabicSecondName.delegate = self
        self.fieldArabicThirdName.delegate = self
        self.fieldArabicLastName.delegate = self
        
        self.loadProfileInfo()
        
    }
    
    func loadProfileInfo() {
        self.showLoading()
        self.getApiManager().getAccountInfo(token: self.getAccessToken()) { (response) in
            self.hideLoading()
            if (response.success ?? false) {
                let accountData = response.data
                self.initUI(accountData: accountData)
            }else {
                self.handleError(code: response.code, message: response.message)
            }
        }
    }
    
    func initUI(accountData : AcountInfoClass?) {
        self.fieldFirstName.text = accountData?.firstNameEn ?? ""
        self.fieldSecondName.text = accountData?.secondNameEn ?? ""
        self.fieldThirdName.text = accountData?.thirdNameEn ?? ""
        self.fieldLastName.text = accountData?.lastNameEn ?? ""
        
        self.fieldArabicFirstName.text = accountData?.firstNameAr ?? ""
        self.fieldArabicSecondName.text = accountData?.secondNameAr ?? ""
        self.fieldArabicThirdName.text = accountData?.thirdNameAr ?? ""
        self.fieldArabicLastName.text = accountData?.lastNameAr ?? ""
        
        //flags
        let countryOfBirthUrl = URL(string: "\(Constants.IMAGE_URL)\(accountData?.CountryOfBirthFlagURL ?? "")")
        ivCountryOfBirth.kf.setImage(with: countryOfBirthUrl, placeholder: UIImage(named: ""))
        
        let nationalityUrl = URL(string: "\(Constants.IMAGE_URL)\(accountData?.NationalityFlagURL ?? "")")
        ivNationality.kf.setImage(with: nationalityUrl, placeholder: UIImage(named: ""))
        
        //country of birth
        var countryOfBirthName = accountData?.countryOfBirthNameEn ?? ""
        if (self.isArabic()) {
            countryOfBirthName = accountData?.countryOfBirthNameAr ?? ""
        }
        
        self.selectedCountryOfBirth = CountryDatum(id: accountData?.countryOfBirthID ?? "", name: countryOfBirthName, iso2: "", iso3: "", afexCode: 0, moneyGramCode: "", moneyGramAnathorCode: "", moneyGramDescription: "", moneyGramIncludeSend: false, moneyGramIncludeReceive: false, moneyGramIsDirectedSendCountry: false, eFAWATEERcomCode: "", eFAWATEERcomDescription: "", country_code: "", flag: "")
        
        self.fieldCountryOfBirth.text = countryOfBirthName
        
        
        //date of birth
        self.fieldDateOfBirth.text = self.getStringDateWithFormat(dateStr: accountData?.birthOfDate ?? "", outputFormat: Constants.DATE_FORMATS.dd_mm_yyyy)
        
        self.selectedBirthDate = accountData?.birthOfDate ?? ""
        
        
        //nationality
        var nationalityCountryName = accountData?.nationalityNameEn ?? ""
        if (self.isArabic()) {
            nationalityCountryName = accountData?.nationalityNameAr ?? ""
        }
        
        self.selectedNationality = CountryDatum(id: accountData?.nationalityID ?? "", name: nationalityCountryName, iso2: "", iso3: "", afexCode: 0, moneyGramCode: "", moneyGramAnathorCode: "", moneyGramDescription: "", moneyGramIncludeSend: false, moneyGramIncludeReceive: false, moneyGramIsDirectedSendCountry: false, eFAWATEERcomCode: "", eFAWATEERcomDescription: "", country_code: "", flag: "")
        
        self.fieldNationality.text = nationalityCountryName
        
        
        //occupation
        var occupationName = accountData?.occupationNameEn ?? ""
        if (self.isArabic()) {
            occupationName = accountData?.occupationNameAr ?? ""
        }
        self.selectedOccupation = OccupationDatum(id: accountData?.occupationID ?? "", clientTypeID: 0, code: "", name: occupationName, moneyGramCode: "", moneyGramDescription: "", eFAWATEERcomCode: "", eFAWATEERcomDescription: "")
        
        self.fieldOccupation.text = occupationName
        
        self.validateFields()
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
    
    @IBAction func fieldTextChanged(_ sender: Any) {
        self.validateFields()
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func selectCountryOfBirthAction(_ sender: Any) {
        self.countryDest = 1
        self.openCountryPicker()
    }
    
    func openCountryPicker() {
        let vc : SelectCountryVC = self.getStoryBoard(name: Constants.STORYBOARDS.authentication).instantiateViewController(withIdentifier: "SelectCountryVC")
            as! SelectCountryVC
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func selectNationalityAction(_ sender: Any) {
        self.countryDest = 2
        self.openCountryPicker()
    }
    
    @IBAction func selectOccupationAction(_ sender: Any) {
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
    
    func validate() -> Bool {
        let firstName = (self.fieldArabicFirstName.text ?? "").trim()
        let middleName = (self.fieldArabicSecondName.text ?? "").trim()
        let thirdName = (self.fieldArabicThirdName.text ?? "").trim()
        let familyName = (self.fieldArabicLastName.text ?? "").trim()
        
        let country = (self.fieldCountryOfBirth.text ?? "").trim()
        let nationality = (self.fieldNationality.text ?? "").trim()
        let occupation = (self.fieldOccupation.text ?? "").trim()
        
        
        if (firstName.count < 2) {
            self.showBanner(title: "alert".localized, message: "enter_valid_firstname".localized, style: UIColor.INFO)
            self.cvArabicFirstName.backgroundColor = UIColor.app_red
            return false
        }
        if (!isPureText(text: firstName)) {
            self.showBanner(title: "alert".localized, message: "text_regex_firstname".localized, style: UIColor.INFO)
            self.cvArabicFirstName.backgroundColor = UIColor.app_red
            return false
        }
        if (middleName.count < 2) {
            self.showBanner(title: "alert".localized, message: "enter_valid_middlename".localized, style: UIColor.INFO)
            self.cvArabicSecondName.backgroundColor = UIColor.app_red
            return false
        }
        if (!isPureText(text: middleName)) {
            self.showBanner(title: "alert".localized, message: "text_regex_middlename".localized, style: UIColor.INFO)
            self.cvArabicSecondName.backgroundColor = UIColor.app_red
            return false
        }
        if (thirdName.count < 2) {
            self.showBanner(title: "alert".localized, message: "enter_valid_thirdname".localized, style: UIColor.INFO)
            self.cvArabicThirdName.backgroundColor = UIColor.app_red
            return false
        }
        if (!isPureText(text: thirdName)) {
            self.showBanner(title: "alert".localized, message: "text_regex_thirdname".localized, style: UIColor.INFO)
            self.cvArabicThirdName.backgroundColor = UIColor.app_red
            return false
        }
        if (familyName.count < 2) {
            self.showBanner(title: "alert".localized, message: "enter_valid_familyname".localized, style: UIColor.INFO)
            self.cvArabicLastName.backgroundColor = UIColor.app_red
            return false
        }
        if (!isPureText(text: familyName)) {
            self.showBanner(title: "alert".localized, message: "text_regex_familyname".localized, style: UIColor.INFO)
            self.cvArabicLastName.backgroundColor = UIColor.app_red
            return false
        }
        if (country.count == 0) {
            self.showBanner(title: "alert".localized, message: "select_valid_country".localized, style: UIColor.INFO)
            self.cvCountryOfBirth.backgroundColor = UIColor.app_red
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
        let firstName = (self.fieldArabicFirstName.text ?? "").trim()
        let middleName = (self.fieldArabicSecondName.text ?? "").trim()
        let thirdName = (self.fieldArabicThirdName.text ?? "").trim()
        let familyName = (self.fieldArabicLastName.text ?? "").trim()
        
        let country = (self.fieldCountryOfBirth.text ?? "").trim()
        let nationality = (self.fieldNationality.text ?? "").trim()
        let occupation = (self.fieldOccupation.text ?? "").trim()
        
        
        if (firstName.count < 2) {
            self.enableNext(flag: false)
            return
        }
        
        if (middleName.count < 2) {
            self.enableNext(flag: false)
            return
        }
        
        if (thirdName.count < 2) {
            self.enableNext(flag: false)
            return
        }
        
        if (familyName.count < 2) {
            self.enableNext(flag: false)
            return
        }
        
        if (country.count == 0) {
            self.enableNext(flag: false)
            return
        }
        
        if (nationality.count == 0) {
            self.enableNext(flag: false)
            return
        }
        
        if (occupation.count == 0) {
            self.enableNext(flag: false)
            return
        }
        
        if (!isPureText(text: [firstName, middleName, thirdName, familyName])) {
            self.enableNext(flag: false)
            return
        }
        
        self.enableNext(flag: true)
    }
    
    @IBAction func continueAction(_ sender: Any) {
        if (self.validate()) {
            //update account info
            self.showLoading()
            self.getApiManager().updatePersonalInformation(token: self.getAccessToken(), firstNameAr: (self.fieldArabicFirstName.text ?? "").trim(), secondNameAr: (self.fieldArabicSecondName.text ?? "").trim(), thirdNameAr: (self.fieldArabicThirdName.text ?? "").trim(), lastNameAr: (self.fieldArabicLastName.text ?? "").trim(), countryId: self.selectedCountryOfBirth?.id ?? "", dob: self.selectedBirthDate, nationalityId: self.selectedNationality?.id ?? "", occupationId: self.selectedOccupation?.id ?? "") { (response) in
                self.hideLoading()
                if (response.success ?? false) {
                    var message = ""
                    for item in response.data ?? [UpdateDatum]() {
                        message = "\(message).\n\(item.caption ?? "") : \(item.value ?? "")"
                    }
                    self.showSuccessAlert(message: message)
                }else {
                    self.handleError(code: response.code, message: response.message)
                }
            }
        }
    }
    
    func showSuccessAlert(message : String) {
        showAlert(title: "alert".localized, message: message, buttonText: "ok".localized) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func fNameChanged(_ sender: Any) {
        self.validateFields()
    }
    @IBAction func sNameChanged(_ sender: Any) {
        self.validateFields()
    }
    @IBAction func tNameChanged(_ sender: Any) {
        self.validateFields()
    }
    @IBAction func lNameChanged(_ sender: Any) {
        self.validateFields()
    }
    
}

extension PersonalInformationVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.fieldArabicFirstName) {
            self.cvArabicFirstName.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldArabicSecondName) {
            self.cvArabicSecondName.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldArabicThirdName) {
            self.cvArabicThirdName.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldArabicLastName) {
            self.cvArabicLastName.backgroundColor = UIColor.card_focused_color
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == self.fieldArabicFirstName) {
            self.cvArabicFirstName.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldArabicSecondName) {
            self.cvArabicSecondName.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldArabicThirdName) {
            self.cvArabicThirdName.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldArabicLastName) {
            self.cvArabicLastName.backgroundColor = UIColor.card_color
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == self.fieldArabicFirstName) {
            self.fieldArabicSecondName.becomeFirstResponder()
        }else if (textField == self.fieldArabicSecondName) {
            self.fieldArabicThirdName.becomeFirstResponder()
        }else if (textField == self.fieldArabicThirdName) {
            self.fieldArabicLastName.becomeFirstResponder()
        }else if (textField == self.fieldArabicLastName) {
            self.fieldArabicLastName.resignFirstResponder()
        }
        return false
    }
}

extension PersonalInformationVC : CountryDelegate {
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
        }
        self.validateFields()
    }
}

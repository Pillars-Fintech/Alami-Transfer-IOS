//
//  RegisterStep2.swift
//  alalami
//
//  Created by Zaid Khaled on 8/31/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit
import DatePickerDialog
import DropDown
import CoreMedia

class RegisterStep2: BaseVC, UINavigationControllerDelegate {
    
    @IBOutlet weak var lAdded: MyUILabel!
    
    @IBOutlet weak var lRegister: MyUILabel!
    
    
    @IBOutlet weak var btnBack: UIButton!
    
    //jordan logic
    var isNationalityJordan = false
    
    //id type
    @IBOutlet weak var cvIdType: CardView!
    @IBOutlet weak var fieldIdType: MyUITextField!
    var idTypes = [IdTypeDatum]()
    var idTypeDropdown : DropDown?
    var selectedidType : IdTypeDatum?
    
    //id issue country
    @IBOutlet weak var cvIssueCountry: CardView!
    @IBOutlet weak var fieldIssueCountry: MyUITextField!
    @IBOutlet weak var ivIssueCountry: UIImageView!
    var selectedIssueCountry : CountryDatum?
    
    //id number
    @IBOutlet weak var cvIdNumber: CardView!
    @IBOutlet weak var fieldIdNumber: MyUITextField!
    
    //issue date
    @IBOutlet weak var viewIssueDate: UIView!
    @IBOutlet weak var cvIssueDate: CardView!
    @IBOutlet weak var fieldIssueDate: MyUITextField!
    var selectedIssueDate = ""
    
    //expiry date
    @IBOutlet weak var cvExpiryDate: CardView!
    @IBOutlet weak var fieldExpiryDate: MyUITextField!
    var selectedExpiryDate = ""
    
    
    //national number
    @IBOutlet weak var viewNationalNumber: UIView!
    @IBOutlet weak var cvNationalNumber: CardView!
    @IBOutlet weak var fieldNationalNumber: MyUITextField!
    
    
    var countryDest = 1
    
    //date picker
    var dateDest = 1
    
    //residence
    @IBOutlet weak var cvResidence: CardView!
    @IBOutlet weak var fieldDesidance: MyUITextField!
    var residenceTypes = ["resident".localized, "not_resident".localized]
    var residenceDropDown : DropDown?
    var selectedResidence : String = "resident".localized
    var selectedResidenceValue : Bool = true
    
    //images labels
    @IBOutlet weak var lblFrontImage: MyUILabel!
    @IBOutlet weak var lblBackImage: MyUILabel!
    
    
    //cards
    @IBOutlet weak var ivFrontCard: CorneredImage!
    @IBOutlet weak var ivBackCard: CorneredImage!
    var idFrontImage : UIImage?
    var idBackImage : UIImage?
    
    
    //image picker
    var imageDest = 1
    
    var imagePicker: UIImagePickerController!
    
    enum ImageSource {
        case photoLibrary
        case camera
    }
    
    func selectImageFrom(_ source: ImageSource) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    func showDatePicker() {
        var minimumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())!
        var maxDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())!
        var currentDate =  Calendar.current.date(byAdding: .year, value: -18, to: Date())!
        if (self.dateDest == 1) { //issue date
            minimumDate = Calendar.current.date(byAdding: .year, value: -20, to: Date())!
            maxDate = Date().dateByAdding(-1, .day).date
            currentDate = Date()
        }else { //expiry date
            minimumDate = Calendar.current.date(byAdding: .day, value: +1, to: Date())!
            maxDate = Calendar.current.date(byAdding: .year, value: +20, to: Date())!
            currentDate = minimumDate.dateByAdding(1, .year).date
        }
        self.getDatePicker().show("select_birth_date".localized, doneButtonTitle: "done".localized, cancelButtonTitle: "cancel".localized, defaultDate: currentDate, minimumDate: minimumDate, maximumDate: maxDate, datePickerMode: .date) { (date) in
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            let year = formatter.string(from: date ?? Date())
            formatter.dateFormat = "MM"
            let month = formatter.string(from: date ?? Date())
            formatter.dateFormat = "dd"
            let day = formatter.string(from: date ?? Date())
            
            let selectedDate = "\(day)/\(month)/\(year)"
            if (self.dateDest == 1) {
                self.fieldIssueDate.text = selectedDate
                self.cvIssueDate.backgroundColor = UIColor.card_color
                self.selectedIssueDate = self.getStringFromDate(date: date ?? Date(), outputFormat: Constants.DATE_FORMATS.api_date)
            }else {
                self.fieldExpiryDate.text = selectedDate
                self.cvExpiryDate.backgroundColor = UIColor.card_color
                self.selectedExpiryDate = self.getStringFromDate(date: date ?? Date(), outputFormat: Constants.DATE_FORMATS.api_date)
            }
            self.validateFields()
            
        }
    }
    
    
    //your country
    @IBOutlet weak var cvCountry: CardView!
    @IBOutlet weak var fieldCountry: MyUITextField!
    @IBOutlet weak var ivYourCountry: UIImageView!
    var selectedYourCountry : CountryDatum?
    
    
    //city
    @IBOutlet weak var cvCity: CardView!
    @IBOutlet weak var fieldCity: MyUITextField!
    
    //street
    @IBOutlet weak var cvStreet: CardView!
    @IBOutlet weak var fieldStreet: MyUITextField!
    
    //building
    @IBOutlet weak var cvBuilding: CardView!
    @IBOutlet weak var fieldBuilding: MyUITextField!
    
    //address
    @IBOutlet weak var cvAddress: CardView!
    @IBOutlet weak var fieldAddress: MyUITextField!
    
    //next
    @IBOutlet weak var cvNext: CardView!
    @IBOutlet weak var btnNext: MyUIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
        }
        
        
        lRegister.textAlignment = .natural
        lblFrontImage.textAlignment = .natural
        lblBackImage.textAlignment = .natural
        lAdded.textAlignment = .natural

        if (isArabic()) {
  
            lRegister.textAlignment = .right
            lblFrontImage.textAlignment = .right
            lblBackImage.textAlignment = .right
            lAdded.textAlignment = .right

        }else{
            lRegister.textAlignment = .left
            lblFrontImage.textAlignment = .left
            lblBackImage.textAlignment = .left
            lAdded.textAlignment = .left

        }
        
        
        
        
        self.retreiveData()
        self.fieldIdNumber.delegate = self
        self.fieldCity.delegate = self
        self.fieldStreet.delegate = self
        self.fieldBuilding.delegate = self
        self.fieldAddress.delegate = self
        self.fieldNationalNumber.delegate = self
        
       
        if let registerModel = App.shared.registerModel {
            selectedYourCountry = CountryDatum(id: "588bbd04-1358-4982-9ee8-298d19267ff7", name: "Jordan", iso2: "JO", iso3: "JOR", afexCode: nil, moneyGramCode: nil, moneyGramAnathorCode: nil, moneyGramDescription: nil,moneyGramIncludeSend: nil, moneyGramIncludeReceive: nil, moneyGramIsDirectedSendCountry: nil, eFAWATEERcomCode: nil,eFAWATEERcomDescription: nil, country_code: nil, flag: "https://mobile.alalamifs.com/Media/Flags/128/JO.png")
            
            fieldDesidance.text = "resident".localized
            let url = URL(string: "\(Constants.IMAGE_URL)\("https://mobile.alalamifs.com/Media/Flags/128/JO.png")")
            ivYourCountry.kf.setImage(with: url, placeholder: UIImage(named: ""))
            fieldCountry.text = registerModel.countryOfBirth?.name
            
            // fill the Data if Jordan
            if registerModel.nationality?.iso3 == registerModel.countryOfBirth?.iso3 && registerModel.countryOfBirth?.iso3 == "JOR" {
                let url = URL(string: "\(Constants.IMAGE_URL)\(registerModel.countryOfBirth?.flag ?? "")")
                selectedIssueCountry = registerModel.countryOfBirth
                fieldIssueCountry.text = registerModel.countryOfBirth?.name
                ivIssueCountry.kf.setImage(with: url, placeholder: UIImage(named: ""))
            }else {
                fieldIssueCountry.text = ""
            }
        }
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        self.fillData()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectIdTypeAction(_ sender: Any) {
        self.showLoading()
        self.getApiManager().getIdTypes { (response) in
            self.hideLoading()
            self.idTypeDropdown = DropDown()
            self.idTypeDropdown?.anchorView = self.cvIdType
            var arr = [String]()
            self.idTypes.removeAll()
            self.idTypes.append(contentsOf: self.validateIdTypesByNationality(arr: response.data ?? [IdTypeDatum]()))
            for item in self.idTypes {
                arr.append(item.name ?? "")
            }
            self.idTypeDropdown?.dataSource = arr
            self.idTypeDropdown?.show()
            
            self.idTypeDropdown?.selectionAction = { [unowned self] (index: Int, item: String) in
                self.selectedidType = self.idTypes[index]
                
                self.validateSelectedTimeForImageLabels()
                
                self.fieldIdType.text = self.selectedidType?.name ?? ""
                
                self.cvIdType.backgroundColor = UIColor.card_color
                
                self.validateFields()
            }
        }
    }
    
    func validateSelectedTimeForImageLabels() {
        if (selectedidType?.code ?? "01" == "02") { //passport
            lblFrontImage.text = "passport_image".localized
            lblBackImage.text = "resident_image".localized
        }else {
            lblFrontImage.text = "id_front_side".localized
            lblBackImage.text = "id_back_side".localized
        }
    }
    
    func validateIdTypesByNationality(arr : [IdTypeDatum]) -> [IdTypeDatum] {
        let jordanIdType = arr.filter { (type) -> Bool in
            type.code ?? "" == "01"
        }
        let otherIdTypes = arr.filter { (type) -> Bool in
            type.code ?? "" != "01"
        }
        if (self.isNationalityJordan) {
            fieldIdNumber.placeholder = "id_placeholder_jordan".localized
            return jordanIdType
        }else {
            fieldIdNumber.placeholder = "id_placeholder_other".localized
            return otherIdTypes
        }
    }
    
    @IBAction func selectIssueCountryAction(_ sender: Any) {
        self.countryDest = 1
        
        let idType = self.selectedidType?.code ?? ""
        if (idType == "01") {
            self.openCountryPicker(onlyJordan: true)
        }else {
            self.openCountryPicker(onlyJordan: false)
        }
    }
    
    func openCountryPicker() {
        let vc : SelectCountryVC = self.getStoryBoard(name: Constants.STORYBOARDS.authentication).instantiateViewController(withIdentifier: "SelectCountryVC")
            as! SelectCountryVC
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func openYourCountryPicker() {
        let vc : SelectCountryVC = self.getStoryBoard(name: Constants.STORYBOARDS.authentication).instantiateViewController(withIdentifier: "SelectCountryVC")
            as! SelectCountryVC
        vc.delegate = self
        vc.onlyJordan = true
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func openCountryPicker(onlyJordan : Bool) {
        let vc : SelectCountryVC = self.getStoryBoard(name: Constants.STORYBOARDS.authentication).instantiateViewController(withIdentifier: "SelectCountryVC")
            as! SelectCountryVC
        vc.delegate = self
        vc.onlyJordan = onlyJordan
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func selectIssueDateAction(_ sender: Any) {
        self.dateDest = 1
        self.showDatePicker()
    }
    
    @IBAction func selectExpiryDateAction(_ sender: Any) {
        self.dateDest = 2
        self.showDatePicker()
    }
    
    @IBAction func selectResidenceAction(_ sender: Any) {
        self.residenceDropDown = DropDown()
        self.residenceDropDown?.anchorView = self.cvResidence
        self.residenceDropDown?.dataSource = self.residenceTypes
        self.residenceDropDown?.show()
        
        self.residenceDropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectedResidence = self.residenceTypes[index]
            if (index == 0) {
                self.selectedResidenceValue = true
            }else {
                self.selectedResidenceValue = false
            }
            self.fieldDesidance.text = self.selectedResidence
            self.cvResidence.backgroundColor = UIColor.card_color
            self.validateFields()
        }
    }
    
    @IBAction func selectFrontCardAction(_ sender: Any) {
        self.imageDest = 1
        self.showImagePickerAlert()
    }
    
    @IBAction func selectBackCardAction(_ sender: Any) {
        self.imageDest = 2
        self.showImagePickerAlert()
    }
    
    func showImagePickerAlert() {
        self.showAlertWithCancel(title: "add_image_pic_title".localized, message: "add_image_pic_message".localized, actionTitle: "camera".localized, cancelTitle: "gallery".localized, actionHandler: {
            //camera
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                self.selectImageFrom(.photoLibrary)
                return
            }
            self.selectImageFrom(.camera)
        }) {
            //gallery
            self.imagePicker =  UIImagePickerController()
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func selectYourCountryAction(_ sender: Any) {
        self.countryDest = 2
        openYourCountryPicker()
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if (self.validate()) {
            self.fillData()
            self.pushVC(name: "RegisterStep3", sb: Constants.STORYBOARDS.authentication)
        }
        
    }
    
    
    
    func validate() -> Bool {
        let idNumber = (self.fieldIdNumber.text ?? "").trim().replacedArabicDigitsWithEnglish
        let city = (self.fieldCity.text ?? "").trim()
        let street = (self.fieldStreet.text ?? "").trim()
        let building = (self.fieldBuilding.text ?? "").trim()
        let address = (self.fieldAddress.text ?? "").trim()
        let nationalNumber = (self.fieldNationalNumber.text ?? "").trim().replacedArabicDigitsWithEnglish
        
        
        if (self.selectedidType?.name?.count ?? 0 == 0) {
            self.showBanner(title: "alert".localized, message: "select_id_type".localized, style: UIColor.INFO)
            self.cvIdType.backgroundColor = UIColor.app_red
            return false
        }
        if (self.selectedIssueCountry?.name?.count ?? 0 == 0) {
            self.showBanner(title: "alert".localized, message: "select_issue_country".localized, style: UIColor.INFO)
            self.cvIssueCountry.backgroundColor = UIColor.app_red
            return false
        }
        
        let idType = self.selectedidType?.code ?? ""
        
        if (idNumber.count == 0) {
            if (idType == "01") {
                self.showBanner(title: "alert".localized, message: "enter_valid_id_number_regex".localized, style: UIColor.INFO)
            }else {
                self.showBanner(title: "alert".localized, message: "enter_valid_id_number".localized, style: UIColor.INFO)
            }
            self.cvIdNumber.backgroundColor = UIColor.app_red
            return false
        }
        
        if (!isPureTextNumber(text: idNumber)) {
            self.showBanner(title: "alert".localized, message: "text_regex_idnumber".localized, style: UIColor.INFO)
            self.cvIdNumber.backgroundColor = UIColor.app_red
            return false
        }
        
        if (idType == "01") {
            if (idNumber.count != 8) {
                self.showBanner(title: "alert".localized, message: "enter_valid_id_number_regex".localized, style: UIColor.INFO)
                self.cvIdNumber.backgroundColor = UIColor.app_red
                return false
            }
            if (NSPredicate(format: "SELF MATCHES %@", Constants.ID_NUMBER_REGEX).evaluate(with: idNumber) == false) {
                self.showBanner(title: "alert".localized, message: "enter_valid_id_number_regex".localized, style: UIColor.INFO)
                self.cvIdNumber.backgroundColor = UIColor.app_red
                return false
            }
        }
        if (self.isNationalityJordan == false) {
            if (self.selectedIssueDate.count == 0) {
                self.showBanner(title: "alert".localized, message: "select_issue_date".localized, style: UIColor.INFO)
                self.cvIssueDate.backgroundColor = UIColor.app_red
                return false
            }
        }
        
        if (self.selectedExpiryDate.count == 0) {
            self.showBanner(title: "alert".localized, message: "select_expiry_date".localized, style: UIColor.INFO)
            self.cvExpiryDate.backgroundColor = UIColor.app_red
            return false
        }
        
        if (self.isNationalityJordan) {
            if (nationalNumber.count != 10) {
                self.showBanner(title: "alert".localized, message: "enter_valid_national_number".localized, style: UIColor.INFO)
                self.cvNationalNumber.backgroundColor = UIColor.app_red
                return false
            }
            if (!nationalNumber.isNumeric) {
                self.showBanner(title: "alert".localized, message: "text_regex_nationalnumber".localized, style: UIColor.INFO)
                self.cvNationalNumber.backgroundColor = UIColor.app_red
                return false
            }
        }
        
        //        if (self.selectedResidence?.count ?? 0 == 0) {
        //            self.showBanner(title: "alert".localized, message: "select_residence".localized, style: UIColor.INFO)
        //            self.cvResidence.backgroundColor = UIColor.app_red
        //            return false
        //        }
        
        if (self.idFrontImage == nil) {
            self.showBanner(title: "alert".localized, message: "add_id_front_image".localized, style: UIColor.INFO)
            return false
        }
        if (self.idBackImage == nil) {
            self.showBanner(title: "alert".localized, message: "add_id_back_image".localized, style: UIColor.INFO)
            return false
        }
        
        if (self.selectedYourCountry?.name?.count ?? 0 == 0) {
            self.showBanner(title: "alert".localized, message: "select_your_country".localized, style: UIColor.INFO)
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
        
        if (!isPureText(text: street)) {
            self.showBanner(title: "alert".localized, message: "text_regex_street".localized, style: UIColor.INFO)
            self.cvStreet.backgroundColor = UIColor.app_red
            return false
        }
        
        if (!isPureText(text: building)) {
            self.showBanner(title: "alert".localized, message: "text_regex_building".localized, style: UIColor.INFO)
            self.cvBuilding.backgroundColor = UIColor.app_red
            return false
        }
        
//        if (street.count == 0) {
//            self.showBanner(title: "alert".localized, message: "enter_valid_street".localized, style: UIColor.INFO)
//            self.cvStreet.backgroundColor = UIColor.app_red
//            return false
//        }
//        if (building.count == 0) {
//            self.showBanner(title: "alert".localized, message: "enter_valid_building".localized, style: UIColor.INFO)
//            self.cvBuilding.backgroundColor = UIColor.app_red
//            return false
//        }
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
        return true
    }
    
    
    func validateFields() {
        let idNumber = (self.fieldIdNumber.text ?? "").trim().replacedArabicDigitsWithEnglish
        let city = (self.fieldCity.text ?? "").trim()
        let street = (self.fieldStreet.text ?? "").trim()
        let building = (self.fieldBuilding.text ?? "").trim()
        let address = (self.fieldAddress.text ?? "").trim()
        let nationalNumber = (self.fieldNationalNumber.text ?? "").trim().replacedArabicDigitsWithEnglish
        
        
        if (self.selectedidType?.name?.count ?? 0 == 0) {
            self.enableNext(flag: false)
            return
        }
        if (self.selectedIssueCountry?.name?.count ?? 0 == 0) {
            self.enableNext(flag: false)
            return
        }
        
        if (idNumber.count == 0) {
            self.enableNext(flag: false)
            return
        }
        if (!isPureTextNumber(text: idNumber)) {
            self.enableNext(flag: false)
            return
        }
        
        let idType = self.selectedidType?.code ?? ""
        
        if (idType == "01") {
            if (idNumber.count != 8) {
                self.enableNext(flag: false)
                return
            }
            if (NSPredicate(format: "SELF MATCHES %@", Constants.ID_NUMBER_REGEX).evaluate(with: idNumber) == false) {
                self.enableNext(flag: false)
                return
            }
        }
        
        
        if (self.isNationalityJordan == false) {
            if (self.selectedIssueDate.count == 0) {
                self.enableNext(flag: false)
                return
            }
        }
        
        if (self.selectedExpiryDate.count == 0) {
            self.enableNext(flag: false)
            return
        }
        if (self.isNationalityJordan) {
            if (nationalNumber.count != 10) {
                self.enableNext(flag: false)
                return
            }
            if (!nationalNumber.isNumeric) {
                self.enableNext(flag: false)
                return
            }
        }
        
        //        if (self.selectedResidence?.count ?? 0 == 0) {
        //            self.enableNext(flag: false)
        //            return
        //        }
        
        if (self.idFrontImage == nil) {
            self.enableNext(flag: false)
            return
        }
        if (self.idBackImage == nil) {
            self.enableNext(flag: false)
            return
        }
        
        if (self.selectedYourCountry?.id?.count ?? 0 == 0) {
            self.enableNext(flag: false)
            return
        }
        
        if (city.count == 0) {
            self.enableNext(flag: false)
            return
        }
        if (!isPureText(text: [city, building, street, address])) {
            self.enableNext(flag: false)
            return
        }
//        if (street.count == 0) {
//            self.enableNext(flag: false)
//            return
//        }
//        if (building.count == 0) {
//            self.enableNext(flag: false)
//            return
//        }
        if (address.count == 0) {
            self.enableNext(flag: false)
            return
        }
        self.enableNext(flag: true)
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
    
    //fields observers
    @IBAction func idChanged(_ sender: Any) {
        self.validateFields()
    }
    @IBAction func cityChanged(_ sender: Any) {
        self.validateFields()
    }
    @IBAction func streetChanged(_ sender: Any) {
        self.validateFields()
    }
    @IBAction func buildingChanged(_ sender: Any) {
        self.validateFields()
    }
    @IBAction func addressChanged(_ sender: Any) {
        self.validateFields()
    }
    
    
    func fillData() {
        if (App.shared.registerModel == nil) {
            App.shared.registerModel = RegisterModel()
        }
        App.shared.registerModel?.idType = self.selectedidType
        App.shared.registerModel?.idIssueCountry = self.selectedIssueCountry
        App.shared.registerModel?.idNumber = (self.fieldIdNumber.text ?? "").trim()
        App.shared.registerModel?.idIssueDate = self.selectedIssueDate
        App.shared.registerModel?.idExpiryDate = self.selectedExpiryDate
        App.shared.registerModel?.residence = self.selectedResidenceValue
        App.shared.registerModel?.frontIdImage = self.idFrontImage
        App.shared.registerModel?.backIdImage = self.idBackImage
        App.shared.registerModel?.yourCountry = self.selectedYourCountry
        App.shared.registerModel?.city = (self.fieldCity.text ?? "").trim()
        App.shared.registerModel?.street = (self.fieldStreet.text ?? "").trim()
        App.shared.registerModel?.building = (self.fieldBuilding.text ?? "").trim()
        App.shared.registerModel?.address = (self.fieldAddress.text ?? "").trim()
        App.shared.registerModel?.nationalNumber = (self.fieldNationalNumber.text ?? "").trim()
        
    }
    
    func retreiveData() {
        let mModel = App.shared.registerModel
        self.selectedidType = mModel?.idType
        self.fieldIdType.text = self.selectedidType?.name ?? ""
        
        self.selectedIssueCountry = mModel?.idIssueCountry
        self.fieldIssueCountry.text = self.selectedIssueCountry?.name ?? ""
        
        self.fieldNationalNumber.text = mModel?.nationalNumber ?? ""
        
        self.fieldIdNumber.text = mModel?.idNumber ?? ""
        
        self.selectedIssueDate = mModel?.idIssueDate ?? ""
        self.fieldIssueDate.text = self.getStringDateWithFormat(dateStr: self.selectedIssueDate, outputFormat: Constants.DATE_FORMATS.dd_mm_yyyy)
        
        self.selectedExpiryDate = mModel?.idExpiryDate ?? ""
        self.fieldExpiryDate.text = self.getStringDateWithFormat(dateStr: self.selectedExpiryDate, outputFormat: Constants.DATE_FORMATS.dd_mm_yyyy)
        
        self.selectedResidenceValue = mModel?.residence ?? true
        if (self.selectedResidenceValue) {
            self.fieldDesidance.text = "resident".localized
        }else {
            self.fieldDesidance.text = "not_resident".localized
        }
        
        self.idFrontImage = mModel?.frontIdImage
        self.ivFrontCard.image = self.idFrontImage
        
        self.idBackImage = mModel?.backIdImage
        self.ivBackCard.image = self.idBackImage
        
        self.selectedYourCountry = mModel?.yourCountry
        self.fieldCountry.text = mModel?.yourCountry?.name ?? ""
        
        self.fieldCity.text = mModel?.city ?? ""
        self.fieldStreet.text = mModel?.street ?? ""
        self.fieldBuilding.text = mModel?.building ?? ""
        self.fieldAddress.text = mModel?.address ?? ""
        
        
        //validate nationality logic
        let nationality = App.shared.registerModel?.nationality
        let nationalityName = nationality?.name?.lowercased().trim() ?? ""
        if (nationalityName.contains(find: "jordan") || nationalityName.contains(find: "اردن")) {
            self.viewNationalNumber.isHidden = false
            self.viewIssueDate.isHidden = true
            self.isNationalityJordan = true
            fieldIdNumber.placeholder = "id_placeholder_jordan".localized
        }else {
            self.viewNationalNumber.isHidden = true
            self.viewIssueDate.isHidden = false
            self.isNationalityJordan = false
            fieldIdNumber.placeholder = "id_placeholder_other".localized
        }
        
        
        self.validateFields()
        
        
        
    }
    
    
}


extension RegisterStep2 : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.fieldIdNumber) {
            self.cvIdNumber.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldStreet) {
            self.cvStreet.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldBuilding) {
            self.cvBuilding.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldAddress) {
            self.cvAddress.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldCity) {
            self.cvCity.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldNationalNumber) {
            self.cvNationalNumber.backgroundColor = UIColor.card_focused_color
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == self.fieldIdNumber) {
            self.cvIdNumber.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldStreet) {
            self.cvStreet.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldBuilding) {
            self.cvBuilding.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldAddress) {
            self.cvAddress.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldCity) {
            self.cvCity.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldNationalNumber) {
            self.cvNationalNumber.backgroundColor = UIColor.card_color
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == self.fieldIdNumber) {
            self.fieldIdNumber.resignFirstResponder()
        }else if (textField == self.fieldCity) {
            self.fieldStreet.becomeFirstResponder()
        }else if (textField == self.fieldStreet) {
            self.fieldBuilding.becomeFirstResponder()
        }else if (textField == self.fieldBuilding) {
            self.fieldAddress.becomeFirstResponder()
        }else if (textField == self.fieldAddress) {
            self.fieldAddress.resignFirstResponder()
        }else if (textField == self.fieldNationalNumber) {
            self.fieldNationalNumber.resignFirstResponder()
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.fieldIdNumber {
            var maxLength = 20
            if (self.selectedidType?.code ?? "" == "01") {
                maxLength = 8
            }
            let currentString: NSString = textField.text as NSString? ?? ""
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            
            return newString.length <= maxLength
        }else if textField == self.fieldNationalNumber {
            let maxLength = 10
            let currentString: NSString = textField.text as NSString? ?? ""
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            
            return newString.length <= maxLength
        }else {
            return true
        }
    }
    
}


extension RegisterStep2: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        switch self.imageDest {
        case 1:
            self.idFrontImage = selectedImage
            self.ivFrontCard.image = selectedImage
            break
        case 2:
            self.idBackImage = selectedImage
            self.ivBackCard.image = selectedImage
            break
        default:
            self.idFrontImage = selectedImage
            self.ivFrontCard.image = selectedImage
            
            break
        }
        self.validateFields()
    }
}

extension RegisterStep2 : CountryDelegate {
    func didSelectCountry(country: CountryDatum) {
        if (self.countryDest == 1) { //issue country
            self.selectedIssueCountry = country
            self.fieldIssueCountry.text = country.name ?? ""
            let url = URL(string: "\(Constants.IMAGE_URL)\(country.flag ?? "")")
            ivIssueCountry.kf.setImage(with: url, placeholder: UIImage(named: ""))
            self.cvIssueCountry.backgroundColor = UIColor.card_color
        }else { //your country
            self.selectedYourCountry = country
            self.fieldCountry.text = country.name ?? ""
            let url = URL(string: "\(Constants.IMAGE_URL)\(country.flag ?? "")")
            ivYourCountry.kf.setImage(with: url, placeholder: UIImage(named: ""))
            self.cvCountry.backgroundColor = UIColor.card_color
        }
        self.validateFields()
    }
}


extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}

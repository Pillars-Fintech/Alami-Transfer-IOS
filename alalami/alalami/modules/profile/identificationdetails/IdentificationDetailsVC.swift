//
//  IdentificationDetailsVC.swift
//  alalami
//
//  Created by Zaid Khaled on 10/1/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit
import DatePickerDialog
import DropDown
import Kingfisher

class IdentificationDetailsVC: BaseVC, UINavigationControllerDelegate {
    
    @IBOutlet weak var lIdentificationDetails: MyUILabel!
    
    
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
    
    
    @IBOutlet weak var lAdded: MyUILabel!
    
    
    
    //date picker
    var dateDest = 1
    
    
    //residence
    @IBOutlet weak var cvResidence: CardView!
    @IBOutlet weak var fieldDesidance: MyUITextField!
    var residenceTypes = ["resident".localized, "not_resident".localized]
    var residenceDropDown : DropDown?
    var selectedResidence : String?
    var selectedResidenceValue : Bool?
    
    
    //gender
    @IBOutlet weak var fieldGender: MyUITextField!
    @IBOutlet weak var cvGender: CardView!
    var genderTypes = ["male".localized, "female".localized]
    var genderDropDown : DropDown?
    var selectedGender : String?
    var selectedGenderValue : Int?
    
    
    //cards
    @IBOutlet weak var ivFrontCard: CorneredImage!
    @IBOutlet weak var ivBackCard: CorneredImage!
    var idFrontImage : UIImage?
    var idBackImage : UIImage?
    
    @IBOutlet weak var lblFrontImage: MyUILabel!
    @IBOutlet weak var lblBackImage: MyUILabel!
    
 
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
            maxDate = Date()
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
    
    //next
    @IBOutlet weak var cvNext: CardView!
    @IBOutlet weak var btnNext: MyUIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
        }
        lIdentificationDetails.textAlignment = .right
        lblFrontImage.textAlignment = .natural
        lblBackImage.textAlignment = .natural
        lAdded.textAlignment = .natural

        if (isArabic()) {
            lIdentificationDetails.textAlignment = .right
            lblFrontImage.textAlignment = .right
            lblBackImage.textAlignment = .right
            lAdded.textAlignment = .right

            
        }else{
            lIdentificationDetails.textAlignment = .left
            lblFrontImage.textAlignment = .left
            lblBackImage.textAlignment = .left
            lAdded.textAlignment = .left

            
            
        }
        
        
        
        self.fieldIdNumber.delegate = self
        self.fieldNationalNumber.delegate = self
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
        //id type
        var idTypeName = accountData?.identityTypeNameEn ?? ""
        if (self.isArabic()) {
            idTypeName = accountData?.identityTypeNameAr ?? ""
        }
        self.selectedidType = IdTypeDatum(id: accountData?.identityTypeID ?? "", clientTypeID: 0, code: "", name: idTypeName, moneyGramCode: "", moneyGramDescription: "", eFAWATEERcomCode: "", eFAWATEERcomDescription: "")
        self.fieldIdType.text = idTypeName
        
        //flags
        let issueCountryUrl = URL(string: "\(Constants.IMAGE_URL)\(accountData?.IdentityIssueCountryFlagUrl ?? "")")
        ivIssueCountry.kf.setImage(with: issueCountryUrl, placeholder: UIImage(named: ""))
        
        //issue country
        var issueCountryName = accountData?.identityIssueCountryNameEn ?? ""
        if (self.isArabic()) {
            issueCountryName = accountData?.identityIssueCountryNameAr ?? ""
        }
        
        self.selectedIssueCountry = CountryDatum(id: accountData?.identityIssueCountryID ?? "", name: issueCountryName, iso2: "", iso3: "", afexCode: 0, moneyGramCode: "", moneyGramAnathorCode: "", moneyGramDescription: "", moneyGramIncludeSend: false, moneyGramIncludeReceive: false, moneyGramIsDirectedSendCountry: false, eFAWATEERcomCode: "", eFAWATEERcomDescription: "", country_code: "", flag: "")
        self.fieldIssueCountry.text = issueCountryName
        
        //id number
        self.fieldIdNumber.text = accountData?.identityNumber ?? ""
        
        //id issue date
        self.selectedIssueDate = accountData?.identityIssueData ?? ""
        self.fieldIssueDate.text = self.getStringDateWithFormat(dateStr: self.selectedIssueDate, outputFormat: Constants.DATE_FORMATS.dd_mm_yyyy)
        
        //id expiry date
        self.selectedExpiryDate = accountData?.identityExpireDate ?? ""
        self.fieldExpiryDate.text = self.getStringDateWithFormat(dateStr: self.selectedExpiryDate, outputFormat: Constants.DATE_FORMATS.dd_mm_yyyy)
        
        //residance
        if (accountData?.resident ?? false) {
            self.selectedResidence = "resident".localized
            self.selectedResidenceValue = true
        }else {
            self.selectedResidence = "not_resident".localized
            self.selectedResidenceValue = false
        }
        self.fieldDesidance.text = self.selectedResidence
        
        self.fieldNationalNumber.text = accountData?.nationalNumber ?? ""
        
        //gender
        //fill gender data here
        
        //front card image
        if let frontUrl = URL(string: "\(Constants.IMAGE_URL)\(accountData?.identityFrontImage ?? "")") {
            self.ivFrontCard.kf.setImage(with: frontUrl)
            let frontResource = ImageResource(downloadURL: frontUrl)
            KingfisherManager.shared.retrieveImage(with: frontResource, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    self.idFrontImage = value.image
                    self.validateFields()
                case .failure:
                    self.idFrontImage = nil
                }
            }
        }
        
        //back card image
        if let backUrl = URL(string: "\(Constants.IMAGE_URL)\(accountData?.identityBackImage ?? "")") {
            self.ivBackCard.kf.setImage(with: backUrl)
            let backResource = ImageResource(downloadURL: backUrl)
            KingfisherManager.shared.retrieveImage(with: backResource, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    self.idBackImage = value.image
                    self.validateFields()
                case .failure:
                    self.idBackImage = nil
                }
            }
        }
        
        //        //validate nationality logic
        //        if (accountData?.nationalNumber?.count ?? 0 > 0) {
        //            self.viewNationalNumber.isHidden = false
        //            self.viewIssueDate.isHidden = true
        //            self.isNationalityJordan = true
        //            fieldIdNumber.placeholder = "id_placeholder_jordan".localized
        //        }else {
        //            self.viewNationalNumber.isHidden = true
        //            self.viewIssueDate.isHidden = false
        //            self.isNationalityJordan = false
        //            fieldIdNumber.placeholder = "id_placeholder_other".localized
        //        }
        
        
    }
    
    @IBAction func backAction(_ sender: Any) {
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
            return jordanIdType
        }else {
            return otherIdTypes
        }
    }
    
    @IBAction func selectIssueCountryAction(_ sender: Any) {
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
            self.fieldDesidance.text = self.selectedResidence ?? ""
            self.cvResidence.backgroundColor = UIColor.card_color
            self.validateFields()
        }
    }
    
    @IBAction func selectGenderAction(_ sender: Any) {
        self.genderDropDown = DropDown()
        self.genderDropDown?.anchorView = self.cvGender
        self.genderDropDown?.dataSource = self.genderTypes
        self.genderDropDown?.show()
        
        self.genderDropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectedGender = self.genderTypes[index]
            if (index == 0) {
                self.selectedGenderValue = 1
            }else {
                self.selectedGenderValue = 2
            }
            self.fieldGender.text = self.selectedGender ?? ""
            self.cvGender.backgroundColor = UIColor.card_color
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
        self.openCountryPicker()
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if (self.validate()) {
            //update account identification details
            self.showLoading()
            self.getApiManager().updateIdentificationDetails(token: self.getAccessToken(), idTypeId: self.selectedidType?.id ?? "", idIssueCountryId: self.selectedIssueCountry?.id ?? "", idNumber: (self.fieldIdNumber.text ?? "").trim(), idIssueDate: self.selectedIssueDate, idExpiryDate: self.selectedExpiryDate, nationalNumber: (self.fieldNationalNumber.text ?? "").trim(), residence: self.selectedResidenceValue ?? false, gender: self.selectedGenderValue ?? 1, idFrontImage: self.idFrontImage, idBackImage: self.idBackImage) { (response) in
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
    
    func validate() -> Bool {
        let idNumber = (self.fieldIdNumber.text ?? "").trim().replacedArabicDigitsWithEnglish
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
            if (nationalNumber.count == 0) {
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
        return true
    }
    
    
    func validateFields() {
        let idNumber = (self.fieldIdNumber.text ?? "").trim().replacedArabicDigitsWithEnglish
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
        
        let idType = self.selectedidType?.code ?? ""
        
        if (!isPureTextNumber(text: idNumber)) {
            self.enableNext(flag: false)
            return
        }
        
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
            if (nationalNumber.count == 0) {
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
    
}


extension IdentificationDetailsVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.fieldIdNumber) {
            self.cvIdNumber.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldNationalNumber) {
            self.cvNationalNumber.backgroundColor = UIColor.card_focused_color
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == self.fieldIdNumber) {
            self.cvIdNumber.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldNationalNumber) {
            self.cvNationalNumber.backgroundColor = UIColor.card_color
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == self.fieldIdNumber) {
            self.fieldIdNumber.resignFirstResponder()
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
        } else {
            return true
        }
    }
    
    
}


extension IdentificationDetailsVC: UIImagePickerControllerDelegate {
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

extension IdentificationDetailsVC : CountryDelegate {
    func didSelectCountry(country: CountryDatum) {
        self.selectedIssueCountry = country
        self.fieldIssueCountry.text = country.name ?? ""
        let url = URL(string: "\(Constants.IMAGE_URL)\(country.flag ?? "")")
        ivIssueCountry.kf.setImage(with: url, placeholder: UIImage(named: ""))
        self.cvIssueCountry.backgroundColor = UIColor.card_color
        self.validateFields()
    }
}

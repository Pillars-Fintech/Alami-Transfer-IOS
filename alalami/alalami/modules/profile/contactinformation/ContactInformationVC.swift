//
//  ContactInformationVC.swift
//  alalami
//
//  Created by Zaid Khaled on 10/1/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit
import Kingfisher

class ContactInformationVC: BaseVC , UINavigationControllerDelegate {
    
    @IBOutlet weak var lContactInformation: MyUILabel!
    
    
    @IBOutlet weak var btnBack: UIButton!
    
    
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
    
    //phone
    @IBOutlet weak var cvPhone: CardView!
    @IBOutlet weak var fieldPhone: MyUITextField!
    
    
    //country code
    @IBOutlet weak var lblCountryCode: MyUILabel!
    @IBOutlet weak var ivCountryCode: UIImageView!
    
    
    //mobile number
    @IBOutlet weak var cvMobile: CardView!
    @IBOutlet weak var fieldMobile: MyUITextField!
    
    
    //email
    @IBOutlet weak var cvEmail: CardView!
    @IBOutlet weak var fieldEmail: MyUITextField!
    
    
    //your face image
    @IBOutlet weak var ivFace: CorneredImage!
    var faceImage : UIImage?
    
    @IBOutlet weak var lImage: MyUILabel!
    
    @IBOutlet weak var lInformationImage: MyUILabel!
    
    
    //image picker
    
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
    
    
    
    //next
    @IBOutlet weak var cvNext: CardView!
    @IBOutlet weak var btnNext: MyUIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        
        
        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
        }
        
        lContactInformation.textAlignment = .natural
        lImage.textAlignment = .natural
        lInformationImage.textAlignment = .natural
        
        if (isArabic()) {
            lContactInformation.textAlignment = .right
            lImage.textAlignment = .right
            lInformationImage.textAlignment = .right
        }else{
            lContactInformation.textAlignment = .left
            lImage.textAlignment = .left
            lInformationImage.textAlignment = .left
        }
        
        
        
        
        self.fieldCity.delegate = self
        self.fieldStreet.delegate = self
        self.fieldBuilding.delegate = self
        self.fieldAddress.delegate = self
        self.fieldMobile.delegate = self
       // self.fieldPhone.delegate = self
        self.fieldEmail.delegate = self
        
        self.loadProfileInfo()
        setDefaultCountryCode()
    }
    
    private func setDefaultCountryCode() {
        lblCountryCode.text = "+962"
        let url = URL(string: "\(Constants.IMAGE_URL)\(App.shared.config?.configString?.jordanFlag ?? "")")
        ivCountryCode.kf.setImage(with: url, placeholder: UIImage(named: ""))
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
        
        //country
        var countryOfBirthName = accountData?.countryNameEn ?? ""
        if (self.isArabic()) {
            countryOfBirthName = accountData?.countryNameAr ?? ""
        }
        
        self.selectedYourCountry = CountryDatum(id: accountData?.countryOfBirthID ?? "", name: countryOfBirthName, iso2: "", iso3: "", afexCode: 0, moneyGramCode: "", moneyGramAnathorCode: "", moneyGramDescription: "", moneyGramIncludeSend: false, moneyGramIncludeReceive: false, moneyGramIsDirectedSendCountry: false, eFAWATEERcomCode: "", eFAWATEERcomDescription: "", country_code: "", flag: "")
        
        self.fieldCountry.text = countryOfBirthName
        
        //flags
        let yourCountryUrl = URL(string: "\(Constants.IMAGE_URL)\(accountData?.CountryFlagURL ?? "")")
        ivYourCountry.kf.setImage(with: yourCountryUrl, placeholder: UIImage(named: ""))
        
        //city
        self.fieldCity.text = accountData?.city ?? ""
        self.fieldStreet.text = accountData?.street ?? ""
        self.fieldBuilding.text = accountData?.building ?? ""
        self.fieldAddress.text = accountData?.address ?? ""
       // self.fieldPhone.text = accountData?.phone ?? ""
        self.fieldMobile.text = accountData?.mobile ?? ""
        self.fieldEmail.text = accountData?.emailAddress ?? ""
        
        
        //face image
        if let faceUrl = URL(string: "\(Constants.IMAGE_URL)\(accountData?.profileImage ?? "")") {
            self.ivFace.kf.setImage(with: faceUrl)
            let faceResource = ImageResource(downloadURL: faceUrl)
            KingfisherManager.shared.retrieveImage(with: faceResource, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    self.faceImage = value.image
                    self.validateFields()
                case .failure:
                    self.faceImage = nil
                }
            }
        }
        
        self.validateFields()
    }
    
    
    func showImagePickerAlert() {
        self.showAlert(title: "add_image_pic_title".localized, message: "add_image_pic_message_no_gallery".localized, actionTitle: "camera".localized, cancelTitle: "cancel".localized, actionHandler: {
            //camera
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                self.selectImageFrom(.photoLibrary)
                return
            }
            self.selectImageFrom(.camera)
        }) {
            //dismiss
        }
    }
     
    @IBAction func selectYourCountryAction(_ sender: Any) {
        self.openCountryPicker()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func openCountryPicker() {
        let vc : SelectCountryVC = self.getStoryBoard(name: Constants.STORYBOARDS.authentication).instantiateViewController(withIdentifier: "SelectCountryVC")
            as! SelectCountryVC
        vc.delegate = self
        vc.onlyJordan = true
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func selectCountryCodeAction(_ sender: Any) {
        let vc : CountryCodesVC = self.getStoryBoard(name: Constants.STORYBOARDS.authentication).instantiateViewController(withIdentifier: "CountryCodesVC") as! CountryCodesVC
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func selectFaceImage(_ sender: Any) {
        self.showImagePickerAlert()
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
    
    @IBAction func mobileChanged(_ sender: Any) {
        self.validateFields()
    }
    
    
    func validate() -> Bool {
        let city = (self.fieldCity.text ?? "").trim()
        let street = (self.fieldStreet.text ?? "").trim()
        let building = (self.fieldBuilding.text ?? "").trim()
        let address = (self.fieldAddress.text ?? "").trim()
        let mobile = (self.fieldMobile.text ?? "").trim()
       // let phone = (self.fieldPhone.text ?? "").trim()
        let email = (self.fieldEmail.text ?? "").trim()
        
        if (mobile.count == 0) {
            self.showBanner(title: "alert".localized, message: "enter_valid_mobile".localized, style: UIColor.INFO)
            self.cvMobile.backgroundColor = UIColor.app_red
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
        if (street.count == 0) {
            self.showBanner(title: "alert".localized, message: "enter_valid_street".localized, style: UIColor.INFO)
            self.cvStreet.backgroundColor = UIColor.app_red
            return false
        }
        if (!isPureText(text: street)) {
            self.showBanner(title: "alert".localized, message: "text_regex_street".localized, style: UIColor.INFO)
            self.cvStreet.backgroundColor = UIColor.app_red
            return false
        }
        if (building.count == 0) {
            self.showBanner(title: "alert".localized, message: "enter_valid_building".localized, style: UIColor.INFO)
            self.cvBuilding.backgroundColor = UIColor.app_red
            return false
        }
        if (!isPureText(text: building)) {
            self.showBanner(title: "alert".localized, message: "text_regex_building".localized, style: UIColor.INFO)
            self.cvBuilding.backgroundColor = UIColor.app_red
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
        
        if (mobile.count < 9 || mobile.count > 10) {
            self.showBanner(title: "alert".localized, message: "enter_valid_mobile".localized, style: UIColor.INFO)
            self.cvMobile.backgroundColor = UIColor.app_red
            return false
        }
        if (!mobile.isNumeric) {
            self.showBanner(title: "alert".localized, message: "text_regex_mobile".localized, style: UIColor.INFO)
            self.cvCity.backgroundColor = UIColor.app_red
            return false
        }
        
        if (email.count == 0) {
            self.showBanner(title: "alert".localized, message: "enter_email_address".localized, style: UIColor.INFO)
            self.cvEmail.backgroundColor = UIColor.app_red
            return false
        }
        
        if (email.isValidEmail() == false) {
            self.showBanner(title: "alert".localized, message: "enter_valid_email".localized, style: UIColor.INFO)
            self.cvEmail.backgroundColor = UIColor.app_red
            return false
        }
        
        
        if (self.faceImage == nil) {
            self.showBanner(title: "alert".localized, message: "add_face_image".localized, style: UIColor.INFO)
            return false
        }
        
        
        return true
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
    
    func validateFields() {
        let city = (self.fieldCity.text ?? "").trim()
        let street = (self.fieldStreet.text ?? "").trim()
        let building = (self.fieldBuilding.text ?? "").trim()
        let address = (self.fieldAddress.text ?? "").trim()
        let mobile = (self.fieldMobile.text ?? "").trim()
        let phone = (self.fieldPhone.text ?? "").trim()
        let email = (self.fieldEmail.text ?? "").trim()
        
        
        if (self.selectedYourCountry?.name?.count ?? 0 == 0) {
            self.enableNext(flag: false)
            return
        }
        
        if (city.count == 0) {
            self.enableNext(flag: false)
            return
        }
        if (street.count == 0) {
            self.enableNext(flag: false)
            return
        }
        
        if (!isPureText(text: [city, street, building, address])) {
            self.enableNext(flag: false)
            return
        }
        
        if (!mobile.isNumeric) {
            self.enableNext(flag: false)
            return
        }
        
        if (building.count == 0) {
            self.enableNext(flag: false)
            return
        }
        if (address.count == 0) {
            self.enableNext(flag: false)
            return
        }
        
        if (mobile.count < 9 || mobile.count > 10) {
            self.enableNext(flag: false)
            return
        }
        
        if (email.count == 0) {
            self.enableNext(flag: false)
            return
        }
        
        if (email.isValidEmail() == false) {
            self.enableNext(flag: false)
            return
        }
        
        if (self.faceImage == nil) {
            self.enableNext(flag: false)
            return
        }
        
        var isValidMobile = false
        let isMobileCharsCorrect = (mobile.count == 9 || mobile.count == 10)
        let englishStartCheck = mobile.starts(with: "0") || mobile.starts(with: "7") || mobile.starts(with: "07")
        let arabicMobileCheck = mobile.starts(with: "٠") || mobile.starts(with: "٧") || mobile.starts(with: "٠٧")
        if ((englishStartCheck || arabicMobileCheck) && isMobileCharsCorrect) {
            isValidMobile = true
        }else {
            isValidMobile = false
        }
        
        if (isValidMobile == false) {
            self.enableNext(flag: false)
            return
        }
        
        self.enableNext(flag: true)
    }
    
    @IBAction func continueAction(_ sender: Any) {
        if (validate()) {
            //save contact info api
            self.showLoading()
            self.getApiManager().updateContactInformation(token: self.getAccessToken(), countryId: self.selectedYourCountry?.id ?? "", city: (self.fieldCity.text ?? "").trim(), street: (self.fieldStreet.text ?? "").trim(), building: (self.fieldBuilding.text ?? "").trim(), address: (self.fieldAddress.text ?? "").trim(), phone: "", faceImage: self.faceImage) { (response) in
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
    
}


extension ContactInformationVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.fieldStreet) {
            self.cvStreet.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldBuilding) {
            self.cvBuilding.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldAddress) {
            self.cvAddress.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldCity) {
            self.cvCity.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldMobile) {
            self.cvMobile.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldEmail) {
            self.cvEmail.backgroundColor = UIColor.card_focused_color
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == self.fieldStreet) {
            self.cvStreet.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldBuilding) {
            self.cvBuilding.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldAddress) {
            self.cvAddress.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldCity) {
            self.cvCity.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldMobile) {
            self.cvMobile.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldEmail) {
            self.cvEmail.backgroundColor = UIColor.card_color
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == self.fieldCity) {
            self.fieldStreet.becomeFirstResponder()
        }else if (textField == self.fieldStreet) {
            self.fieldBuilding.becomeFirstResponder()
        }else if (textField == self.fieldBuilding) {
            self.fieldAddress.becomeFirstResponder()
        }else if (textField == self.fieldAddress) {
            self.fieldAddress.resignFirstResponder()
        }else if (textField == self.fieldMobile) {
            self.fieldEmail.becomeFirstResponder()
        }else if (textField == self.fieldEmail) {
            self.fieldEmail.resignFirstResponder()
        }
        return false
    }
    
}


extension ContactInformationVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        self.faceImage = selectedImage
        self.ivFace.image = selectedImage
        self.validateFields()
    }
}

extension ContactInformationVC : CountryDelegate {
    func didSelectCountry(country: CountryDatum) {
        self.selectedYourCountry = country
        self.fieldCountry.text = country.name ?? ""
        let url = URL(string: "\(Constants.IMAGE_URL)\(country.flag ?? "")")
        ivYourCountry.kf.setImage(with: url, placeholder: UIImage(named: ""))
        self.cvCountry.backgroundColor = UIColor.card_color
        self.validateFields()
    }
}

extension ContactInformationVC : CountryCodeDelegate {
    func didSelectCountry(code: CountryCodeDatum) {
        var codeStr = code.postCode ?? ""
        if (codeStr.starts(with: "00")) {
            codeStr = String(codeStr.dropFirst(2))
        }
        let url = URL(string: "\(Constants.IMAGE_URL)\(code.flag ?? "")")
        ivCountryCode.kf.setImage(with: url, placeholder: UIImage(named: ""))
        
        self.lblCountryCode.text = "+\(codeStr)"
    }
}

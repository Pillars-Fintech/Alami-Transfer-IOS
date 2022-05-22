//
//  RegisterStep3.swift
//  alalami
//
//  Created by Zaid Khaled on 8/31/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit
import DropDown

class RegisterStep3: BaseVC, UINavigationControllerDelegate {
    
    @IBOutlet weak var lImage: MyUILabel!
    
    @IBOutlet weak var lVideo: MyUILabel!
    
    @IBOutlet weak var lUploadeVideo: MyUILabel!
    
    
    @IBOutlet weak var lRegister: MyUILabel!
    
    @IBOutlet weak var desPassword: MyUILabel!
    
    @IBOutlet weak var btnBack: UIButton!
    
    //country code
    @IBOutlet weak var lblCountryCode: MyUILabel!
    @IBOutlet weak var ivCountryCode: UIImageView!
    
    //mobile number
    @IBOutlet weak var cvMobile: CardView!
    @IBOutlet weak var fieldMobile: MyUITextField!
    
    //username
    @IBOutlet weak var fieldUsername: MyUITextField!
    
    
    //phone
    @IBOutlet weak var cvPhone: CardView!
    @IBOutlet weak var fieldPhone: MyUITextField!
    
    //email
    @IBOutlet weak var cvEmail: CardView!
    @IBOutlet weak var fieldEmail: MyUITextField!
    
    //password
    @IBOutlet weak var cvPassword: CardView!
    @IBOutlet weak var fieldPassword: MyUITextField!
    @IBOutlet weak var btnPasswordVisibility: UIButton!
    var isPassVisible : Bool = false
    
    
    //confirm password
    @IBOutlet weak var cvConfirmPassword: CardView!
    @IBOutlet weak var fieldConfirmPassword: MyUITextField!
    @IBOutlet weak var btnConfirmPasswordVisibility: UIButton!
    var isConfirmPassVisible : Bool = false
    
    //video
    @IBOutlet weak var ivVideo: CorneredImage!
    var videoUrl : URL?
    
    //your face image
    @IBOutlet weak var ivFace: CorneredImage!
    var faceImage : UIImage?
    
    @IBOutlet weak var lKeep: MyUILabel!
    
    @IBOutlet weak var lHereby: MyUILabel!
    
    
    
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
    
    //reason of reg
    @IBOutlet weak var cvReason: CardView!
    @IBOutlet weak var fieldReason: MyUITextField!
    var reasons = [ReasonOfRegDatum]()
    var reasonsDropDown : DropDown?
    var selectedReason : ReasonOfRegDatum?
    
    //keep me updated
    @IBOutlet weak var ivKeepMeUpdated: UIImageView!
    var keepMeUpdated = true
    
    
    //hereby agreement
    @IBOutlet weak var ivHereby: UIImageView!
    var agreeHereby = false
    
    
    //create account action
    @IBOutlet weak var cvCreate: CardView!
    @IBOutlet weak var btnCreate: MyUIButton!
    
    //terms & conditions
    @IBOutlet weak var ivAgreeTerms: UIImageView!
    var agreeTerms = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
        }
        
        
        lRegister.textAlignment = .natural
        lImage.textAlignment = .natural
        lVideo.textAlignment = .natural
        lUploadeVideo.textAlignment = .natural
        desPassword.textAlignment = .natural
        lKeep.textAlignment = .natural
        lHereby.textAlignment = .natural
        
        if (isArabic()) {
            lRegister.textAlignment = .right
            lImage.textAlignment = .right
            lVideo.textAlignment = .right
            lUploadeVideo.textAlignment = .right
            desPassword.textAlignment = .right
            lKeep.textAlignment = .right
            lHereby.textAlignment = .right
        }else{
            lRegister.textAlignment = .right
            lImage.textAlignment = .right
            lVideo.textAlignment = .right
            lUploadeVideo.textAlignment = .right
            desPassword.textAlignment = .right
            lKeep.textAlignment = .right
            lHereby.textAlignment = .right
        }
        
        
        
        
        
        self.retreiveData()
        
        self.fieldMobile.delegate = self
        //  self.fieldPhone.delegate = self
//        self.fieldEmail.delegate = self
        self.fieldPassword.delegate = self
        self.fieldConfirmPassword.delegate = self
        
        setDefaultCountryCode()
    }
    
    private func setDefaultCountryCode() {
        lblCountryCode.text = "+962"
        let url = URL(string: "\(Constants.IMAGE_URL)\(App.shared.config?.configString?.jordanFlag ?? "")")
        ivCountryCode.kf.setImage(with: url, placeholder: UIImage(named: ""))
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
    
    @IBAction func backAction(_ sender: Any) {
        self.fillData()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectCountryCodeAction(_ sender: Any) {
        let vc : CountryCodesVC = self.getStoryBoard(name: Constants.STORYBOARDS.authentication).instantiateViewController(withIdentifier: "CountryCodesVC") as! CountryCodesVC
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func passwordVisibilityAction(_ sender: Any) {
        if (self.isPassVisible) {
            self.btnPasswordVisibility.setImage(UIImage(named: "ic_show"), for: .normal)
            self.fieldPassword.isSecureTextEntry = true
            self.isPassVisible = false
        }else {
            self.btnPasswordVisibility.setImage(UIImage(named: "ic_hide"), for: .normal)
            self.fieldPassword.isSecureTextEntry = false
            self.isPassVisible = true
        }
    }
    
    @IBAction func confirmPasswordVisibilityAction(_ sender: Any) {
        if (self.isConfirmPassVisible) {
            self.btnConfirmPasswordVisibility.setImage(UIImage(named: "ic_show"), for: .normal)
            self.fieldConfirmPassword.isSecureTextEntry = true
            self.isConfirmPassVisible = false
        }else {
            self.btnConfirmPasswordVisibility.setImage(UIImage(named: "ic_hide"), for: .normal)
            self.fieldConfirmPassword.isSecureTextEntry = false
            self.isConfirmPassVisible = true
        }
    }
    
    @IBAction func selectFaceImage(_ sender: Any) {
        self.showImagePickerAlert()
    }
    
    @IBAction func addVideoAction(_ sender: Any) {
        let vc : CameraVC = self.getStoryBoard(name: Constants.STORYBOARDS.authentication).instantiateViewController(withIdentifier: "CameraVC") as! CameraVC
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func selectReasonOfRegAction(_ sender: Any) {
        self.showLoading()
        self.getApiManager().getReasonOfRegistrations { (response) in
            self.hideLoading()
            self.reasonsDropDown = DropDown()
            self.reasonsDropDown?.anchorView = self.cvReason
            var arr = [String]()
            self.reasons.removeAll()
            self.reasons.append(contentsOf: response.data ?? [ReasonOfRegDatum]())
            for item in self.reasons {
                arr.append(item.name ?? "")
            }
            self.reasonsDropDown?.dataSource = arr
            self.reasonsDropDown?.show()
            
            self.reasonsDropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
                self.selectedReason = self.reasons[index]
                self.fieldReason.text = self.selectedReason?.name ?? ""
                self.cvReason.backgroundColor = UIColor.card_color
                self.validateFields()
            }
        }
    }
    
    @IBAction func keepMeUpdatedAction(_ sender: Any) {
        if (self.keepMeUpdated) {
            self.ivKeepMeUpdated.image = UIImage(named: "ic_terms_unchecked")
            self.keepMeUpdated = false
        }else {
            self.ivKeepMeUpdated.image = UIImage(named: "ic_terms_checked")
            self.keepMeUpdated = true
        }
    }
    
    @IBAction func herrebyAgreementAction(_ sender: Any) {
        showAgreeTextAlert()
    }
    
    @IBAction func agreeTermsAction(_ sender: Any) {
        if (self.agreeTerms) {
            self.ivAgreeTerms.image = UIImage(named: "ic_terms_unchecked")
            self.agreeTerms = false
        }else {
            self.ivAgreeTerms.image = UIImage(named: "ic_terms_checked")
            self.agreeTerms = true
        }
        validateFields()
    }
    
    @IBAction func createAccountAction(_ sender: Any) {
        if (self.validate()) {
            //registerr api
            self.fillData()
            App.shared.registerModel?.password = (self.fieldPassword.text ?? "").trim()
            self.showLoading()
            self.getApiManager().register(mModel: App.shared.registerModel) { (response) in
                self.hideLoading()
                if ((response.success ?? false) && response.code ?? "" == Constants.RESPONSE_CODES.needs_verification) {
                    App.shared.registerModel = RegisterModel()
                    let access_token = response.data?.accessToken ?? ""
                    self.openVerification(token: access_token)
                }else {
                    self.handleError(code : response.code ?? "", message : response.message)
                }
            }
        }
    }
    
    private func showAgreeTextAlert() {
        var text = ""
        for textItem in App.shared.config?.registrationSettings?.declareList ?? [DeclareList]() {
            if (isArabic()) {
                text = "\(text)\n\n\(textItem.titleAr ?? "")"
            }else {
                text = "\(text)\n\n\(textItem.titleEn ?? "")"
            }
        }
        if (self.agreeHereby) {
            //no need to show alert, just uncheck the box
            self.ivHereby.image = UIImage(named: "ic_terms_unchecked")
            self.agreeHereby = false
            self.validateFields()
        }else {
            self.showAlert(title: "hereby_declare".localized, message: text, actionTitle: "i_agree".localized, cancelTitle: "cancel".localized, actionHandler: {
                self.ivHereby.image = UIImage(named: "ic_terms_checked")
                self.agreeHereby = true
                self.validateFields()
            }) {
                self.ivHereby.image = UIImage(named: "ic_terms_unchecked")
                self.agreeHereby = false
                self.validateFields()
            }
        }
        
    }
    
    func openVerification(token : String) {
        let vc : VerificationVC = self.getStoryBoard(name: Constants.STORYBOARDS.authentication).instantiateViewController(withIdentifier: "VerificationVC") as! VerificationVC
        vc.access_token = token
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    @IBAction func termsAction(_ sender: Any) {
        self.openUrl(str: App.shared.config?.configString?.termsAndConditionsURL ?? "", screenTitle: "terms_and_conditions".localized)
    }
    
    
    func validate() -> Bool {
        let mobile = (self.fieldMobile.text ?? "").trim()
        // let phone = (self.fieldPhone.text ?? "").trim()
        let password = (self.fieldPassword.text ?? "").trim()
        let confirmPassword = (self.fieldConfirmPassword.text ?? "").trim()
        
//        let email = (self.fieldEmail.text ?? "").trim()
        
        if (mobile.count == 0) {
            self.showBanner(title: "alert".localized, message: "enter_valid_mobile".localized, style: UIColor.INFO)
            self.cvMobile.backgroundColor = UIColor.app_red
            return false
        }
        
        if (!mobile.isNumeric) {
            self.showBanner(title: "alert".localized, message: "text_regex_mobile".localized, style: UIColor.INFO)
            self.cvMobile.backgroundColor = UIColor.app_red
            return false
        }
        if (mobile.count < 9 || mobile.count > 10) {
            self.showBanner(title: "alert".localized, message: "enter_valid_mobile".localized, style: UIColor.INFO)
            self.cvMobile.backgroundColor = UIColor.app_red
            return false
        }
        
        
        if (password.count == 0) {
            self.showBanner(title: "alert".localized, message: "enter_valid_password".localized, style: UIColor.INFO)
            self.cvPassword.backgroundColor = UIColor.app_red
            return false
        }
        
        if (self.isValidPassword(password: password) == false) {
            self.showBanner(title: "alert".localized, message: "enter_valid_password_regex".localized, style: UIColor.INFO)
            self.cvPassword.backgroundColor = UIColor.app_red
            self.cvConfirmPassword.backgroundColor = UIColor.app_red
            return false
        }
        
        if (confirmPassword.count == 0) {
            self.showBanner(title: "alert".localized, message: "confirm_your_password".localized, style: UIColor.INFO)
            self.cvConfirmPassword.backgroundColor = UIColor.app_red
            return false
        }
        
        if (password != confirmPassword) {
            self.showBanner(title: "alert".localized, message: "passwords_missmatch".localized, style: UIColor.INFO)
            self.cvPassword.backgroundColor = UIColor.app_red
            self.cvConfirmPassword.backgroundColor = UIColor.app_red
            return false
        }
        
//        if (email.count == 0) {
//            self.showBanner(title: "alert".localized, message: "enter_email_address".localized, style: UIColor.INFO)
//            self.cvEmail.backgroundColor = UIColor.app_red
//            return false
//        }
        
//        if (email.isValidEmail() == false) {
//            self.showBanner(title: "alert".localized, message: "enter_valid_email".localized, style: UIColor.INFO)
//            self.cvEmail.backgroundColor = UIColor.app_red
//            return false
//        }
        
        if (self.faceImage == nil) {
            self.showBanner(title: "alert".localized, message: "add_face_image".localized, style: UIColor.INFO)
            return false
        }
        
        if (self.videoUrl == nil) {
            self.showBanner(title: "alert".localized, message: "add_face_video".localized, style: UIColor.INFO)
            return false
        }
        
        //        if (self.selectedReason?.reasonOfRegistrationID?.count ?? 0 == 0){
        //            self.showBanner(title: "alert".localized, message: "select_reason_of_reg".localized, style: UIColor.INFO)
        //            self.cvReason.backgroundColor = UIColor.app_red
        //            return false
        //        }
        
        if (self.agreeTerms == false) {
            self.showBanner(title: "alert".localized, message: "you_need_agree_terms".localized, style: UIColor.INFO)
            return false
        }
        
        if (self.agreeHereby == false) {
            self.showBanner(title: "alert".localized, message: "you_need_agree_hereby".localized, style: UIColor.INFO)
            return false
        }
        
        return true
    }
    
    func fillData() {
        if (App.shared.registerModel == nil) {
            App.shared.registerModel = RegisterModel()
        }
        App.shared.registerModel?.selectedCountryCode = self.lblCountryCode.text ?? ""
        App.shared.registerModel?.mobileNumber = (self.fieldMobile.text ?? "").trim()
        //   App.shared.registerModel?.phone = (self.fieldPhone.text ?? "").trim()
        App.shared.registerModel?.email = ""
        App.shared.registerModel?.faceImage = self.faceImage
        App.shared.registerModel?.videoUrl = self.videoUrl
        App.shared.registerModel?.reason = self.selectedReason
    }
    
    func retreiveData() {
        let mModel = App.shared.registerModel
        self.lblCountryCode.text = mModel?.selectedCountryCode ?? "+962"
        self.fieldMobile.text = mModel?.mobileNumber ?? ""
        
        var mobile = fieldMobile.text ?? ""
        if (mobile.count > 0) {
            if (!mobile.starts(with: "0")) {
                mobile = "0\(mobile)"
            }
        }else {
            mobile = ""
        }
        self.fieldUsername.text = mobile
        
        // self.fieldPhone.text = mModel?.phone ?? ""
//        self.fieldEmail.text = mModel?.email ?? ""
        
        self.faceImage = mModel?.faceImage
        self.ivFace.image = self.faceImage
        
        self.videoUrl = mModel?.videoUrl
        if (self.videoUrl != nil) {
            self.ivVideo.image = UIImage(named: "bg_video")
        }
        self.selectedReason = mModel?.reason
        self.fieldReason.text = self.selectedReason?.name ?? ""
        
        self.validateFields()
    }
    
    
    func validateFields() {
        let mobile = (self.fieldMobile.text ?? "").trim()
        // let phone = (self.fieldPhone.text ?? "").trim()
        
        
        let password = (self.fieldPassword.text ?? "").trim()
        let confirmPassword = (self.fieldConfirmPassword.text ?? "").trim()
        
        let email = ""
        
        var isValidMobile = false
        let isMobileCharsCorrect = (mobile.count == 9 || mobile.count == 10)
        let englishStartCheck = mobile.starts(with: "0") || mobile.starts(with: "7") || mobile.starts(with: "07")
        let arabicMobileCheck = mobile.starts(with: "٠") || mobile.starts(with: "٧") || mobile.starts(with: "٠٧")
        if ((englishStartCheck || arabicMobileCheck) && isMobileCharsCorrect && mobile.isNumeric) {
            isValidMobile = true
        }else {
            isValidMobile = false
        }
        
        let isValidFaceImage = self.faceImage != nil
        let isValidFaceVideo = self.videoUrl != nil
        
//        let isValidEmail = ((email.count > 0) && email.isValidEmail())
        let isValidPassword = password.count >= 6
        let isValidConfirmPassword = confirmPassword.count >= 6
        let isValidPasswordRegex = self.isValidPassword(password: password)
        let passwordMatch = (password == confirmPassword)
        
        
        if ( isValidMobile && isValidPassword && isValidConfirmPassword && passwordMatch && isValidFaceImage && isValidFaceVideo && isValidPasswordRegex && agreeTerms && agreeHereby) {
            self.enableCreate(flag: true)
        }
        else {
            self.enableCreate(flag: false)
        }
        
    }
    
    
    func enableCreate(flag : Bool) {
        if (flag) {
            self.cvCreate.backgroundColor = UIColor.enabled
            self.btnCreate.setTitleColor(UIColor.enabled_text, for: .normal)
            btnCreate.isEnabled = true
        }else {
            self.cvCreate.backgroundColor = UIColor.disabled
            self.btnCreate.setTitleColor(UIColor.disabled_text, for: .normal)
            if (Constants.SHOULD_DISABLE_BUTTON) {
                btnCreate.isEnabled = false
            }
        }
    }
    
    
    //fields observers
    @IBAction func fieldTextChanged(_ sender: Any) {
        var mobile = fieldMobile.text ?? ""
        if (mobile.count > 0) {
            if (!mobile.starts(with: "0")) {
                mobile = "0\(mobile)"
            }
        }else {
            mobile = ""
        }
        self.fieldUsername.text = mobile
        validateFields()
    }
    
}

extension RegisterStep3 : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == fieldMobile) {
            var mobile = fieldMobile.text ?? ""
            if (mobile.count > 0) {
                if (!mobile.starts(with: "0")) {
                    mobile = "0\(mobile)"
                }
            }else {
                mobile = ""
            }
            self.fieldUsername.text = mobile
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.fieldMobile) {
            self.cvMobile.backgroundColor = UIColor.card_focused_color
        }
//        else if (textField == self.fieldEmail) {
//            self.cvEmail.backgroundColor = UIColor.card_focused_color
//        }
        
        else if (textField == self.fieldPassword) {
            self.cvPassword.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldConfirmPassword) {
            self.cvConfirmPassword.backgroundColor = UIColor.card_focused_color
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == self.fieldMobile) {
            self.cvMobile.backgroundColor = UIColor.card_color
        }
//        else if (textField == self.fieldEmail) {
//            self.cvEmail.backgroundColor = UIColor.card_color
//        }
        else if (textField == self.fieldPassword) {
            self.cvPassword.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldConfirmPassword) {
            self.cvConfirmPassword.backgroundColor = UIColor.card_color
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == self.fieldMobile) {
//            self.fieldEmail.becomeFirstResponder()
        }
//        else if (textField == self.fieldEmail) {
//            self.fieldPassword.becomeFirstResponder()
//        }
        else if (textField == self.fieldPassword) {
            self.fieldConfirmPassword.becomeFirstResponder()
        }else if (textField == self.fieldConfirmPassword) {
            self.fieldConfirmPassword.resignFirstResponder()
        }
        return false
    }
}


extension RegisterStep3: UIImagePickerControllerDelegate {
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

extension RegisterStep3 : CameraCaptureDelegate {
    func didCaptureVideo(url: URL) {
        self.videoUrl = url
        self.ivVideo.image = UIImage(named: "bg_video")
    }
}

extension RegisterStep3 : CountryCodeDelegate {
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

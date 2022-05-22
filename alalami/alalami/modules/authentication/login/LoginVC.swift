//
//  LoginVC.swift
//  alalami
//
//  Created by Zaid Khaled on 8/31/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginVC: BaseVC {
    
    //country code
    @IBOutlet weak var lblCountryCode: MyUILabel!
    @IBOutlet weak var ivCountryCode: UIImageView!
    
    
    @IBOutlet weak var lWelcome: MyUILabel!
    
    
    
    //mobile
    @IBOutlet weak var cvMobile: CardView!
    @IBOutlet weak var fieldMobile: MyUITextField!
    
    //password
    @IBOutlet weak var cvPassword: CardView!
    @IBOutlet weak var fieldPassword: MyUITextField!
    @IBOutlet weak var btnPasswordVisibility: UIButton!
    var isPassVisible : Bool = false
    
    //login
    @IBOutlet weak var cvLogin: CardView!
    @IBOutlet weak var btnLogin: MyUIButton!
    
    
    //authenticate
    @IBOutlet weak var viewAuthenticate: UIView!
    @IBOutlet weak var btnAuthenticate: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fieldMobile.delegate = self
        self.fieldPassword.delegate = self
       
//        fieldMobile.text = "0797617895"
//        fieldPassword.text = "12Mohammad34$"
        
        setDefaultCountryCode()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        autoLaunchAuthenticate()
        
        lWelcome.textAlignment = .natural

    
        if(isArabic()){
            lWelcome.textAlignment = .right
        }else{
            lWelcome.textAlignment = .left

        }
    }
    
    private func autoLaunchAuthenticate() {
        let isTouchIdEnabled = UserDefaults.standard.value(forKey: Constants.DEFAULT_KEYS.IS_TOUCHID_ACTIVE) as? Bool ?? false
        
        let authContext = LAContext()
        if #available(iOS 11, *) {
            let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch(authContext.biometryType) {
            case .none:
                //nth
                break
            case .touchID:
                if (isTouchIdEnabled) {
                    self.authorizeUser()
                }
                break
            case .faceID:
                if (isTouchIdEnabled) {
                    self.authorizeUser()
                }
                break
            @unknown default:
                //nth
                break
            }
        }
        
    }
    
    private func setDefaultCountryCode() {
        lblCountryCode.text = "+962"
        let url = URL(string: "\(Constants.IMAGE_URL)\(App.shared.config?.configString?.jordanFlag ?? "")")
        ivCountryCode.kf.setImage(with: url, placeholder: UIImage(named: ""))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.validateBiometricType()
    }
    
    @IBAction func mobileDidChange(_ sender: Any) {
        self.validateFields()
    }
    
    @IBAction func passwordDIdChange(_ sender: Any) {
        self.validateFields()
    }
    
    func validateShowHideTouchIdView() {
        let isTouchIdEnabled = UserDefaults.standard.value(forKey: Constants.DEFAULT_KEYS.IS_TOUCHID_ACTIVE) as? Bool ?? false
        self.viewAuthenticate.isHidden = !isTouchIdEnabled
        self.btnAuthenticate.isHidden = !isTouchIdEnabled
    }
    
    func validateBiometricType() {
        let authContext = LAContext()
        if #available(iOS 11, *) {
            let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch(authContext.biometryType) {
            case .none:
                self.viewAuthenticate.isHidden = true
                self.btnAuthenticate.isHidden = true
                break
            case .touchID:
                self.validateShowHideTouchIdView()
                self.btnAuthenticate.setImage(UIImage(named: "ic_fingerprint"), for: .normal)
                break
            case .faceID:
                self.validateShowHideTouchIdView()
                self.btnAuthenticate.setImage(UIImage(named: "ic_faceid"), for: .normal)
                break
            @unknown default:
                self.viewAuthenticate.isHidden = true
                self.btnAuthenticate.isHidden = true
                break
            }
        } else {
            self.viewAuthenticate.isHidden = true
            self.btnAuthenticate.isHidden = true
        }
    }
    
    
    func authorizeUser() {
        self.Authenticate { (authorized) in
            if (authorized) {
                let userName = self.getBiometryUsername()
                let password = self.getBiometryPassword()
                
                self.loginApiTouchId(username: userName, password: password)
            }
        }
    }
    
    func Authenticate(completion: @escaping ((Bool) -> ())){
        
        //Create a context
        let authenticationContext = LAContext()
        var error:NSError?
        
        //Check if device have Biometric sensor
        let isValidSensor : Bool = authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if isValidSensor {
            //Device have BiometricSensor
            //It Supports TouchID
            
            authenticationContext.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Touch / Face ID authentication",
                reply: { [unowned self] (success, error) -> Void in
                    
                    if(success) {
                        // Touch / Face ID recognized success here
                        completion(true)
                    } else {
                        //If not recognized then
                        if let error = error {
                            let strMessage = self.authErrorMessage(errorCode: error._code)
                            if strMessage != ""{
                                //  self.showAlertWithTitle(title: "Error", message: strMessage)
                            }
                        }
                        completion(false)
                    }
            })
        } else {
            let strMessage = self.authErrorMessage(errorCode: (error?._code)!)
            if strMessage != ""{
                // self.showAlertWithTitle(title: "Error", message: strMessage)
            }
        }
        
    }
    
    func authErrorMessage(errorCode:Int) -> String {
        
        var strMessage = ""
        
        switch errorCode {
            
        case LAError.Code.authenticationFailed.rawValue:
            strMessage = "Authentication Failed"
            
        case LAError.Code.userCancel.rawValue:
            strMessage = "User Cancel"
            
        case LAError.Code.systemCancel.rawValue:
            strMessage = "System Cancel"
            
        case LAError.Code.passcodeNotSet.rawValue:
            strMessage = "Please goto the Settings & Turn On Passcode"
            
        case LAError.biometryNotAvailable.rawValue:
            strMessage = "TouchI or FaceID DNot Available"
            
        case LAError.biometryNotEnrolled.rawValue:
            strMessage = "TouchID or FaceID Not Enrolled"
            
        case LAError.biometryLockout.rawValue:
            strMessage = "TouchID or FaceID Lockout Please goto the Settings & Turn On Passcode"
            
        case LAError.Code.appCancel.rawValue:
            strMessage = "App Cancel"
            
        case LAError.Code.invalidContext.rawValue:
            strMessage = "Invalid Context"
            
        default:
            strMessage = ""
            
        }
        return strMessage
    }
    
    func validate() -> Bool {
        let mobile = (self.fieldMobile.text ?? "").trim()
        let password = (self.fieldPassword.text ?? "").trim()
        
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
//        if (self.isValidPassword(password: password) == false) {
//            self.showBanner(title: "alert".localized, message: "enter_valid_password_regex".localized, style: UIColor.INFO)
//            self.cvPassword.backgroundColor = UIColor.app_red
//            return false
//        }
        return true
    }
    
    @IBAction func passVisibilityAction(_ sender: Any) {
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
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
        let vc : ForgotPasswordVC = self.getStoryBoard(name: Constants.STORYBOARDS.authentication).instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        if (self.validate()) {
            let mobile = (self.fieldMobile.text ?? "").trim()
            let password = (self.fieldPassword.text ?? "").trim()
            
            self.loginApi(username: mobile, password: password)
        }
    }
    
    func loginApi(username : String, password: String) {
        self.showLoading()
        self.getApiManager().login(mobile: username, password: password) { (response) in
            self.hideLoading()
            if (response.code ?? "0" == "0" || response.code ?? "" == "200") {
                
                print("200: response code:\(response.code )")

                
                self.saveAccessToken(token : response.data?.accessToken ?? "")
                self.saveDataForBiometric(username : username, password : password)
                App.shared.registerModel = RegisterModel()
                if (App.shared.config?.configString?.isOneTimePasswordEnabled ?? 1 == 1) {
                    /*one time password*/
                    self.openOneTimePassword()
                }else {
                    /*immediate login*/
                    self.loadAccountInfo()
                }
            }else if (response.code ?? "0" == "201") {
                self.openVerification(token: response.data?.accessToken ?? "")
            }else {
                print("elses: response code:\(response.code )")

                self.showBanner(title: "alert".localized, message: response.message, style: UIColor.INFO)
            }
        }
    }
    
    func loginApiTouchId(username : String, password: String) {
        self.showLoading()
        self.getApiManager().login(mobile: username, password: password) { (response) in
            self.hideLoading()
            if (response.code ?? "0" == "0" || response.code ?? "" == "200") {
                self.saveAccessToken(token : response.data?.accessToken ?? "")
                #if DEBUG
                print("access_token: \(response.data?.accessToken ?? "")")
                #endif
                self.saveDataForBiometric(username : username, password : password)
                App.shared.registerModel = RegisterModel()
                /*immediate login*/
                self.loadAccountInfo()
            }else if (response.code ?? "0" == "201") {
                self.openVerification(token: response.data?.accessToken ?? "")
            }else {
                self.showBanner(title: "alert".localized, message: response.message, style: UIColor.INFO)
            }
        }
    }
    
    func loadAccountInfo() {
        self.showLoading()
        self.getApiManager().getAccountInfo(token: self.getAccessToken()) { (response) in
            self.hideLoading()
            App.shared.accountInfo = response.data
            self.goHome()
        }
    }
    
    func openOneTimePassword() {
        let vc : OneTimePasswordVC = self.getStoryBoard(name: Constants.STORYBOARDS.authentication).instantiateViewController(withIdentifier: "OneTimePasswordVC") as! OneTimePasswordVC
        vc.mobile = getBiometryUsername()
        vc.password = getBiometryPassword()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func openVerification(token : String) {
        let vc : VerificationVC = self.getStoryBoard(name: Constants.STORYBOARDS.authentication).instantiateViewController(withIdentifier: "VerificationVC") as! VerificationVC
        vc.access_token = token
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    @IBAction func registerAction(_ sender: Any) {
        self.pushVC(name: "RegisterStep1", sb: Constants.STORYBOARDS.authentication)
    }
    
    @IBAction func authenticateAction(_ sender: Any) {
        self.authorizeUser()
    }
    
    func validateFields() {
        let mobile = (self.fieldMobile.text ?? "").trim()
        let password = (self.fieldPassword.text ?? "").trim()
        
        var isValidMobile = false
        
        let isMobileCharsCorrect = (mobile.count == 9 || mobile.count == 10)
        let englishStartCheck = mobile.starts(with: "0") || mobile.starts(with: "7") || mobile.starts(with: "07")
        let arabicMobileCheck = mobile.starts(with: "٠") || mobile.starts(with: "٧") || mobile.starts(with: "٠٧")
        if ((englishStartCheck || arabicMobileCheck) && isMobileCharsCorrect && mobile.isNumeric) {
            isValidMobile = true
        }else {
            isValidMobile = false
        }
        
//        let isValidPassword = ((password.count >= Constants.PASSWORD_MIN_LENGTH) && self.isValidPassword(password: password))
        let isValidPassword = ((password.count >= Constants.PASSWORD_MIN_LENGTH))

        if (isValidMobile && isValidPassword) {
            self.enableLogin(flag: true)
        }else {
            self.enableLogin(flag: false)
        }
        
    }
    
    func enableLogin(flag : Bool) {
        if (flag) {
            self.cvLogin.backgroundColor = UIColor.enabled
            self.btnLogin.setTitleColor(UIColor.enabled_text, for: .normal)
        }else {
            self.cvLogin.backgroundColor = UIColor.disabled
            self.btnLogin.setTitleColor(UIColor.disabled_text, for: .normal)
        }
    }
    
    @IBAction func selectCountryCodeAction(_ sender: Any) {
        let vc : CountryCodesVC = self.getStoryBoard(name: Constants.STORYBOARDS.authentication).instantiateViewController(withIdentifier: "CountryCodesVC") as! CountryCodesVC
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension LoginVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.fieldMobile) {
            self.cvMobile.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldPassword) {
            self.cvPassword.backgroundColor = UIColor.card_focused_color
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == self.fieldMobile) {
            self.cvMobile.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldPassword) {
            self.cvPassword.backgroundColor = UIColor.card_color
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == self.fieldMobile) {
            self.fieldPassword.becomeFirstResponder()
        }else if (textField == self.fieldPassword) {
            self.fieldPassword.resignFirstResponder()
        }
        return false
    }
}

extension LoginVC : CountryCodeDelegate {
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


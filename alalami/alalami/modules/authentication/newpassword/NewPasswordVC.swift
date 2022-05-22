//
//  NewPasswordVC.swift
//  alalami
//
//  Created by Zaid Khaled on 9/2/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit

class NewPasswordVC: BaseVC {
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var btnResend: MyUIButton!
    @IBOutlet weak var lblCounter: MyUILabel!
    
    @IBOutlet weak var lNewPassword: MyUILabel!
    
    @IBOutlet weak var desPassword: MyUILabel!
    
    
    @IBOutlet weak var lPPassword: MyUILabel!
    
    var userId: String?
//    var email : String?
    var mobile : String?

    var countDown:Int = 59
    var timer:Timer?
    
    //pin code
    @IBOutlet weak var fieldPin: MyUITextField!
    @IBOutlet weak var cvPin: CardView!
    
    
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
    
    //next
    @IBOutlet weak var cvChange: CardView!
    @IBOutlet weak var btnChange: MyUIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
        }
        
        
        lNewPassword.textAlignment = .natural
        desPassword.textAlignment = .natural
        lPPassword.textAlignment = .natural
        

        if (isArabic()) {
            lNewPassword.textAlignment = .right
            desPassword.textAlignment = .right
            lPPassword.textAlignment = .right
        }else{
            lNewPassword.textAlignment = .left
            desPassword.textAlignment = .left
            lPPassword.textAlignment = .left
        }
        
        self.fieldPin.delegate = self
        self.fieldPassword.delegate = self
        self.fieldConfirmPassword.delegate = self
        
        self.enableChange(flag: false)
        self.startTimer()
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        stopTimer()
    }
    
    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        countDown = 59
        self.lblCounter.text = "(59)"
    }
    
    @objc func updateTimer() {
        if(countDown > 0) {
            countDown = countDown - 1
            self.lblCounter.text = "(\(countDown))"
            self.enableResend(enable: false)
        }else {
            self.lblCounter.text = ""
            self.enableResend(enable: true)
        }
    }
    
    func enableResend(enable : Bool) {
        if (enable == true) {
            self.btnResend.setTitleColor(UIColor.black, for: .normal)
            self.btnResend.isEnabled = true
        }else {
            self.btnResend.setTitleColor(UIColor.text_disabled, for: .normal)
            self.btnResend.isEnabled = false
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resendAction(_ sender: Any) {
        self.enableResend(enable: false)
        self.startTimer()
        self.resendCode()
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
    
    @IBAction func changePasswordAction(_ sender: Any) {
        if (self.validate()) {
            self.showLoading()
            self.getApiManager().changePassword(id: self.userId ?? "", password: (self.fieldPassword.text ?? "").trim(), mobile: self.mobile ?? "", code: (self.fieldPin.text ?? "").trim()) { (response) in
                self.hideLoading()
                if (response.success ?? false) {
                    self.presentVC(name: "PasswordChangedVC", sb: Constants.STORYBOARDS.authentication)
                }else {
                    self.handleError(code : response.code ?? "", message : response.message)
                }
            }
        }
    }
    
    
    //methods
    func resendCode() {
        self.stopTimer()
        self.sendVerificationCode()
    }
    
    func sendVerificationCode() {
        self.showLoading()
        self.getApiManager().forgotPassword(mobile: self.mobile ?? "") { (response) in
            self.hideLoading()
            
            if response.success == false{
                self.handleError(code: response.code, message: response.message ?? ["Somthing Wrong"])

            }else{
                self.userId = response.data ?? ""
                self.enableChange(flag: false)
                self.startTimer()
                
                self.handleError(code: response.code, message: response.message ?? ["Somthing Wrong"])

            }
        
        }
    }
    
    func enableChange(flag : Bool) {
        if (flag) {
            self.cvChange.backgroundColor = UIColor.enabled
            self.btnChange.setTitleColor(UIColor.enabled_text, for: .normal)
            btnChange.isEnabled = true
        }else {
            self.cvChange.backgroundColor = UIColor.disabled
            self.btnChange.setTitleColor(UIColor.disabled_text, for: .normal)
            if (Constants.SHOULD_DISABLE_BUTTON) {
                btnChange.isEnabled = false
            }
        }
    }
    
    func openSuccessScreen() {
        self.presentVC(name: "SuccessVC", sb: Constants.STORYBOARDS.authentication)
    }
    
    func validate() -> Bool {
        let password = (self.fieldPassword.text ?? "").trim()
        let confirmPassword = (self.fieldConfirmPassword.text ?? "").trim()
        let pinCode = (self.fieldPin.text ?? "").trim().replacedArabicDigitsWithEnglish
        
        if (pinCode.count != 8) {
            self.cvPin.backgroundColor = UIColor.app_red
            self.showBanner(title: "alert".localized, message: "enter_pin_digits".localized, style: UIColor.INFO)
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
        
        return true
    }
    
    
    func validateFields() {
        let pin = (self.fieldPin.text ?? "").trim()
        let password = (self.fieldPassword.text ?? "").trim()
        let confirmPassword = (self.fieldConfirmPassword.text ?? "").trim()
        
        let isValidPin = pin.count == 8
        let isValidPassword = password.count >= 6
        let isValidConfirmPassword = confirmPassword.count >= 6
        let passwordMatch = (password == confirmPassword)
        let isValidPasswordRegex = self.isValidPassword(password: password)
        
        
        if (isValidPassword && isValidConfirmPassword && passwordMatch && isValidPasswordRegex && isValidPin) {
            self.enableChange(flag: true)
        }else {
            self.enableChange(flag: false)
        }
        
    }
    
    @IBAction func pinChanged(_ sender: Any) {
        self.validateFields()
    }
    
    @IBAction func passwordChanged(_ sender: Any) {
        self.validateFields()
    }
    
    @IBAction func newPasswordChanged(_ sender: Any) {
        self.validateFields()
    }
    
}


extension NewPasswordVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.fieldPassword) {
            self.cvPassword.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldConfirmPassword) {
            self.cvConfirmPassword.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldPin) {
            self.cvPin.backgroundColor = UIColor.card_focused_color
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == self.fieldPassword) {
            self.cvPassword.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldConfirmPassword) {
            self.cvConfirmPassword.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldPin) {
            self.cvPin.backgroundColor = UIColor.card_color
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == self.fieldPassword) {
            self.fieldConfirmPassword.becomeFirstResponder()
        }else if (textField == self.fieldConfirmPassword) {
            self.fieldConfirmPassword.resignFirstResponder()
        }else if (textField == self.fieldPin) {
            self.fieldPin.resignFirstResponder()
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.fieldPin {
            let maxLength = 8
            let currentString: NSString = textField.text as NSString? ?? ""
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            
            return newString.length <= maxLength
        }
        
        return true
    }
    
    
}


//
//  ChangePasswordVC.swift
//  alalami
//
//  Created by Zaid Khaled on 10/1/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit

class ChangePasswordVC: BaseVC {

    @IBOutlet weak var lPassword: MyUILabel!
    
    @IBOutlet weak var btnBack: UIButton!
    
    
    //current password
    @IBOutlet weak var cvCurrentPassword: CardView!
    @IBOutlet weak var fieldCurrentPassword: MyUITextField!
    @IBOutlet weak var btnCurrentPassword: UIButton!
    var isCurrentPasswordVisible = false
    
    //new password
    @IBOutlet weak var cvNewPassword: CardView!
    @IBOutlet weak var fieldNewPassword: MyUITextField!
    @IBOutlet weak var btnNewPassword: UIButton!
    var isNewPasswordVisible = false
    
    //confirm new password
    @IBOutlet weak var cvConfirmNewPassword: CardView!
    @IBOutlet weak var fieldConfirmNewPassword: MyUITextField!
    @IBOutlet weak var btnConfirmNewPassword: UIButton!
    var isConfirmNewPasswordVisible = false
    
    //action
    @IBOutlet weak var cvContinue: CardView!
    @IBOutlet weak var btnContinue: MyUIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnContinue.setTitle("change_password".localized, for: .normal)
        
 
        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
        }
        
        lPassword.textAlignment = .natural

        if (isArabic()) {
            
            lPassword.textAlignment = .right
        }else{
            lPassword.textAlignment = .left

        }
        
        
        self.fieldCurrentPassword.delegate = self
        self.fieldNewPassword.delegate = self
        self.fieldConfirmNewPassword.delegate = self 

        self.enableNext(flag: false)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func currentPasswordEyeAction(_ sender: Any) {
        if (self.isCurrentPasswordVisible) {
            self.btnCurrentPassword.setImage(UIImage(named: "ic_pass_visible"), for: .normal)
            self.fieldCurrentPassword.isSecureTextEntry = true
            self.isCurrentPasswordVisible = false
        }else {
            self.btnCurrentPassword.setImage(UIImage(named: "ic_pass_hidden"), for: .normal)
            self.fieldCurrentPassword.isSecureTextEntry = false
            self.isCurrentPasswordVisible = true
        }
    }
    
    @IBAction func newPasswordEyeAction(_ sender: Any) {
        if (self.isNewPasswordVisible) {
            self.btnNewPassword.setImage(UIImage(named: "ic_pass_visible"), for: .normal)
            self.fieldNewPassword.isSecureTextEntry = true
            self.isNewPasswordVisible = false
        }else {
            self.btnNewPassword.setImage(UIImage(named: "ic_pass_hidden"), for: .normal)
            self.fieldNewPassword.isSecureTextEntry = false
            self.isNewPasswordVisible = true
        }
    }
    
    @IBAction func confirmNewPasswordEyeAction(_ sender: Any) {
        if (self.isConfirmNewPasswordVisible) {
            self.btnConfirmNewPassword.setImage(UIImage(named: "ic_pass_visible"), for: .normal)
            self.fieldConfirmNewPassword.isSecureTextEntry = true
            self.isConfirmNewPasswordVisible = false
        }else {
            self.btnConfirmNewPassword.setImage(UIImage(named: "ic_pass_hidden"), for: .normal)
            self.fieldConfirmNewPassword.isSecureTextEntry = false
            self.isConfirmNewPasswordVisible = true
        }
    }
    
    @IBAction func continueAction(_ sender: Any) {
        
        let currentPassword = (self.fieldCurrentPassword.text ?? "").trim()
        let newPassword = (self.fieldNewPassword.text ?? "").trim()
        
        if (self.validate()) {
            self.showLoading()
            self.getApiManager().changePasswordUsingCurrentPassword(token: self.getAccessToken(), currentPassword: currentPassword, newPassword: newPassword) { (response) in
                self.hideLoading()
                if (response.success ?? false) {
                    self.showBanner(title: "alert".localized, message: "password_changed_successfully".localized, style: UIColor.SUCCESS)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }else {
                    self.handleError(code : response.code ?? "", message : response.message)
                }
            }
        }
    }
    
    func validate() -> Bool{
        let currentPassword = (self.fieldCurrentPassword.text ?? "").trim()
        let newPassword = (self.fieldNewPassword.text ?? "").trim()
        let confirmNewPassword = (self.fieldConfirmNewPassword.text ?? "").trim()
        
        
        if (currentPassword.count == 0) {
            self.showBanner(title: "alert".localized, message: "enter_current_password".localized, style: UIColor.INFO)
            self.cvCurrentPassword.backgroundColor = UIColor.app_red
            return false
        }
        
        if (self.isValidPassword(password: currentPassword) == false) {
            self.showBanner(title: "alert".localized, message: "enter_valid_password_regex".localized, style: UIColor.INFO)
            self.cvCurrentPassword.backgroundColor = UIColor.app_red
            return false
        }
        
        if (newPassword.count == 0) {
            self.showBanner(title: "alert".localized, message: "enter_new_password".localized, style: UIColor.INFO)
            self.cvNewPassword.backgroundColor = UIColor.app_red
            return false
        }
        
        if (self.isValidPassword(password: newPassword) == false) {
            self.showBanner(title: "alert".localized, message: "enter_valid_password_regex".localized, style: UIColor.INFO)
            self.cvNewPassword.backgroundColor = UIColor.app_red
            return false
        }
        
        if (confirmNewPassword.count == 0) {
            self.showBanner(title: "alert".localized, message: "confirm_new_password".localized, style: UIColor.INFO)
            self.cvConfirmNewPassword.backgroundColor = UIColor.app_red
            return false
        }
        
        if (newPassword != confirmNewPassword) {
            self.showBanner(title: "alert".localized, message: "passwords_missmatch".localized, style: UIColor.INFO)
            self.cvNewPassword.backgroundColor = UIColor.app_red
            self.cvConfirmNewPassword.backgroundColor = UIColor.app_red
            return false
        }
        
        return true
        
    }
    
    @IBAction func fieldTextChanged(_ sender: Any) {
        self.validateFields()
    }
    
    
    func validateFields() {
        let currentPassword = (self.fieldCurrentPassword.text ?? "").trim()
        let newPassword = (self.fieldNewPassword.text ?? "").trim()
        let confirmNewPassword = (self.fieldConfirmNewPassword.text ?? "").trim()
        
        
        if (currentPassword.count < Constants.PASSWORD_MIN_LENGTH) {
            self.enableNext(flag: false)
            return
        }
        
        if (self.isValidPassword(password: currentPassword) == false) {
            self.enableNext(flag: false)
            return
        }
        
        if (newPassword.count < Constants.PASSWORD_MIN_LENGTH) {
            self.enableNext(flag: false)
            return
        }
        
        if (self.isValidPassword(password: newPassword) == false) {
            self.enableNext(flag: false)
            return
        }
        
        if (confirmNewPassword.count < Constants.PASSWORD_MIN_LENGTH) {
            self.enableNext(flag: false)
            return
        }
        
        if (newPassword != confirmNewPassword) {
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
extension ChangePasswordVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.fieldCurrentPassword) {
            self.cvCurrentPassword.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldNewPassword) {
            self.cvNewPassword.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldConfirmNewPassword) {
            self.cvConfirmNewPassword.backgroundColor = UIColor.card_focused_color
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == self.fieldCurrentPassword) {
            self.cvCurrentPassword.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldNewPassword) {
            self.cvNewPassword.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldConfirmNewPassword) {
            self.cvConfirmNewPassword.backgroundColor = UIColor.card_color
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == self.fieldCurrentPassword) {
            self.fieldNewPassword.becomeFirstResponder()
        }else if (textField == self.fieldNewPassword) {
            self.fieldConfirmNewPassword.becomeFirstResponder()
        }else if (textField == self.fieldConfirmNewPassword) {
            self.fieldConfirmNewPassword.resignFirstResponder()
        }
        return false
    }
}

//
//  ForgotPasswordVC.swift
//  alalami
//
//  Created by Zaid Khaled on 9/2/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit

class ForgotPasswordVC: BaseVC {
    
    @IBOutlet weak var lForgotPassword: MyUILabel!
    
    
    @IBOutlet weak var mobileNumber: MyUILabel!
    @IBOutlet weak var btnBack: UIButton!
    
    //mobile
    @IBOutlet weak var cvMobile: CardView!
    @IBOutlet weak var fieldMobile: MyUITextField!
    
    
    //next
    @IBOutlet weak var cvNext: CardView!
    @IBOutlet weak var btnNext: MyUIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mobileNumber.text = "Mobile Number".localized
        fieldMobile.placeholder = "Enter Mobile Number Here".localized
        
        
        fieldMobile.maxLength = 10
        
        
        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
        }
        
        
        if (isArabic()) {
            lForgotPassword.textAlignment = .right
        }else{
            lForgotPassword.textAlignment = .left
        }
        
        
        
        self.enableNext(flag: false)
        self.fieldMobile.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if (self.validate()) {
            self.startForgotPasswordProcess()
        }
    }
    
    func startForgotPasswordProcess() {
        self.showLoading()
        self.getApiManager().forgotPassword(mobile: (self.fieldMobile.text ?? "").trim()) { (response) in
            self.hideLoading()
            if (response.success ?? false) {
                let userId = response.data ?? ""
                self.openVerificationScreen(userId: userId)
            }else {
                self.handleError(code : response.code ?? "", message : response.message)
            }
        }
    }
    
    func openVerificationScreen(userId : String) {
        let vc : NewPasswordVC = self.getStoryBoard(name: Constants.STORYBOARDS.authentication).instantiateViewController(withIdentifier: "NewPasswordVC") as! NewPasswordVC
        
        
//        vc.email = (self.fieldMobile.text ?? "").trim()
        vc.mobile = (self.fieldMobile.text ?? "").trim()

        
        vc.userId = userId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func validate() -> Bool {
        
        
        
        let mobile = (self.fieldMobile.text ?? "").trim()

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

        
        return true
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func mobileChanged(_ sender: Any) {
        
        var mobile = fieldMobile.text ?? ""
        if (mobile.count > 0) {
            if (!mobile.starts(with: "0")) {
                mobile = "0\(mobile)"
            }
        }else {
            mobile = ""
        }
        self.fieldMobile.text = mobile
        self.validateFields()
    }
    
    func validateFields() {
        
        
        let mobile = (self.fieldMobile.text ?? "").trim()

        var isValidMobile = false
        let isMobileCharsCorrect = (mobile.count == 9 || mobile.count == 10)
        let englishStartCheck = mobile.starts(with: "0") || mobile.starts(with: "7") || mobile.starts(with: "07")
        
        let arabicMobileCheck = mobile.starts(with: "٠") || mobile.starts(with: "٧") || mobile.starts(with: "٠٧")
        if ((englishStartCheck || arabicMobileCheck) && isMobileCharsCorrect && mobile.isNumeric) {
            isValidMobile = true
        }else {
            isValidMobile = false
        }
        
        
        
        if (isValidMobile) {
            self.enableNext(flag: true)
        }
        else {
            self.enableNext(flag: false)
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
    
}
extension ForgotPasswordVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.fieldMobile) {
            self.cvMobile.backgroundColor = UIColor.card_focused_color
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == self.fieldMobile) {
            self.cvMobile.backgroundColor = UIColor.card_color
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == self.fieldMobile) {
            self.fieldMobile.resignFirstResponder()
        }
        return false
    }
}

//
//  AddNewBenefeciaryVC.swift
//  alalami
//
//  Created by Zaid Khaled on 9/13/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit

protocol AddBeneficiaryDelegate {
    func didAddBeneficiary(beneficiary : BeneficiaryDatum)
}
class AddNewBenefeciaryVC: BaseVC {
    
    @IBOutlet weak var btnBack: UIButton!
    
    var delegate : AddBeneficiaryDelegate?
    
    //first name
    @IBOutlet weak var cvFirstName: CardView!
    @IBOutlet weak var fieldFirstName: MyUITextField!
    
    //second name
    @IBOutlet weak var cvSecondName: CardView!
    @IBOutlet weak var fieldSecondName: MyUITextField!
    
    //third name
    @IBOutlet weak var cvThirdName: CardView!
    @IBOutlet weak var fieldThirdName: MyUITextField!
    
    //last name
    @IBOutlet weak var cvLastName: CardView!
    @IBOutlet weak var fieldLastName: MyUITextField!
    
    //mobile
    @IBOutlet weak var cvMobile: CardView!
    @IBOutlet weak var fieldMobile: MyUITextField!
    
    //country
    @IBOutlet weak var cvCountry: CardView!
    @IBOutlet weak var fieldCountry: MyUITextField!
    @IBOutlet weak var ivCountry: UIImageView!
    var selectedCountry : CountryDatum?
    
    //action
    @IBOutlet weak var cvContinue: CardView!
    @IBOutlet weak var btnContinue: MyUIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
        }
        
        self.fieldFirstName.delegate = self
        self.fieldSecondName.delegate = self
        self.fieldThirdName.delegate = self
        self.fieldLastName.delegate = self
        self.fieldMobile.delegate = self
        
        let url = URL(string: "\(Constants.IMAGE_URL)\(App.shared.config?.configString?.jordanFlag ?? "")")
        ivCountry.kf.setImage(with: url, placeholder: UIImage(named: ""))
        fieldCountry.text = "jordan".localized
    }
    
    
    @IBAction func fieldEntryChanged(_ sender: Any) {
        self.validateFields()
    }
    
    func validateFields() {
        if (self.fieldFirstName.text?.count ?? 0 == 0) {
            self.enableNext(flag: false)
            return
        }
        
        //        if (self.fieldSecondName.text?.count ?? 0 == 0) {
        //            self.enableNext(flag: false)
        //            return
        //        }
        //        if (self.fieldThirdName.text?.count ?? 0 == 0) {
        //            self.enableNext(flag: false)
        //            return
        //        }
        
        if (self.fieldLastName.text?.count ?? 0 == 0) {
            self.enableNext(flag: false)
            return
        }
        if (self.fieldMobile.text?.count ?? 0 == 0) {
            self.enableNext(flag: false)
            return
        }
        
        if (!isPureText(text: fieldSecondName.text ?? "")) {
            self.enableNext(flag: false)
            return
        }
        
        if (!isPureText(text: fieldThirdName.text ?? "")) {
            self.enableNext(flag: false)
            return
        }
        
        if (!isPureText(text: [fieldFirstName.text ?? "",
                               fieldLastName.text ?? ""])) {
            self.enableNext(flag: false)
            return
        }
        if (!(fieldMobile.text ?? "").isNumeric) {
            self.enableNext(flag: false)
            return
        }
        
        self.enableNext(flag: true)
    }
    
    func validate() -> Bool {
        if (self.fieldFirstName.text?.count ?? 0 == 0) {
            self.showBanner(title: "alert".localized, message: "enter_first_name".localized, style: UIColor.INFO)
            self.cvFirstName.backgroundColor = UIColor.app_red
            return false
        }
        if (!isPureText(text: fieldFirstName.text ?? "")) {
            self.showBanner(title: "alert".localized, message: "text_regex_firstname".localized, style: UIColor.INFO)
            self.cvFirstName.backgroundColor = UIColor.app_red
            return false
        }
        
            if (!isPureText(text: fieldSecondName.text ?? "")) {
                self.showBanner(title: "alert".localized, message: "text_regex_middlename".localized, style: UIColor.INFO)
                self.cvSecondName.backgroundColor = UIColor.app_red
                return false
            }
        
            if (!isPureText(text: fieldThirdName.text ?? "")) {
                self.showBanner(title: "alert".localized, message: "text_regex_thirdname".localized, style: UIColor.INFO)
                self.cvThirdName.backgroundColor = UIColor.app_red
                return false
            }
        
        //        if (self.fieldSecondName.text?.count ?? 0 == 0) {
        //            self.showBanner(title: "alert".localized, message: "enter_second_name".localized, style: UIColor.INFO)
        //            self.cvSecondName.backgroundColor = UIColor.app_red
        //            return false
        //        }
        //        if (self.fieldThirdName.text?.count ?? 0 == 0) {
        //            self.showBanner(title: "alert".localized, message: "enter_third_name".localized, style: UIColor.INFO)
        //            self.cvThirdName.backgroundColor = UIColor.app_red
        //            return false
        //        }
        if (self.fieldLastName.text?.count ?? 0 == 0) {
            self.showBanner(title: "alert".localized, message: "enter_last_name".localized, style: UIColor.INFO)
            self.cvLastName.backgroundColor = UIColor.app_red
            return false
        }
        if (!isPureText(text: fieldLastName.text ?? "")) {
            self.showBanner(title: "alert".localized, message: "text_regex_familyname".localized, style: UIColor.INFO)
            self.cvLastName.backgroundColor = UIColor.app_red
            return false
        }
        
        if (self.fieldMobile.text?.count ?? 0 == 0) {
            self.showBanner(title: "alert".localized, message: "enter_mobile_number".localized, style: UIColor.INFO)
            self.cvMobile.backgroundColor = UIColor.app_red
            return false
        }
        if (!(fieldMobile.text ?? "").isNumeric) {
            self.showBanner(title: "alert".localized, message: "text_regex_mobile".localized, style: UIColor.INFO)
            self.cvMobile.backgroundColor = UIColor.app_red
            return false
        }
        return true
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
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        if (self.validate()) {
            let beneficiary = BeneficiaryDatum(firstNameAr: "", secondNameAr: "", thirdNameAr: "", lastNameAr: "", firstNameEn: (self.fieldFirstName.text ?? "").trim(), secondNameEn: (self.fieldSecondName.text ?? "").trim(), thirdNameEn: (self.fieldThirdName.text ?? "").trim(), lastNameEn: (self.fieldLastName.text ?? "").trim(), mobile: (self.fieldMobile.text ?? "").trim())
            
            self.delegate?.didAddBeneficiary(beneficiary: beneficiary)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

extension AddNewBenefeciaryVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.fieldFirstName) {
            self.cvFirstName.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldSecondName) {
            self.cvSecondName.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldThirdName) {
            self.cvThirdName.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldLastName) {
            self.cvLastName.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldMobile) {
            self.cvMobile.backgroundColor = UIColor.card_focused_color
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == self.fieldFirstName) {
            self.cvFirstName.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldSecondName) {
            self.cvSecondName.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldThirdName) {
            self.cvThirdName.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldLastName) {
            self.cvLastName.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldMobile) {
            self.cvMobile.backgroundColor = UIColor.card_color
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == self.fieldFirstName) {
            self.fieldSecondName.becomeFirstResponder()
        }else if (textField == self.fieldSecondName) {
            self.fieldThirdName.becomeFirstResponder()
        }else if (textField == self.fieldThirdName) {
            self.fieldLastName.becomeFirstResponder()
        }else if (textField == self.fieldLastName) {
            self.fieldMobile.becomeFirstResponder()
        }else if (textField == self.fieldMobile) {
            self.fieldMobile.resignFirstResponder()
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.fieldMobile {
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

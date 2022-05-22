//
//  afs_SenderInfoVC.swift
//  alalami
//
//  Created by Zaid Khaled on 9/13/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit

class afs_SenderInfoVC: BaseVC {
    
    @IBOutlet weak var btnBack: UIButton!
    
    
    //fields
    @IBOutlet weak var fieldFirstName: MyUITextField!
    @IBOutlet weak var fieldSecondName: MyUITextField!
    @IBOutlet weak var fieldThirdName: MyUITextField!
    @IBOutlet weak var fieldLastName: MyUITextField!
    @IBOutlet weak var fieldCountry: MyUITextField!
    @IBOutlet weak var fieldCity: MyUITextField!
    @IBOutlet weak var fieldPhoneNumber: MyUITextField!
    @IBOutlet weak var fieldEmail: MyUITextField!
    @IBOutlet weak var fieldOccupation: MyUITextField!
    @IBOutlet weak var fieldNationality: MyUITextField!
    @IBOutlet weak var fieldIdType: MyUITextField!
    @IBOutlet weak var fieldIdNumber: MyUITextField!
    @IBOutlet weak var fieldBirthDate: MyUITextField!
    @IBOutlet weak var fieldBirthCountry: MyUITextField!
    @IBOutlet weak var fieldIdIssueDate: MyUITextField!
    @IBOutlet weak var fieldIdExpiryDate: MyUITextField!
    @IBOutlet weak var fieldIdIssueCountry: MyUITextField!
    //idstatus
    @IBOutlet weak var cvIdIssueStatus: CardView!
    @IBOutlet weak var fieldIdIssueStatus: MyUITextField!
    @IBOutlet weak var fieldAddress: MyUITextField!
    
    
    //action
    @IBOutlet weak var cvContinue: CardView!
    @IBOutlet weak var btnContinue: MyUIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
        }
        
        let accountInfo = App.shared.accountInfo
        
        self.fieldFirstName.text = accountInfo?.firstNameEn ?? ""
        self.fieldSecondName.text = accountInfo?.secondNameEn ?? ""
        self.fieldThirdName.text = accountInfo?.thirdNameEn ?? ""
        self.fieldLastName.text = accountInfo?.lastNameEn ?? ""
        self.fieldCountry.text = accountInfo?.countryNameEn ?? ""
        self.fieldCity.text = accountInfo?.city ?? ""
        self.fieldPhoneNumber.text = accountInfo?.phone ?? ""
        self.fieldEmail.text = accountInfo?.emailAddress ?? ""
        self.fieldOccupation.text = accountInfo?.occupationNameEn ?? ""
        self.fieldNationality.text = accountInfo?.nationalityNameEn ?? ""
        self.fieldIdType.text = accountInfo?.identityTypeNameEn ?? ""
        self.fieldIdNumber.text = accountInfo?.identityNumber ?? ""
        self.fieldBirthDate.text = self.getStringDateWithFormat(dateStr: accountInfo?.birthOfDate ?? "", outputFormat: Constants.DATE_FORMATS.dd_mm_yyyy)
        self.fieldBirthCountry.text = accountInfo?.countryOfBirthNameEn ?? ""
        self.fieldIdIssueDate.text = self.getStringDateWithFormat(dateStr: accountInfo?.identityIssueData ?? "", outputFormat: Constants.DATE_FORMATS.dd_mm_yyyy)
        self.fieldIdExpiryDate.text = self.getStringDateWithFormat(dateStr: accountInfo?.identityExpireDate ?? "", outputFormat: Constants.DATE_FORMATS.dd_mm_yyyy)
        self.fieldIdIssueCountry.text = accountInfo?.identityIssueCountryNameEn ?? ""
        self.fieldAddress.text = accountInfo?.address ?? ""
        
        let _ = self.validate()
    }
    
    func validate() -> Bool{
        let expiryDate = self.getDateFromString(dateStr: App.shared.accountInfo?.identityExpireDate ?? "")
        if (expiryDate < Date()) {
            self.showBanner(title: "alert".localized, message: "id_is_expired".localized, style: UIColor.INFO)
            self.cvIdIssueStatus.backgroundColor = UIColor.app_red
            self.fieldIdIssueStatus.text = "expired".localized
            self.enableNext(flag: false)
            return false
        }else {
            self.cvIdIssueStatus.backgroundColor = UIColor.border_color
            self.fieldIdIssueStatus.text = ""
            self.enableNext(flag: true)
            return true
        }
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
    
    @IBAction func continueAction(_ sender: Any) {
        if (self.validate()) {
            self.pushVC(name: "afs_ReceiverInfoVC", sb: Constants.STORYBOARDS.afs)
        }
    }
    
    @IBAction func goToHome(_ sender: Any) {
        goHomeWithConfirmation()
    }
    
}

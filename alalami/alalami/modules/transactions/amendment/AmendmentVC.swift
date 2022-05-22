//
//  AmendmentVC.swift
//  alalami
//
//  Created by Zaid Khaled on 10/19/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit
import Sheeeeeeeeet

enum RequestType {
    case send
    case receive
}
protocol AmendmentDelegate {
    func didAmendRequest()
}
class AmendmentVC: BaseVC {
    
    @IBOutlet weak var btnBack: UIButton!
    
    var delegate : AmendmentDelegate?
    
    var transaction : TransactionDatum?
    
    var requestType : RequestType = .send
    
    //rejection reasons
    var reasons = [RejectionReasonDatum]()
    
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
    
    //first name ar
    @IBOutlet weak var cvFirstNameAr: CardView!
    @IBOutlet weak var fieldFirstNameAr: MyUITextField!
    
    //second name ar
    @IBOutlet weak var cvSecondNameAr: CardView!
    @IBOutlet weak var fieldSecondNameAr: MyUITextField!
    
    //third name ar
    @IBOutlet weak var cvThirdNameAr: CardView!
    @IBOutlet weak var fieldThirdNameAr: MyUITextField!
    
    //last name ar
    @IBOutlet weak var cvLastNameAr: CardView!
    @IBOutlet weak var fieldLastNameAr: MyUITextField!
    
    
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
        
        self.fieldFirstNameAr.delegate = self
        self.fieldSecondNameAr.delegate = self
        self.fieldThirdNameAr.delegate = self
        self.fieldLastNameAr.delegate = self
        
        
        let senderId = App.shared.accountInfo?.id ?? ""
        let transactionSenderId = transaction?.senderID ?? ""
        if (senderId == transactionSenderId) {
            //send request
            self.requestType = .send
            
            self.fieldFirstNameAr.text = self.transaction?.receiverFirstNameAr ?? ""
            self.fieldSecondNameAr.text = self.transaction?.receiverSecondNameAr ?? ""
            self.fieldThirdNameAr.text = self.transaction?.receiverThirdNameAr ?? ""
            self.fieldLastNameAr.text = self.transaction?.receiverLastNameAr ?? ""
            
            self.fieldFirstName.text = self.transaction?.receiverFirstNameEn ?? ""
            self.fieldSecondName.text = self.transaction?.receiverFirstNameEn ?? ""
            self.fieldThirdName.text = self.transaction?.receiverThirdNameEn ?? ""
            self.fieldLastName.text = self.transaction?.receiverLastNameEn ?? ""
            
            self.fieldMobile.text = self.transaction?.receiverMobile ?? ""
        }else{
            //receive request
            self.requestType = .receive
            
            self.fieldFirstNameAr.text = self.transaction?.senderFirstNameAr ?? ""
            self.fieldSecondNameAr.text = self.transaction?.senderSecondNameAr ?? ""
            self.fieldThirdNameAr.text = self.transaction?.senderThirdNameAr ?? ""
            self.fieldLastNameAr.text = self.transaction?.senderLastNameAr ?? ""
            
            self.fieldFirstName.text = self.transaction?.senderFirstNameEn ?? ""
            self.fieldSecondName.text = self.transaction?.senderFirstNameEn ?? ""
            self.fieldThirdName.text = self.transaction?.senderThirdNameEn ?? ""
            self.fieldLastName.text = self.transaction?.senderLastNameEn ?? ""
            
            self.fieldMobile.text = self.transaction?.receiverMobile ?? ""
        }
        
        self.validateFields()
        
    }
    
    
    @IBAction func fieldEntryChanged(_ sender: Any) {
        self.validateFields()
    }
    
    func validateFields() {
        if (self.fieldFirstName.text?.count ?? 0 == 0) {
            self.enableNext(flag: false)
            return
        }
        if (self.fieldSecondName.text?.count ?? 0 == 0) {
            self.enableNext(flag: false)
            return
        }
        if (self.fieldThirdName.text?.count ?? 0 == 0) {
            self.enableNext(flag: false)
            return
        }
        if (self.fieldLastName.text?.count ?? 0 == 0) {
            self.enableNext(flag: false)
            return
        }
        
        if (!isPureText(text: [fieldFirstName.text ?? "", fieldSecondName.text ?? "", fieldThirdName.text ?? "", fieldLastName.text ?? "", fieldFirstNameAr.text ?? "", fieldSecondNameAr.text ?? "", fieldThirdNameAr.text ?? "", fieldLastNameAr.text ?? ""])) {
            self.enableNext(flag: false)
            return
        }
        //        if (self.fieldMobile.text?.count ?? 0 == 0) {
        //            self.enableNext(flag: false)
        //            return
        //        }
        
        
        //        if (self.fieldFirstNameAr.text?.count ?? 0 == 0) {
        //            self.enableNext(flag: false)
        //            return
        //        }
        //        if (self.fieldSecondNameAr.text?.count ?? 0 == 0) {
        //            self.enableNext(flag: false)
        //            return
        //        }
        //        if (self.fieldThirdNameAr.text?.count ?? 0 == 0) {
        //            self.enableNext(flag: false)
        //            return
        //        }
        //        if (self.fieldLastNameAr.text?.count ?? 0 == 0) {
        //            self.enableNext(flag: false)
        //            return
        //        }
        
        
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
        if (self.fieldSecondName.text?.count ?? 0 == 0) {
            self.showBanner(title: "alert".localized, message: "enter_second_name".localized, style: UIColor.INFO)
            self.cvSecondName.backgroundColor = UIColor.app_red
            return false
        }
        if (!isPureText(text: fieldSecondName.text ?? "")) {
            self.showBanner(title: "alert".localized, message: "text_regex_middlename".localized, style: UIColor.INFO)
            self.cvSecondName.backgroundColor = UIColor.app_red
            return false
        }
        if (self.fieldThirdName.text?.count ?? 0 == 0) {
            self.showBanner(title: "alert".localized, message: "enter_third_name".localized, style: UIColor.INFO)
            self.cvThirdName.backgroundColor = UIColor.app_red
            return false
        }
        if (!isPureText(text: fieldThirdName.text ?? "")) {
            self.showBanner(title: "alert".localized, message: "text_regex_thirdname".localized, style: UIColor.INFO)
            self.cvThirdName.backgroundColor = UIColor.app_red
            return false
        }
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
        
        if (!isPureText(text: fieldFirstNameAr.text ?? "")) {
            self.showBanner(title: "alert".localized, message: "text_regex_firstname".localized, style: UIColor.INFO)
            self.cvFirstNameAr.backgroundColor = UIColor.app_red
            return false
        }
        if (!isPureText(text: fieldSecondNameAr.text ?? "")) {
            self.showBanner(title: "alert".localized, message: "text_regex_middlename".localized, style: UIColor.INFO)
            self.cvSecondNameAr.backgroundColor = UIColor.app_red
            return false
        }
        if (!isPureText(text: fieldThirdNameAr.text ?? "")) {
            self.showBanner(title: "alert".localized, message: "text_regex_thirdname".localized, style: UIColor.INFO)
            self.cvThirdNameAr.backgroundColor = UIColor.app_red
            return false
        }
        if (!isPureText(text: fieldLastNameAr.text ?? "")) {
            self.showBanner(title: "alert".localized, message: "text_regex_familyname".localized, style: UIColor.INFO)
            self.cvLastNameAr.backgroundColor = UIColor.app_red
            return false
        }
        
        //        if (self.fieldFirstNameAr.text?.count ?? 0 == 0) {
        //            self.showBanner(title: "alert".localized, message: "enter_first_name".localized, style: UIColor.INFO)
        //            self.cvFirstNameAr.backgroundColor = UIColor.app_red
        //            return false
        //        }
        //        if (self.fieldSecondNameAr.text?.count ?? 0 == 0) {
        //            self.showBanner(title: "alert".localized, message: "enter_second_name".localized, style: UIColor.INFO)
        //            self.cvSecondNameAr.backgroundColor = UIColor.app_red
        //            return false
        //        }
        //        if (self.fieldThirdNameAr.text?.count ?? 0 == 0) {
        //            self.showBanner(title: "alert".localized, message: "enter_third_name".localized, style: UIColor.INFO)
        //            self.cvThirdNameAr.backgroundColor = UIColor.app_red
        //            return false
        //        }
        //        if (self.fieldLastNameAr.text?.count ?? 0 == 0) {
        //            self.showBanner(title: "alert".localized, message: "enter_last_name".localized, style: UIColor.INFO)
        //            self.cvLastNameAr.backgroundColor = UIColor.app_red
        //            return false
        //        }
        
        
        //        if (self.fieldMobile.text?.count ?? 0 == 0) {
        //            self.showBanner(title: "alert".localized, message: "enter_mobile_number".localized, style: UIColor.INFO)
        //            self.cvMobile.backgroundColor = UIColor.app_red
        //            return false
        //        }
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
            loadRejectionReasonsApi()
        }
    }
    
    private func showRejectionReasonsSheet() {
        var items = [MenuItem]()
        for reason in self.reasons {
            var title = reason.caption ?? ""
            if (title.count == 0) {
                title = "---"
            }
            let item = MenuItem(title: title, value: reason.value ?? "", image: UIImage(named: "ic_indicator"))
            items.append(item)
        }
        let menu = Menu(title: "select_ammendment_reason".localized, items: items)
        
        let sheet = menu.toActionSheet { (ActionSheet, item) in
            if let value = item.value as? String {
                let reasons = self.reasons.filter { (loc) -> Bool in
                    loc.value == value
                }
                if(reasons.count > 0) {
                    self.ammendmentRequestApi(reasonId: reasons[0].value ?? "")
                }
            }
        }
        
        sheet.present(in: self, from: self.view)
    }
    
    func loadRejectionReasonsApi() {
        var isSend = false
        let senderId = App.shared.accountInfo?.id ?? ""
        let transactionSenderId = self.transaction?.senderID ?? ""
        if (senderId == transactionSenderId) {
            isSend = true
        }
        self.showLoading()
        getApiManager().getRejectionReasons(token: getAccessToken(), remittanceId: transaction?.id ?? "", isSend: isSend, isCancel: false) { (response) in
            self.hideLoading()
            self.reasons.removeAll()
            self.reasons.append(contentsOf: response.data ?? [RejectionReasonDatum]())
            self.showRejectionReasonsSheet()
        }
    }
    
    func ammendmentRequestApi(reasonId : String) {
        var isSend = false
        let senderId = App.shared.accountInfo?.id ?? ""
        let transactionSenderId = self.transaction?.senderID ?? ""
        if (senderId == transactionSenderId) {
            isSend = true
        }
        self.showLoading()
        self.getApiManager().ammendmentRequest(token: getAccessToken(), firstNameEn: fieldFirstName.text ?? "", secondNameEn: fieldSecondName.text ?? "", thirdNameEn: fieldThirdName.text ?? "", lastNameEn: fieldLastName.text ?? "", mobile: fieldMobile.text ?? "", remittanceId: transaction?.id ?? "", reasonId: reasonId, isSend: isSend) { (response) in
            self.hideLoading()
            if (response.success ?? false) {
                var message = ""
                for item in response.data ?? [AddBeneDatum]() {
                    message = "\(message).\n\(item.caption ?? "") : \(item.value ?? "")"
                }
                self.showSuccessAlert(message: message)
            }else {
                self.handleError(code: response.code, message: response.message)
            }
        }
    }
    
    func showSuccessAlert(message : String) {
        showAlert(title: "alert".localized, message: message, buttonText: "ok".localized) {
            self.delegate?.didAmendRequest()
            self.navigationController?.popViewController(animated: true)
        }
    }
}


extension AmendmentVC : UITextFieldDelegate {
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
        else if (textField == self.fieldFirstNameAr) {
            self.cvFirstNameAr.backgroundColor = UIColor.card_focused_color
        }
        else if (textField == self.fieldSecondNameAr) {
            self.cvSecondNameAr.backgroundColor = UIColor.card_focused_color
        }
        else if (textField == self.fieldThirdNameAr) {
            self.cvThirdNameAr.backgroundColor = UIColor.card_focused_color
        }
        else if (textField == self.fieldLastNameAr) {
            self.cvLastNameAr.backgroundColor = UIColor.card_focused_color
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
        
        else if (textField == self.fieldFirstNameAr) {
            self.cvFirstNameAr.backgroundColor = UIColor.card_color
        }
        else if (textField == self.fieldSecondNameAr) {
            self.cvSecondNameAr.backgroundColor = UIColor.card_color
        }
        else if (textField == self.fieldThirdNameAr) {
            self.cvThirdNameAr.backgroundColor = UIColor.card_color
        }
        else if (textField == self.fieldLastNameAr) {
            self.cvLastNameAr.backgroundColor = UIColor.card_color
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
            self.fieldLastName.resignFirstResponder()
        }
        //        else if (textField == self.fieldFirstNameAr) {
        //            self.fieldSecondNameAr.becomeFirstResponder()
        //        }
        //        else if (textField == self.fieldSecondNameAr) {
        //            self.fieldThirdNameAr.becomeFirstResponder()
        //        }
        //        else if (textField == self.fieldThirdNameAr) {
        //            self.fieldLastNameAr.becomeFirstResponder()
        //        }
        //        else if (textField == self.fieldLastNameAr) {
        //            self.fieldMobile.becomeFirstResponder()
        //        }
        //        else if (textField == self.fieldMobile) {
        //            self.fieldMobile.resignFirstResponder()
        //        }
        return false
    }
}

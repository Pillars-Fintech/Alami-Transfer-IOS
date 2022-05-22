//
//  step1_ReceiveRequestVC.swift
//  alalami
//
//  Created by Zaid Khaled on 9/16/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit
import DropDown

class step1_ReceiveRequestVC: BaseVC {
    
    @IBOutlet weak var receive: MyUILabel!
    
    
    @IBOutlet weak var btnBack: UIButton!
    
    //purpose of transfer
    @IBOutlet weak var cvPurpose: CardView!
    @IBOutlet weak var fieldPurpose: MyUITextField!
    var purposes = [RCVReasonOfTransfer]()
    var purposesDropDown : DropDown?
    var selectedPurpose : RCVReasonOfTransfer?
    
    //relationship
    @IBOutlet weak var cvRelationship: CardView!
    @IBOutlet weak var fieldRelationship: MyUITextField!
    var relationships = [RCVRelationship]()
    var relationsDropDown : DropDown?
    var selectedRelation : RCVRelationship?
    
    //remittance no
    @IBOutlet weak var cvRemittanceNo: CardView!
    @IBOutlet weak var fieldRemittanceNo: MyUITextField!
    
    
    //continue
    @IBOutlet weak var cvContinue: CardView!
    @IBOutlet weak var btnContinue: MyUIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
        }
        
        if (isArabic()) {
            receive.textAlignment = .right
        }else{
            receive.textAlignment = .left

        }
        
        
        
        
        self.enableNext(flag: false)
        
        self.fieldRemittanceNo.delegate = self
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
    
    func validate() -> Bool {
        
        if (self.selectedPurpose?.reasonOfTransferName?.count ?? 0 == 0) {
            self.showBanner(title: "alert".localized, message: "select_reason_of_transfer".localized, style: UIColor.INFO)
            cvPurpose.backgroundColor = UIColor.app_red
            return false
        }
        if (self.selectedRelation?.relationshipsName?.count ?? 0 == 0) {
            self.showBanner(title: "alert".localized, message: "select_relationship".localized, style: UIColor.INFO)
            cvRelationship.backgroundColor = UIColor.app_red
            return false
        }
        
        let remittanceNo = (self.fieldRemittanceNo.text ?? "").trim().replacedArabicDigitsWithEnglish
        
        if (remittanceNo.count == 0) {
            self.showBanner(title: "alert".localized, message: "enter_remittance_no".localized, style: UIColor.INFO)
            self.cvRemittanceNo.backgroundColor = UIColor.app_red
            return false
        }
        if (!isPureTextNumber(text: remittanceNo)) {
            self.showBanner(title: "alert".localized, message: "text_regex_remittanceno".localized, style: UIColor.INFO)
            self.cvRemittanceNo.backgroundColor = UIColor.app_red
            return false
        }
        return true
    }
    
    func fillData() {
        if (App.shared.receiveMoney == nil) {
            App.shared.receiveMoney = ReceiveMoneyModel()
        }
        
        App.shared.receiveMoney?.selectedPurpose = self.selectedPurpose
        App.shared.receiveMoney?.selectedRelationship = self.selectedRelation
        App.shared.receiveMoney?.remittanceNo = (self.fieldRemittanceNo.text ?? "").trim().replacedArabicDigitsWithEnglish
    }
    
    @IBAction func continueAction(_ sender: Any) {
        if (self.validate()) {
            self.fillData()
            self.pushVC(name: "step2_PayoutVC", sb: Constants.STORYBOARDS.receive_money)
        }
    }
    
    @IBAction func fieldEntryChanged(_ sender: Any) {
        self.validateFields()
    }
    
    func validateFields() {
        if (self.selectedPurpose?.reasonOfTransferName?.count ?? 0 == 0) {
            enableNext(flag: false)
            return
        }
        if (self.selectedRelation?.relationshipsName?.count ?? 0 == 0) {
            enableNext(flag: false)
            return
        }
        
        let remittanceNo = (self.fieldRemittanceNo.text ?? "").trim().replacedArabicDigitsWithEnglish
        
        if (remittanceNo.count == 0) {
            self.enableNext(flag: false)
            return
        }
        if (!isPureTextNumber(text: remittanceNo)) {
            self.enableNext(flag: false)
            return
        }
        
        self.enableNext(flag: true)
    }
    
    @IBAction func selectPurposeAction(_ sender: Any) {
        self.showLoading()
        self.getApiManager().getRCVReasonsOfTransfer(token: self.getAccessToken(), providerId: App.shared.receiveMoney?.serviceProviderId ?? "") { (response) in
            self.hideLoading()
            self.purposesDropDown = DropDown()
            self.purposesDropDown?.anchorView = self.cvPurpose
            var arr = [String]()
            self.purposes.removeAll()
            self.purposes.append(contentsOf: response.data ?? [RCVReasonOfTransfer]())
            for item in self.purposes {
                arr.append(item.reasonOfTransferName ?? "")
            }
            self.purposesDropDown?.dataSource = arr
            self.purposesDropDown?.show()
            
            self.purposesDropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
                self.selectedPurpose = self.purposes[index]
                self.fieldPurpose.text = self.selectedPurpose?.reasonOfTransferName ?? ""
                self.cvPurpose.backgroundColor = UIColor.card_color
                self.validateFields()
            }
        }
    }
    
    @IBAction func selectRelationshipAction(_ sender: Any) {
        self.showLoading()
        self.getApiManager().getRCVRelationships(token: self.getAccessToken(), providerId: App.shared.receiveMoney?.serviceProviderId ?? "") { (response) in
            self.hideLoading()
            self.relationsDropDown = DropDown()
            self.relationsDropDown?.anchorView = self.cvRelationship
            var arr = [String]()
            self.relationships.removeAll()
            self.relationships.append(contentsOf: response.data ?? [RCVRelationship]())
            for item in self.relationships {
                arr.append(item.relationshipsName ?? "")
            }
            self.relationsDropDown?.dataSource = arr
            self.relationsDropDown?.show()
            
            self.relationsDropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
                self.selectedRelation = self.relationships[index]
                self.fieldRelationship.text = self.selectedRelation?.relationshipsName ?? ""
                self.cvRelationship.backgroundColor = UIColor.card_color
                self.validateFields()
            }
        }
    }
    
}

extension step1_ReceiveRequestVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.fieldRemittanceNo) {
            self.cvRemittanceNo.backgroundColor = UIColor.card_focused_color
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == self.fieldRemittanceNo) {
            self.cvRemittanceNo.backgroundColor = UIColor.card_color
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == self.fieldRemittanceNo) {
            self.fieldRemittanceNo.resignFirstResponder()
        }
        return false
    }
}

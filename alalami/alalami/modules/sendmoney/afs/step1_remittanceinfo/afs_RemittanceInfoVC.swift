//
//  afs_RemittanceInfoVC.swift
//  alalami
//
//  Created by Zaid Khaled on 9/13/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit
import DropDown

class afs_RemittanceInfoVC: BaseVC {
    
    @IBOutlet weak var btnBack: UIButton!
    
    
    //destination country
    @IBOutlet weak var cvDestinationCountry: CardView!
    @IBOutlet weak var fieldDestinationCountry: MyUITextField!
    @IBOutlet weak var ivDestinationCountry: UIImageView!
    var selectedDestinationCountry : CountryDatum?
    
    
    //amount
    @IBOutlet weak var cvAmount: CardView!
    @IBOutlet weak var fieldAmount: MyUITextField!
    
    //fee type
    @IBOutlet weak var cvFeeType: CardView!
    @IBOutlet weak var fieldFeeType: MyUITextField!
    var feeTypes = ["exclude_fee".localized, "include_fee".localized]
    var feeDropDown : DropDown?
    var selectedFee : String?
    var selectedFeeValue : Int?
    
    
    //send currency (default JOD & disabled)
    @IBOutlet weak var cvSendCurrency: CardView!
    @IBOutlet weak var fieldSendCurrency: MyUITextField!
    
    
    //receive currency (default JOD & disabled)
    @IBOutlet weak var cvReceiveCurrency: CardView!
    @IBOutlet weak var fieldReceiveCurrency: MyUITextField!
    
    
    //al alami branches
    @IBOutlet weak var cvBranches: CardView!
    @IBOutlet weak var fieldBranch: MyUITextField!
    var branches = [BranchDatum]()
    var branchesDropDown : DropDown?
    var selectedBranch : BranchDatum?
    
    //purpose of transfer
    @IBOutlet weak var cvPurposeOfTransfer: CardView!
    @IBOutlet weak var fieldPurposeOfTransfer: MyUITextField!
    var purposes = [ReasonOfTransferDatum]()
    var purposesDropDown : DropDown?
    var selectedPurpose : ReasonOfTransferDatum?
    
    //source of funds
    @IBOutlet weak var cvSourceOfFunds: CardView!
    @IBOutlet weak var fieldSourceOfFunds: MyUITextField!
    var sources = [SourceOfFundsDatum]()
    var sourcesDropDown : DropDown?
    var selectedSource : SourceOfFundsDatum?
    
    
    //relationship to receiver
    @IBOutlet weak var cvRelationship: CardView!
    @IBOutlet weak var fieldRelationship: MyUITextField!
    var relationships = [RelationToReceiverDatum]()
    var relationsDropDown : DropDown?
    var selectedRelation : RelationToReceiverDatum?
    
    //promotion code
    @IBOutlet weak var cvPromotionCode: CardView!
    @IBOutlet weak var fieldPromotionCode: MyUITextField!
    
    //action
    @IBOutlet weak var cvContinue: CardView!
    @IBOutlet weak var btnContinue: MyUIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
        }
        
        //set default destination country
        //let jordanCountry = 
        
        self.fieldAmount.delegate = self
        self.fieldPromotionCode.delegate = self
        self.enableNext(flag: false)
        
        setDefaultDestinationCountry()
    }
    
    func setDefaultDestinationCountry() {
        var name = "Jordan"
        if (isArabic()) {
            name = "الأردن"
        }
        let jordan = CountryDatum(id: "8aefe101-5b1e-456f-9a8d-eca996f2622c", name: name, iso2: "", iso3: "", afexCode: 0, moneyGramCode: "", moneyGramAnathorCode: "", moneyGramDescription: "", moneyGramIncludeSend: false, moneyGramIncludeReceive: false, moneyGramIsDirectedSendCountry: false, eFAWATEERcomCode: "", eFAWATEERcomDescription: "", country_code: "", flag: "")
        
        self.selectedDestinationCountry = jordan
        self.fieldDestinationCountry.text = self.selectedDestinationCountry?.name ?? ""
        self.fieldDestinationCountry.isUserInteractionEnabled = false
        
        let url = URL(string: "\(Constants.IMAGE_URL)\(App.shared.config?.configString?.jordanFlag ?? "")")
        ivDestinationCountry.kf.setImage(with: url, placeholder: UIImage(named: ""))
       
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectDestinationCountryAction(_ sender: Any) {
        let vc : SelectCountryVC = self.getStoryBoard(name: Constants.STORYBOARDS.authentication).instantiateViewController(withIdentifier: "SelectCountryVC")
            as! SelectCountryVC
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    //fields text changed
    @IBAction func fieldEntryChanged(_ sender: Any) {
        self.validateFields()
    }
    
    @IBAction func selectFeeTypeAction(_ sender: Any) {
        self.feeDropDown = DropDown()
        self.feeDropDown?.anchorView = self.cvFeeType
        self.feeDropDown?.dataSource = self.feeTypes
        self.feeDropDown?.show()
        
        self.feeDropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectedFee = self.feeTypes[index]
            if (index == 0) {
                self.selectedFeeValue = 1
            }else {
                self.selectedFeeValue = 2
            }
            self.fieldFeeType.text = self.selectedFee ?? ""
            self.cvFeeType.backgroundColor = UIColor.card_color
            self.validateFields()
        }
    }
    
    @IBAction func selectBranchAction(_ sender: Any) {
        self.showLoading()
        self.getApiManager().getAfsBranches(token: self.getAccessToken()) { (response) in
            self.hideLoading()
            self.branchesDropDown = DropDown()
            self.branchesDropDown?.anchorView = self.cvBranches
            var arr = [String]()
            self.branches.removeAll()
            self.branches.append(contentsOf: self.getDefaultBranches())
            self.branches.append(contentsOf: response.data ?? [BranchDatum]())
            for item in self.branches {
                arr.append(item.name ?? "")
            }
            self.branchesDropDown?.dataSource = arr
            self.branchesDropDown?.show()
            
            self.branchesDropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
                self.selectedBranch = self.branches[index]
                self.fieldBranch.text = self.selectedBranch?.name ?? ""
                self.cvBranches.backgroundColor = UIColor.card_color
                self.validateFields()
            }
        }
    }
    
    @IBAction func selectPurposeOfTransferAction(_ sender: Any) {
        self.showLoading()
        self.getApiManager().getReasonsOfTransfer(token: self.getAccessToken()) { (response) in
            self.hideLoading()
            self.purposesDropDown = DropDown()
            self.purposesDropDown?.anchorView = self.cvPurposeOfTransfer
            var arr = [String]()
            self.purposes.removeAll()
            self.purposes.append(contentsOf: response.data ?? [ReasonOfTransferDatum]())
            for item in self.purposes {
                arr.append(item.name ?? "")
            }
            self.purposesDropDown?.dataSource = arr
            self.purposesDropDown?.show()
            
            self.purposesDropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
                self.selectedPurpose = self.purposes[index]
                self.fieldPurposeOfTransfer.text = self.selectedPurpose?.name ?? ""
                self.cvPurposeOfTransfer.backgroundColor = UIColor.card_color
                self.validateFields()
            }
        }
    }
    
    @IBAction func selectSourceOfFundsAction(_ sender: Any) {
        self.showLoading()
        self.getApiManager().getSourceOfFunds(token: self.getAccessToken()) { (response) in
            self.hideLoading()
            self.sourcesDropDown = DropDown()
            self.sourcesDropDown?.anchorView = self.cvSourceOfFunds
            var arr = [String]()
            self.sources.removeAll()
            self.sources.append(contentsOf: response.data ?? [SourceOfFundsDatum]())
            for item in self.sources {
                arr.append(item.name ?? "")
            }
            self.sourcesDropDown?.dataSource = arr
            self.sourcesDropDown?.show()
            
            self.sourcesDropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
                self.selectedSource = self.sources[index]
                self.fieldSourceOfFunds.text = self.selectedSource?.name ?? ""
                self.cvSourceOfFunds.backgroundColor = UIColor.card_color
                self.validateFields()
            }
        }
    }
    
    @IBAction func selectRelationshipAction(_ sender: Any) {
        self.showLoading()
        self.getApiManager().getRelationToReceiver(token: self.getAccessToken()) { (response) in
            self.hideLoading()
            self.relationsDropDown = DropDown()
            self.relationsDropDown?.anchorView = self.cvRelationship
            var arr = [String]()
            self.relationships.removeAll()
            self.relationships.append(contentsOf: response.data ?? [RelationToReceiverDatum]())
            for item in self.relationships {
                arr.append(item.name ?? "")
            }
            self.relationsDropDown?.dataSource = arr
            self.relationsDropDown?.show()
            
            self.relationsDropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
                self.selectedRelation = self.relationships[index]
                self.fieldRelationship.text = self.selectedRelation?.name ?? ""
                self.cvRelationship.backgroundColor = UIColor.card_color
                self.validateFields()
            }
        }
    }
    
    @IBAction func continueAction(_ sender: Any) {
        if (self.validate()) {
            self.fillData()
            self.pushVC(name: "afs_ReceiverInfoVC", sb: Constants.STORYBOARDS.afs)
        }
    }
    
    func validate() -> Bool {
        let amount = (self.fieldAmount.text ?? "").trim().replacedArabicDigitsWithEnglish
        //  let promocode = (self.fieldPromotionCode.text ?? "").trim()
        
        if (self.selectedDestinationCountry?.name?.count ?? 0 == 0) {
            self.showBanner(title: "alert".localized, message: "select_destination_country".localized, style: UIColor.INFO)
            self.cvDestinationCountry.backgroundColor = UIColor.app_red
            return false
        }
        if (amount.count == 0) {
            self.showBanner(title: "alert".localized, message: "enter_amount".localized, style: UIColor.INFO)
            self.cvAmount.backgroundColor = UIColor.app_red
            return false
        }
        
        let doubleAmount = Double(amount)
        if (doubleAmount == 0) {
            self.showBanner(title: "alert".localized, message: "enter_amount".localized, style: UIColor.INFO)
            self.cvAmount.backgroundColor = UIColor.app_red
            return false
        }
        
        if (self.selectedFeeValue ?? 0 == 0) {
            self.showBanner(title: "alert".localized, message: "select_fee_type".localized, style: UIColor.INFO)
            self.cvFeeType.backgroundColor = UIColor.app_red
            return false
        }
        if (self.selectedBranch?.name?.count ?? 0 == 0) {
            self.showBanner(title: "alert".localized, message: "select_branch_first".localized, style: UIColor.INFO)
            cvBranches.backgroundColor = UIColor.app_red
            return false
        }
        if (self.selectedPurpose?.name?.count ?? 0 == 0) {
            self.showBanner(title: "alert".localized, message: "select_reason_of_transfer".localized, style: UIColor.INFO)
            cvPurposeOfTransfer.backgroundColor = UIColor.app_red
            return false
        }
        if (self.selectedSource?.name?.count ?? 0 == 0) {
            self.showBanner(title: "alert".localized, message: "select_source_of_fund".localized, style: UIColor.INFO)
            cvSourceOfFunds.backgroundColor = UIColor.app_red
            return false
        }
        if (self.selectedRelation?.name?.count ?? 0 == 0) {
            self.showBanner(title: "alert".localized, message: "select_relationship_to_receiver".localized, style: UIColor.INFO)
            cvRelationship.backgroundColor = UIColor.app_red
            return false
        }
        return true
    }
    
    func fillData() {
        if (App.shared.sendMoneyAFS == nil) {
            App.shared.sendMoneyAFS = SendMoneyAFSModel()
        }
        let amountText = (self.fieldAmount.text ?? "").trim().replacedArabicDigitsWithEnglish
        
        App.shared.sendMoneyAFS?.destinationCountry = self.selectedDestinationCountry
        App.shared.sendMoneyAFS?.amount = amountText
        App.shared.sendMoneyAFS?.feeType = self.selectedFeeValue
        App.shared.sendMoneyAFS?.sendCurrency = "JOD"
        App.shared.sendMoneyAFS?.receiveCurrency = "JOD"
        App.shared.sendMoneyAFS?.alamiBranch = self.selectedBranch
        App.shared.sendMoneyAFS?.purpose = self.selectedPurpose
        App.shared.sendMoneyAFS?.sourceOfFunds = self.selectedSource
        App.shared.sendMoneyAFS?.relationship = self.selectedRelation
        App.shared.sendMoneyAFS?.promotionCode = (self.fieldPromotionCode.text ?? "").trim()
    }
    
    
    func validateFields() {
        let amount = (self.fieldAmount.text ?? "").trim().replacedArabicDigitsWithEnglish
        //  let promocode = (self.fieldPromotionCode.text ?? "").trim()
        
        if (self.selectedDestinationCountry?.name?.count ?? 0 == 0) {
            self.enableNext(flag: false)
            return
        }
        if (amount.count == 0) {
            self.enableNext(flag: false)
            return
        }
        
        let doubleAmount = Double(amount)
        if (doubleAmount == 0) {
            self.enableNext(flag: false)
            return
        }
        
        if (self.selectedFeeValue ?? 0 == 0) {
            self.enableNext(flag: false)
            return
        }
        if (self.selectedBranch?.name?.count ?? 0 == 0) {
            self.enableNext(flag: false)
            return
        }
        if (self.selectedPurpose?.name?.count ?? 0 == 0) {
            self.enableNext(flag: false)
            return
        }
        if (self.selectedSource?.name?.count ?? 0 == 0) {
            self.enableNext(flag: false)
            return
        }
        if (self.selectedRelation?.name?.count ?? 0 == 0) {
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
    
    @IBAction func goToHome(_ sender: Any) {
        goHomeWithConfirmation()
    }
    
    
}

extension afs_RemittanceInfoVC : CountryDelegate {
    func didSelectCountry(country: CountryDatum) {
        self.selectedDestinationCountry = country
        self.fieldDestinationCountry.text = country.name ?? ""
        let url = URL(string: "\(Constants.IMAGE_URL)\(country.flag ?? "")")
        ivDestinationCountry.kf.setImage(with: url, placeholder: UIImage(named: ""))
        self.cvDestinationCountry.backgroundColor = UIColor.card_color
        self.validateFields()
    }
}


extension afs_RemittanceInfoVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.fieldAmount) {
            self.cvAmount.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldPromotionCode) {
            self.cvPromotionCode.backgroundColor = UIColor.card_focused_color
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == self.fieldAmount) {
            self.cvAmount.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldPromotionCode) {
            self.cvPromotionCode.backgroundColor = UIColor.card_color
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == self.fieldAmount) {
            self.fieldAmount.resignFirstResponder()
        }else if (textField == self.fieldPromotionCode) {
            self.fieldPromotionCode.resignFirstResponder()
        }
        return false
    }
}

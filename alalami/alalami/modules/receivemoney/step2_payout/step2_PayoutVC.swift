//
//  step2_PayoutVC.swift
//  alalami
//
//  Created by Zaid Khaled on 9/16/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit
import DropDown

class step2_PayoutVC: BaseVC {
    
    var isInternal:Bool?
    
    @IBOutlet weak var lReceive: MyUILabel!
    
    
    var services = [ServiceDatum]()

    @IBOutlet weak var btnBack: UIButton!
    
    
    //pay out method
    @IBOutlet weak var cvPayOutMethod: CardView!
    @IBOutlet weak var fieldPayOutMethod: MyUITextField!
    var payOutMethods = [PayOutMethodDatum]()
    var methodsDropDown : DropDown?
    var selectedMethod : PayOutMethodDatum?
    
    
    //receiver address
    @IBOutlet weak var viewReceiverAddress: UIView!
    
    @IBOutlet weak var cvReceiverRegion: CardView!
    @IBOutlet weak var fieldReceiverRegion: MyUITextField!
    
    @IBOutlet weak var cvReceiverCity: CardView!
    @IBOutlet weak var fieldReceiverCity: MyUITextField!
    
    @IBOutlet weak var cvReceiverStreet: CardView!
    @IBOutlet weak var fieldReceiverStreet: MyUITextField!
    
    @IBOutlet weak var cvReceiverBuildingName: CardView!
    @IBOutlet weak var fieldReceiverBuildingName: MyUITextField!
    
    @IBOutlet weak var cvReceiverBuildingNumber: CardView!
    @IBOutlet weak var fieldReceiverBuildingNumber: MyUITextField!
    
    @IBOutlet weak var cvReceiverApartment: CardView!
    @IBOutlet weak var fieldReceiverApartment: MyUITextField!
    
    @IBOutlet weak var cvReceiverAddress: CardView!
    @IBOutlet weak var fieldReceiverAddress: MyUITextField!
    
    
    //wallet
    @IBOutlet weak var viewWallet: UIView!
    
    @IBOutlet weak var cvWalletProvider: CardView!
    @IBOutlet weak var fieldWalletProvider: MyUITextField!
    var walletProviders = [WalletProviderDatum]()
    var walletsDropDown : DropDown?
    var selectedWallet : WalletProviderDatum?
    
    @IBOutlet weak var cvWalletNumber: CardView!
    @IBOutlet weak var fieldWalletNumber: MyUITextField!
    
    
    //bank
    @IBOutlet weak var viewBank: UIView!
    
    @IBOutlet weak var cvBank: CardView!
    @IBOutlet weak var fieldBank: MyUITextField!
    
    
    
    
    //click
    
    @IBOutlet weak var viewCliq: UIView!
    @IBOutlet weak var fieldIBANNumber: MyUITextField!
    @IBOutlet weak var cvIBANs: CardView!
    @IBOutlet weak var labelIBAN: MyUILabel!
    
    
    // labelIBAN,fieldIBANNumber
    var banks = [BankDatum]()
    var banksDropDown : DropDown?
    var selectedBank : BankDatum?
    
    @IBOutlet weak var cvIBAN: CardView!
    @IBOutlet weak var fieldIBAN: MyUITextField!
    
    @IBOutlet weak var cvAccountNumber: CardView!
    @IBOutlet weak var fieldAccountNumber: MyUITextField!
    
    //continue
    @IBOutlet weak var cvContinue: CardView!
    @IBOutlet weak var btnContinue: MyUIButton!
    
    var paymentDetails : RCVConfirm?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
        }
        if (isArabic()) {
            lReceive.textAlignment = .right
        }else{
            lReceive.textAlignment = .left

        }
        // labelIBAN,fieldIBANNumber

        //INBN
        labelIBAN.text = "Recipient's IBAN or Alias".localized
        fieldIBANNumber.placeholder = "Enter IBAN or Alias here".localized
        
        if App.shared.receiveMoney?.serviceProviderId == "836cba2e-6fbb-450a-9907-2a3b9bc72098"{
            isInternal = false
        }else{
            isInternal = true
        }
        
        self.enableNext(flag: false)
        
        self.fieldBank.delegate = self
        self.fieldAccountNumber.delegate = self
        self.fieldIBAN.delegate = self
        self.fieldIBANNumber.delegate = self

        
        self.fieldReceiverRegion.delegate = self
        self.fieldReceiverCity.delegate = self
        self.fieldReceiverStreet.delegate = self
        self.fieldReceiverBuildingName.delegate = self
        self.fieldReceiverBuildingNumber.delegate = self
        self.fieldReceiverApartment.delegate = self
        self.fieldReceiverAddress.delegate = self
        
        self.fieldWalletNumber.delegate = self
    }
    
    
    @IBAction func selectPayoutMethodAction(_ sender: Any) {
        self.showLoading()
        self.getApiManager().getPayOutMethods(token: self.getAccessToken()) { (response) in
            self.hideLoading()
            self.methodsDropDown = DropDown()
            self.methodsDropDown?.anchorView = self.cvPayOutMethod
            var arr = [String]()
            self.payOutMethods.removeAll()
            self.payOutMethods.append(contentsOf: response.data ?? [PayOutMethodDatum]())
            for item in self.payOutMethods {
                arr.append(item.name ?? "")
            }
            self.methodsDropDown?.dataSource = arr
            self.methodsDropDown?.show()
            
            self.methodsDropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
                self.selectedMethod = self.payOutMethods[index]
                self.fieldPayOutMethod.text = self.selectedMethod?.name ?? ""
                self.cvPayOutMethod.backgroundColor = UIColor.card_color
                self.validateSelectedPayOutMethod()
            }
        }
    }
    
    func validateSelectedPayOutMethod() {
        let payInMethodCode = self.selectedMethod?.code ?? "01"
        
        print("payInMethodCode\(payInMethodCode)")
        switch payInMethodCode {
        case "01": // Door to door
            self.doorToDoorUI()
            break
        case "02": // eWallet
            self.eWalletUI()
            break
        case "03": // bank
            self.bankUI()
            break
        case "04": // bank
            self.cliqUI()
            break
        default:
            self.defaultUI()
            break
        }
        self.validateFields()
    }
    
    func doorToDoorUI() {
        self.viewReceiverAddress.isHidden = false
        self.viewBank.isHidden = true
        self.viewWallet.isHidden = true
        self.viewCliq.isHidden = true

    }
    
    
    //all work start here
    func eWalletUI() {
        self.fieldWalletNumber.text = ""
        self.fieldWalletProvider.text = ""
        self.selectedWallet = nil
        self.viewReceiverAddress.isHidden = true
        self.viewBank.isHidden = true
        self.viewWallet.isHidden = false
        self.viewCliq.isHidden = true

        self.validateFields()
        
    }
    
    func bankUI() {
        self.viewReceiverAddress.isHidden = true
        self.viewBank.isHidden = false
        self.viewWallet.isHidden = true
        self.viewCliq.isHidden = true

    }
    
    
    func cliqUI() {
        
        self.fieldIBANNumber.text = ""
        self.selectedWallet = nil
        self.viewReceiverAddress.isHidden = true
        self.viewBank.isHidden = true
        self.viewWallet.isHidden = true
        self.viewCliq.isHidden = false
    }
    
    func defaultUI() {
        self.viewReceiverAddress.isHidden = true
        self.viewBank.isHidden = true
        self.viewWallet.isHidden = true
        self.viewCliq.isHidden = true

    }
    
    
    
    
    
    @IBAction func selectWalletProviderAction(_ sender: Any) {
        self.showLoading()
        self.getApiManager().getWalletProviders(token: self.getAccessToken(), isInternal: isInternal!) { (response) in
            self.hideLoading()
            self.walletsDropDown = DropDown()
            self.walletsDropDown?.anchorView = self.cvWalletProvider
            var arr = [String]()
            self.walletProviders.removeAll()
            for apiProvider in response.data ?? [WalletProviderDatum]() {
                if (apiProvider.isAvailableReceived ?? false) {
                    self.walletProviders.append(apiProvider)
                    arr.append(apiProvider.name ?? "")
                }
            }
            
            print("arr \(arr)")
            self.walletsDropDown?.dataSource = arr
            self.walletsDropDown?.show()
          
            
            self.walletsDropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
                self.selectedWallet = self.walletProviders[index]
                
                print("selectedWallet:\(selectedWallet?.name)")
                self.fieldWalletProvider.text = self.selectedWallet?.name ?? ""
                self.cvWalletProvider.backgroundColor = UIColor.card_color
                self.validateFields()
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func fillData() {
        App.shared.receiveMoney?.payoutOption = self.selectedMethod
        
        App.shared.receiveMoney?.ReceiverRegion = self.fieldReceiverRegion.text ?? ""
        App.shared.receiveMoney?.ReceiverCity = self.fieldReceiverCity.text ?? ""
        App.shared.receiveMoney?.ReceiverStreet = self.fieldReceiverStreet.text ?? ""
        App.shared.receiveMoney?.ReceiverBuildingName = self.fieldReceiverBuildingName.text ?? ""
        App.shared.receiveMoney?.ReceiverBuildingNumber = self.fieldReceiverBuildingNumber.text ?? ""
        App.shared.receiveMoney?.ReceiverApartment = self.fieldReceiverApartment.text ?? ""
        App.shared.receiveMoney?.ReceiverAddress = self.fieldReceiverAddress.text ?? ""
        
        App.shared.receiveMoney?.walletProvider = self.selectedWallet
        App.shared.receiveMoney?.walletNumber = self.fieldWalletNumber.text ?? ""
        
        App.shared.receiveMoney?.selectedBank = self.selectedBank
//        App.shared.receiveMoney?.IBAN = (self.fieldIBAN.text ?? "").trim()
        App.shared.receiveMoney?.IBAN = (self.fieldIBANNumber.text ?? "").trim()

        
        
        App.shared.receiveMoney?.accountNumber = (self.fieldAccountNumber.text ?? "").trim()
    }
    
    @IBAction func continueAction(_ sender: Any) {
        
//        cvContinue.isHidden = true
        
        
        btnContinue.isEnabled = false
        
        if (self.validate()) {
            self.fillData()
            self.showLoading()
            self.getApiManager().getRCVPaymentDetails(token: self.getAccessToken(), receiveModel: App.shared.receiveMoney) { (response) in
                self.hideLoading()
                if (response.success ?? false) {
                    App.shared.receiveMoney?.rcvGuid = response.data?.rcvGUID ?? ""
                    self.showConfirmationAlert(includeOtp: response.data?.includeOTP ?? false, info : response.data?.confirmInfo ?? [ConfirmInfo]())
                }else {
                    self.handleError(code : response.code ?? "", message : response.message ?? ["Somethig Wrong"])
//                    self.cvContinue.isHidden = false
                    self.btnContinue.isEnabled = true


                }
            }
        }
    }
    
    private func showConfirmationAlert(includeOtp : Bool, info : [ConfirmInfo]) {
        
        var text = ""
        
        for textItem in info {
            text = "\(text)\n\n\(textItem.caption ?? "") : \(textItem.value ?? "")"
        }
        
//        self.showAlert(title: "alert".localized, message: text, buttonText: "yes".localized) {
//            if (includeOtp) {
//                //needs OTP verification to confirm remittance
//                self.startOTPVerificationProcess()
//            }else {
//               //no need fo OTP verification, submit request
//                self.receiveMoneyApi()
//            }
//        }
        
        
        self.showAlertDaynamic(title: "alert".localized, message: text, actionTitle: "Ok", cancelTitle: "Cancel", actionHandler: {
            
            if (includeOtp) {
                //needs OTP verification to confirm remittance
                self.startOTPVerificationProcess()
            }else {
               //no need fo OTP verification, submit request
                self.receiveMoneyApi()
            }
            
        }, cancelHandler: nil)
        
    }
    
    
    private func startOTPVerificationProcess() {
        let vc : RCV_VerifyPaymentVC = self.getStoryBoard(name: Constants.STORYBOARDS.receive_money).instantiateViewController(withIdentifier: "RCV_VerifyPaymentVC") as! RCV_VerifyPaymentVC
        vc.delegate = self
        vc.rcvGuid = self.paymentDetails?.rcvGUID ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func receiveMoneyApi() {
        self.showLoading()
        getApiManager().submitRCVRequest(token: getAccessToken(), receiveModel: App.shared.receiveMoney) { (response) in
            self.hideLoading()
            if (response.success ?? false) {
                self.openCompletedScreen(transaction: response.data ?? [RCVSentDatum]())
            }else {
                self.handleError(code : response.code ?? "", message : response.message)
            }
        }
    }
    
    private func openCompletedScreen(transaction : [RCVSentDatum]) {
        let vc : step3_RCVSuccessVC = self.getStoryBoard(name: Constants.STORYBOARDS.receive_money).instantiateViewController(withIdentifier: "step3_RCVSuccessVC") as! step3_RCVSuccessVC
        vc.details = transaction
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func selectBank(_ sender: Any) {
        self.showLoading()
        self.getApiManager().getBanks(token: self.getAccessToken()) { (response) in
            self.hideLoading()
            self.banksDropDown = DropDown()
            self.banksDropDown?.anchorView = self.cvBank
            var arr = [String]()
            self.banks.removeAll()
            self.banks.append(contentsOf: response.data ?? [BankDatum]())
            for item in self.banks {
                arr.append(item.name ?? "")
            }
            self.banksDropDown?.dataSource = arr
            self.banksDropDown?.show()
            
            self.banksDropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
                self.selectedBank = self.banks[index]
                self.fieldBank.text = self.selectedBank?.name ?? ""
                self.cvBank.backgroundColor = UIColor.card_color
                self.validateFields()
            }
        }
    }
    
    @IBAction func fieldEntryChanged(_ sender: Any) {
        self.validateFields()
    }
    
    func validateFields() {
        if (selectedMethod?.name?.count ?? 0 == 0) {
            self.enableNext(flag: false)
            return
        }
        if (self.selectedMethod?.code == "01") { //door to door
            if (self.fieldReceiverRegion.text?.count ?? 0 == 0) {
                self.enableNext(flag: false)
                return
            }
            if (self.fieldReceiverCity.text?.count ?? 0 == 0) {
                self.enableNext(flag: false)
                return
            }
            if (self.fieldReceiverStreet.text?.count ?? 0 == 0) {
                self.enableNext(flag: false)
                return
            }
            if (self.fieldReceiverBuildingName.text?.count ?? 0 == 0) {
                self.enableNext(flag: false)
                return
            }
            if (self.fieldReceiverBuildingNumber.text?.count ?? 0 == 0) {
                self.enableNext(flag: false)
                return
            }
            if (self.fieldReceiverApartment.text?.count ?? 0 == 0) {
                self.enableNext(flag: false)
                return
            }
            if (self.fieldReceiverAddress.text?.count ?? 0 == 0) {
                self.enableNext(flag: false)
                return
            }
            if (!isPureText(text: [fieldReceiverRegion.text ?? "", fieldReceiverCity.text ?? "", fieldReceiverBuildingNumber.text ?? "", fieldReceiverBuildingName.text ?? "", fieldReceiverApartment.text ?? "", fieldReceiverAddress.text ?? ""])) {
                self.enableNext(flag: false)
                return
            }
        }
        
        if (self.selectedMethod?.code == "02") { //eWallet
            if (self.selectedWallet?.name?.count ?? 0 == 0) {
                self.enableNext(flag: false)
                return
            }
            if (self.fieldWalletNumber.text?.count ?? 0 == 0) {
                self.enableNext(flag: false)
                return
            }
            if (!isPureTextNumber(text: (fieldWalletNumber.text ?? "").replacedArabicDigitsWithEnglish)) {
                self.enableNext(flag: false)
                return
            }
        }
        
        
    
        
        if (self.selectedMethod?.code == "03") { //bank
            if (self.selectedBank?.name?.count ?? 0 == 0) {
                self.enableNext(flag: false)
                return
            }
            if (self.fieldIBAN.text?.count ?? 0 == 0) {
                self.enableNext(flag: false)
                return
            }
            
            if (self.fieldAccountNumber.text?.count ?? 0 == 0) {
                self.enableNext(flag: false)
                return
            }
            if (!isPureText(text: [fieldIBAN.text ?? "", (fieldAccountNumber.text ?? "").replacedArabicDigitsWithEnglish])) {
                self.enableNext(flag: false)
                return
            }
        }
        
        
        
//        
//        if (self.selectedMethod?.code == "04") { //eWallet
//            if (self.fieldIBANNumber.text?.count ?? 0 == 0) {
//                self.enableNext(flag: false)
//                return
//            }
//            
//            if (self.fieldIBANNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
//                self.enableNext(flag: false)
//                return
//            }
//            
//        }

        self.enableNext(flag: true)
    }
    
    
    func validate() -> Bool {
        if (self.selectedMethod?.name?.count ?? 0 == 0) {
            self.cvPayOutMethod.backgroundColor = UIColor.app_red
            return false
        }
        if (self.selectedMethod?.code == "01") { //door to door
            if (self.fieldReceiverRegion.text?.count ?? 0 == 0) {
                self.showBanner(title: "alert".localized, message: "enter_receiver_region".localized, style: UIColor.INFO)
                self.cvReceiverRegion.backgroundColor = UIColor.app_red
                return false
            }
            if (!isPureText(text: fieldReceiverRegion.text ?? "")) {
                self.showBanner(title: "alert".localized, message: "text_regex_region".localized, style: UIColor.INFO)
                self.cvReceiverRegion.backgroundColor = UIColor.app_red
                return false
            }
            if (self.fieldReceiverCity.text?.count ?? 0 == 0) {
                self.showBanner(title: "alert".localized, message: "enter_receiver_city".localized, style: UIColor.INFO)
                self.cvReceiverCity.backgroundColor = UIColor.app_red
                return false
            }
            if (!isPureText(text: fieldReceiverCity.text ?? "")) {
                self.showBanner(title: "alert".localized, message: "text_regex_city".localized, style: UIColor.INFO)
                self.cvReceiverCity.backgroundColor = UIColor.app_red
                return false
            }
            if (self.fieldReceiverStreet.text?.count ?? 0 == 0) {
                self.showBanner(title: "alert".localized, message: "enter_receiver_street".localized, style: UIColor.INFO)
                self.cvReceiverStreet.backgroundColor = UIColor.app_red
                return false
            }
            if (!isPureText(text: fieldReceiverStreet.text ?? "")) {
                self.showBanner(title: "alert".localized, message: "text_regex_street".localized, style: UIColor.INFO)
                self.cvReceiverStreet.backgroundColor = UIColor.app_red
                return false
            }
            if (self.fieldReceiverBuildingName.text?.count ?? 0 == 0) {
                self.showBanner(title: "alert".localized, message: "enter_receiver_building_name".localized, style: UIColor.INFO)
                self.cvReceiverBuildingName.backgroundColor = UIColor.app_red
                return false
            }
            if (!isPureText(text: fieldReceiverBuildingName.text ?? "")) {
                self.showBanner(title: "alert".localized, message: "text_regex_building_name".localized, style: UIColor.INFO)
                self.cvReceiverBuildingName.backgroundColor = UIColor.app_red
                return false
            }
            if (self.fieldReceiverBuildingNumber.text?.count ?? 0 == 0) {
                self.showBanner(title: "alert".localized, message: "enter_receiver_building_number".localized, style: UIColor.INFO)
                self.cvReceiverRegion.backgroundColor = UIColor.app_red
                return false
            }
            if (!isPureText(text: fieldReceiverBuildingNumber.text ?? "")) {
                self.showBanner(title: "alert".localized, message: "text_regex_building_number".localized, style: UIColor.INFO)
                self.cvReceiverBuildingNumber.backgroundColor = UIColor.app_red
                return false
            }
            if (self.fieldReceiverApartment.text?.count ?? 0 == 0) {
                self.showBanner(title: "alert".localized, message: "enter_receiver_apartment".localized, style: UIColor.INFO)
                self.cvReceiverApartment.backgroundColor = UIColor.app_red
                return false
            }
            if (!isPureText(text: fieldReceiverApartment.text ?? "")) {
                self.showBanner(title: "alert".localized, message: "text_regex_apartment".localized, style: UIColor.INFO)
                self.cvReceiverApartment.backgroundColor = UIColor.app_red
                return false
            }
            if (self.fieldReceiverAddress.text?.count ?? 0 == 0) {
                self.showBanner(title: "alert".localized, message: "enter_receiver_address".localized, style: UIColor.INFO)
                self.cvReceiverAddress.backgroundColor = UIColor.app_red
                return false
            }
            if (!isPureText(text: fieldReceiverAddress.text ?? "")) {
                self.showBanner(title: "alert".localized, message: "text_regex_address".localized, style: UIColor.INFO)
                self.cvReceiverAddress.backgroundColor = UIColor.app_red
                return false
            }
        }
        if (self.selectedMethod?.code == "02") { //eWallet
            if (self.selectedWallet?.name?.count ?? 0 == 0) {
                self.showBanner(title: "alert".localized, message: "select_wallet_provider".localized, style: UIColor.INFO)
                self.cvWalletProvider.backgroundColor = UIColor.app_red
                return false
            }
            if (self.fieldWalletNumber.text?.count ?? 0 == 0) {
                self.showBanner(title: "alert".localized, message: "enter_wallet_number".localized, style: UIColor.INFO)
                self.cvWalletNumber.backgroundColor = UIColor.app_red
                return false
            }
            if (!isPureTextNumber(text: (fieldWalletNumber.text ?? "").replacedArabicDigitsWithEnglish)) {
                self.showBanner(title: "alert".localized, message: "text_regex_walletnumber".localized, style: UIColor.INFO)
                self.cvWalletNumber.backgroundColor = UIColor.app_red
                return false
            }
        }
        
        
        
        if (self.selectedMethod?.code == "03") { //bank
            if (self.selectedBank?.name?.count ?? 0 == 0) {
                self.showBanner(title: "alert".localized, message: "select_bank".localized, style: UIColor.INFO)
                self.cvWalletProvider.backgroundColor = UIColor.app_red
                return false
            }
            if (self.fieldIBAN.text?.count ?? 0 == 0) {
                self.showBanner(title: "alert".localized, message: "enter_iban".localized, style: UIColor.INFO)
                self.cvIBAN.backgroundColor = UIColor.app_red
                return false
            }
            
            
            if (!isPureText(text: fieldIBAN.text ?? "")) {
                self.showBanner(title: "alert".localized, message: "text_regex_iban".localized, style: UIColor.INFO)
                self.cvIBAN.backgroundColor = UIColor.app_red
                return false
            }
            if (self.fieldAccountNumber.text?.count ?? 0 == 0) {
                self.showBanner(title: "alert".localized, message: "enter_account_number".localized, style: UIColor.INFO)
                self.cvAccountNumber.backgroundColor = UIColor.app_red
                return false
            }
            if (!isPureText(text: (fieldAccountNumber.text ?? "").replacedArabicDigitsWithEnglish)) {
                self.showBanner(title: "alert".localized, message: "text_regex_accountnumber".localized, style: UIColor.INFO)
                self.cvAccountNumber.backgroundColor = UIColor.app_red
                return false
            }
        }
        
        if (self.selectedMethod?.code == "04") { //bank
            if (self.fieldIBANNumber.text?.count ?? 0 == 0) {
                self.showBanner(title: "alert".localized, message: "enter_ibans".localized, style: UIColor.INFO)
                self.cvIBANs.backgroundColor = UIColor.app_red
                return false
            }
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
    
}

extension step2_PayoutVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.fieldReceiverRegion) {
            self.cvReceiverRegion.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldReceiverCity) {
            self.cvReceiverCity.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldReceiverStreet) {
            self.cvReceiverStreet.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldReceiverBuildingName) {
            self.cvReceiverBuildingName.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldReceiverBuildingNumber) {
            self.cvReceiverBuildingNumber.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldReceiverApartment) {
            self.cvReceiverApartment.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldReceiverAddress) {
            self.cvReceiverAddress.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldWalletNumber) {
            self.cvWalletNumber.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldBank) {
            self.cvBank.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldAccountNumber) {
            self.cvAccountNumber.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldIBAN) {
            self.cvIBAN.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldIBANNumber) {
            self.cvIBANs.backgroundColor = UIColor.card_focused_color
        }
        
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == self.fieldReceiverRegion) {
            self.cvReceiverRegion.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldReceiverCity) {
            self.cvReceiverCity.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldReceiverStreet) {
            self.cvReceiverStreet.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldReceiverBuildingName) {
            self.cvReceiverBuildingName.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldReceiverBuildingNumber) {
            self.cvReceiverBuildingNumber.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldReceiverApartment) {
            self.cvReceiverApartment.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldReceiverAddress) {
            self.cvReceiverAddress.backgroundColor = UIColor.card_color
        }
        else if (textField == self.fieldWalletNumber) {
            self.cvWalletNumber.backgroundColor = UIColor.card_color
        }
        else if (textField == self.fieldBank) {
            self.cvBank.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldAccountNumber) {
            self.cvAccountNumber.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldIBAN) {
            self.cvIBAN.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldIBANNumber) {
            self.cvIBANs.backgroundColor = UIColor.card_color
        }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         if (textField == self.fieldReceiverRegion) {
            self.fieldReceiverCity.becomeFirstResponder()
        }else if (textField == self.fieldReceiverCity) {
            self.fieldReceiverStreet.becomeFirstResponder()
        }else if (textField == self.fieldReceiverStreet) {
            self.fieldReceiverBuildingName.becomeFirstResponder()
        }else if (textField == self.fieldReceiverBuildingName) {
            self.fieldReceiverBuildingNumber.becomeFirstResponder()
        }else if (textField == self.fieldReceiverBuildingNumber) {
            self.fieldReceiverApartment.becomeFirstResponder()
        }else if (textField == self.fieldReceiverApartment) {
            self.fieldReceiverAddress.becomeFirstResponder()
        }else if (textField == self.fieldReceiverAddress) {
            self.fieldReceiverAddress.resignFirstResponder()
        }
        
        else if (textField == self.fieldWalletNumber) {
            self.fieldWalletNumber.resignFirstResponder()
        }
        
        else if (textField == self.fieldIBAN) {
            self.fieldAccountNumber.becomeFirstResponder()
        }
        
        else if (textField == self.fieldIBANNumber) {
            self.fieldIBANNumber.becomeFirstResponder()
        }
        
        else if (textField == self.fieldIBANNumber) {
            self.fieldIBANNumber.resignFirstResponder()
        }
                
        
        else if (textField == self.fieldAccountNumber) {
            self.fieldAccountNumber.resignFirstResponder()
        }
        return false
    }
}

extension step2_PayoutVC : VerifyRCVProtocol {
    func onVerify(code: String) {
        App.shared.receiveMoney?.otpCode = code
        self.receiveMoneyApi()
    }
}

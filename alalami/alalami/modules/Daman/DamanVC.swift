//
//  DamanVC.swift
//  alalami
//
//  Created by Pillars Fintech on 24/04/2022.
//  Copyright © 2022 technzone. All rights reserved.
//

import UIKit
import DropDown


class DamanVC: BaseVC {
    
    @IBOutlet weak var cvPaymentType: CardView!
    @IBOutlet weak var paymentField: MyUITextField!
    @IBOutlet weak var paymentImage: UIImageView!
    @IBOutlet weak var paymentButton: UIButton!
    
    var paymentTypes = [DamanServiceType]()
    var selectedPaymentType : DamanServiceType?


    var paymentDown : DropDown?
    var selectedPayment : String?
    var selectedPaymentValue: Int?
    var payTypes = ""
    
    
    
    
    
    
    
    @IBOutlet weak var cvReferenceNumber: CardView!
    @IBOutlet weak var ReferenceNumberField: MyUITextField!
    
    
    @IBOutlet weak var cvCSSINumber: CardView!
    @IBOutlet weak var CSSINumberField: MyUITextField!
    
    
    @IBOutlet weak var cvSubmit: CardView!
    @IBOutlet weak var submitButton: MyUIButton!
    
    
    @IBOutlet weak var individualsImage: UIImageView!
    @IBOutlet weak var individualsLabel: MyUILabel!
    
    @IBOutlet weak var facilitiesImage: UIImageView!
    @IBOutlet weak var facilitiesLabel: MyUILabel!
    
    var numReqtype = ""
    
    
    
    @IBOutlet weak var btnBack: UIButton!
    
    
    
    
    var services = [ServiceDatum]()
    var idMonyGram = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
        }
        
        
        self.facilitiesImage.image = UIImage(named: "ic_language_unselected")
        self.individualsImage.image = UIImage(named: "ic_language_unselected")
        
        
        self.ReferenceNumberField.delegate = self

        self.CSSINumberField.delegate = self
        self.paymentImage.tintColor = .black
        
        self.enableNext(flag: false)
        
        
        loadServices()
        print("Main idMonyGram::\(idMonyGram)")

    }
    
    func loadServices() {
        self.showLoading()
        self.getApiManager().getServiceProviders(token: self.getAccessToken()) { (response) in
            self.hideLoading()
            if (response.success ?? false) {
                self.services.removeAll()
                self.services.append(contentsOf: response.data ?? [ServiceDatum]())
                
                
                for service in self.services {
                    
                    
                    if service.name == "MoneyGram"{
                        print("service\(service.servicesProviderID ?? "")")
                        self.idMonyGram = service.servicesProviderID ?? ""
                    }
                    
                    
                }
//                print("dsdsdssd\( self.services)")

                
            }else {
                self.handleError(code: response.code, message: response.message)
            }
        }
    }
    
    
    @IBAction func paymentTypeAction(_ sender: Any) {

    
        self.showLoading()
        self.getApiManager().getDamanServiceType(token:self.getAccessToken(), reqtype: numReqtype, completion: {(response) in
           self.hideLoading()

            self.paymentDown = DropDown()
            self.paymentDown?.anchorView = self.cvPaymentType
            var arr = [String]()
            self.paymentTypes.removeAll()
            self.paymentTypes.append(contentsOf: response.data ?? [DamanServiceType]())
            for item in self.paymentTypes {
                
                if self.isArabic(){
                    arr.append(item.SERVICE_DESC ?? "")
                    

                }else{
                    arr.append(item.SERVICE_ENG_DESC ?? "")

                }
            }
          

            
            self.paymentDown?.dataSource = arr
            self.paymentDown?.show()

            self.paymentDown?.selectionAction = { [unowned self] (index: Int, item: String) in
                self.selectedPaymentType = self.paymentTypes[index]
                var SERVICE_Name = ""
                if self.isArabic(){
                    SERVICE_Name = self.selectedPaymentType?.SERVICE_DESC ?? ""
                }else{
                    SERVICE_Name = self.selectedPaymentType?.SERVICE_ENG_DESC ?? ""
                }
//                self.paymentField.text = self.selectedPaymentType?.SERVICE_ENG_DESC ?? ""
                self.paymentField.text = SERVICE_Name

                self.payTypes = String(self.selectedPaymentType?.SERVICE ?? 0)
                self.cvPaymentType.backgroundColor = UIColor.card_color
                self.validateFields()
            }
            
            
        })
        
        
        

        
    }
    
    
    
    
    @IBAction func individualsAction(_ sender: Any) {
        self.individualsUI()
        self.numReqtype = "2"
    }
    

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func homeAction(_ sender: Any) {
        goHomeWithConfirmation()
    }
    
    @IBAction func submitAction(_ sender: Any) {
        
        if (self.validate()) {

            self.fillData()
            self.showLoading()
            

 
            
//            self.getApiManager().getRCVPaymentDetails2(token: self.getAccessToken(), receiveModel: App.shared.receiveMoney,serviceProviderId:self.idMonyGram,requestRemittanceNumber:self.ReferenceNumberField.text ?? "",damanPAYNO:self.CSSINumberField.text ?? "",damanServiceType:self.payTypes,payoutMethodId:"10") { (response) in
//                self.hideLoading()
//                if (response.success ?? false) {
//
//                    App.shared.receiveMoney?.rcvGuid = response.data?.rcvGUID ?? ""
//
//                    print("rcvGuid\(response.data?.rcvGUID ?? "")")
//
//
//                    self.showConfirmationAlert(includeOtp: response.data?.includeOTP ?? false, info : response.data?.confirmInfo ?? [ConfirmInfo]())
//                }else {
//                    self.handleError(code : response.code ?? "", message : response.message ?? ["Somethig Wrong"])
////                    self.cvContinue.isHidden = false
////                    self.btnContinue.isEnabled = true
//
//
//                }
//            }
            
            
            
            
            self.getApiManager().getRCVPaymentDetails2(token: self.getAccessToken(), receiveModel: App.shared.receiveMoney) { (response) in
                self.hideLoading()
                if (response.success ?? false) {
                    
                    App.shared.receiveMoney?.rcvGuid = response.data?.rcvGUID ?? ""
                    
                    print("rcvGuid\(response.data?.rcvGUID ?? "")")
                    
                    
                    self.showConfirmationAlert(includeOtp: response.data?.includeOTP ?? false, info : response.data?.confirmInfo ?? [ConfirmInfo]())
                }else {
                    self.handleError(code : response.code ?? "", message : response.message ?? ["Somethig Wrong"])
//                    self.cvContinue.isHidden = false
//                    self.btnContinue.isEnabled = true


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
            
            self.receiveMoneyApi()

            
        }, cancelHandler: nil)
        
    }
    
    private func receiveMoneyApi() {
        self.showLoading()
        
        
        print("REs \n\(App.shared.receiveMoney)")
        getApiManager().submitRCVRequest(token: getAccessToken(), receiveModel: App.shared.receiveMoney) { (response) in
            self.hideLoading()
            if (response.success ?? false) {
                self.openCompletedScreen(transaction: response.data ?? [RCVSentDatum]())
            }else {
                self.handleError(code : response.code ?? "", message : response.message)
            }
        }
    }

    
    func fillData() {
        
        
        if (App.shared.receiveMoney == nil) {
            App.shared.receiveMoney = ReceiveMoneyModel()
        }
        
        
        if self.idMonyGram == ""{
            self.loadServices()

        }

        
        
        App.shared.receiveMoney?.serviceProviderId = self.idMonyGram
        App.shared.receiveMoney?.damanServiceType = self.payTypes
        App.shared.receiveMoney?.damanPAYNO = self.CSSINumberField.text ?? ""
        App.shared.receiveMoney?.requestRemittanceNumber = self.ReferenceNumberField.text ?? ""
        App.shared.receiveMoney?.payoutMethodId = "10"
        
        
        
        
        print("fillData")
        print("idMonyGram:\(self.idMonyGram) \n payTypes:\(payTypes) \n CSSINumberField\(CSSINumberField.text ?? "") \nReferenceNumberField: \(ReferenceNumberField.text ?? "")")
        
    }
    
    
    
    private func openCompletedScreen(transaction : [RCVSentDatum]) {
        
        let vc : step3_RCVSuccessVC = self.getStoryBoard(name: Constants.STORYBOARDS.receive_money).instantiateViewController(withIdentifier: "step3_RCVSuccessVC") as! step3_RCVSuccessVC
        vc.details = transaction
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
        
        print("openCompletedScreen")
    }
    
    
    @IBAction func facilitiesAction(_ sender: Any) {
        self.facilitiesUI()
        self.numReqtype = "1"
        
    }
    
    @IBAction func ReferenceNumberAction(_ sender: Any) {
        self.validateFields()

    }
    
    @IBAction func cSSINumberAction(_ sender: Any) {
        self.validateFields()

    }
    
    
    func validate() -> Bool {


        if (self.paymentField.text?.count ?? 0 == 0) {
            self.showBanner(title: "alert".localized, message: "daman_PaymentType".localized, style: UIColor.INFO)
            self.cvPaymentType.backgroundColor = UIColor.app_red
            return false
        }
        
        if (self.CSSINumberField.text?.count ?? 0 == 0) {
            self.showBanner(title: "alert".localized, message: "daman_CSSINumber".localized, style: UIColor.INFO)
            self.cvCSSINumber.backgroundColor = UIColor.app_red
            return false
        }
        
        
        
        if (self.ReferenceNumberField.text?.count ?? 0 == 0) {
            self.showBanner(title: "alert".localized, message: "daman_ReferenceNumber".localized, style: UIColor.INFO)
            self.cvReferenceNumber.backgroundColor = UIColor.app_red
            return false
        }
        
        if (self.numReqtype.count ?? 0 == 0) {
            self.showBanner(title: "alert".localized, message: "daman_radioBuuon".localized, style: UIColor.INFO)
     
            return false
        }
        
    
        return true
    }
    
    
    func individualsUI() {
        self.individualsImage.image = UIImage(named: "ic_language_selected")
        self.facilitiesImage.image = UIImage(named: "ic_language_unselected")


    }
    
    func facilitiesUI() {
        self.facilitiesImage.image = UIImage(named: "ic_language_selected")
        self.individualsImage.image = UIImage(named: "ic_language_unselected")


    }
    
    
    func validateFields() {

        
        if (self.paymentField.text?.count ?? 0 == 0) {
            self.enableNext(flag: false)
            return
        }
 
        
        if (self.CSSINumberField.text?.count ?? 0 == 0) {
            self.enableNext(flag: false)
            return
        }
        
        
        if (self.ReferenceNumberField.text?.count ?? 0 == 0) {
            self.enableNext(flag: false)
            return
        }
        
        if (self.numReqtype.count ?? 0 == 0) {
            self.enableNext(flag: false)
            return
        }
        
        

        self.enableNext(flag: true)
    }
    
    func enableNext(flag : Bool) {
        if (flag) {
            self.cvSubmit.backgroundColor = UIColor.enabled
            self.submitButton.setTitleColor(UIColor.enabled_text, for: .normal)
            submitButton.isEnabled = true
        }else {
            self.cvSubmit.backgroundColor = UIColor.disabled
            self.submitButton.setTitleColor(UIColor.disabled_text, for: .normal)
            if (Constants.SHOULD_DISABLE_BUTTON) {
                submitButton.isEnabled = false
            }
        }
    }
    
}



extension DamanVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
         if (textField == self.ReferenceNumberField) {
            self.cvReferenceNumber.backgroundColor = UIColor.card_focused_color
        }
        
        
         if (textField == self.CSSINumberField) {
            self.cvCSSINumber.backgroundColor = UIColor.card_focused_color
        }

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == self.ReferenceNumberField) {
            self.cvReferenceNumber.backgroundColor = UIColor.card_color
        }else if (textField == self.CSSINumberField) {
            self.cvCSSINumber.backgroundColor = UIColor.card_color
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == self.ReferenceNumberField) {
            self.cvReferenceNumber.becomeFirstResponder()
        }else if (textField == self.CSSINumberField) {
            self.cvCSSINumber.resignFirstResponder()
        }
        return false
    }
    
    
    
}



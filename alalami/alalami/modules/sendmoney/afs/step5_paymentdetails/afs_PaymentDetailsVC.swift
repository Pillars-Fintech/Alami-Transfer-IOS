//
//  afs_PaymentDetailsVC.swift
//  alalami
//
//  Created by Zaid Khaled on 9/13/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit

class afs_PaymentDetailsVC: BaseVC {
    
    @IBOutlet weak var btnBack: UIButton!
    
    //screenshot
    @IBOutlet weak var btnScreenshot: UIButton!
    
    
    @IBOutlet weak var lblSenderName: MyUILabel!
    @IBOutlet weak var lblReceiverName: MyUILabel!
    @IBOutlet weak var lblAmount: MyUILabel!
    @IBOutlet weak var lblFees: MyUILabel!
    @IBOutlet weak var lblPayInMethod: MyUILabel!
    @IBOutlet weak var lblDestinationCountry: MyUILabel!
    @IBOutlet weak var lblDueAmount: MyUILabel!
    
    @IBOutlet weak var ivTerms: UIImageView!
    var acceptTerms = false
    
    //action
    @IBOutlet weak var cvContinue: CardView!
    @IBOutlet weak var btnContinue: MyUIButton!
    
    var paymentDetails : AFSPaymentDetailsClass?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
        }
        
        self.loadPaymentDetails()
        
        self.enableNext(flag: false)
        
    }
    
    func loadPaymentDetails() {
        self.showLoading()
        self.getApiManager().getAFSPaymentDetails(token: self.getAccessToken(), sendModel: App.shared.sendMoneyAFS) { (response) in
            self.hideLoading()
            self.paymentDetails = response.data
            self.initUI()
        }
    }
    
    func initUI() {
        self.loadStaticUI()
        self.lblSenderName.text = self.paymentDetails?.senderName ?? "---"
        self.lblReceiverName.text = self.paymentDetails?.receiverName ?? "---"
        self.lblAmount.text = self.paymentDetails?.sendAmount ?? "0.0"
        self.lblFees.text = self.paymentDetails?.fee ?? "0.0"
        self.lblPayInMethod.text = self.paymentDetails?.payMethod ?? "---"
        self.lblDueAmount.text = self.paymentDetails?.totalDueAmount ?? "0.0"
        self.lblDestinationCountry.text = self.paymentDetails?.destinationBranch ?? "---"
    }
    
    func loadStaticUI() {
        let accountInfo = App.shared.accountInfo
        self.lblSenderName.text = "\(accountInfo?.firstNameEn ?? "") \(accountInfo?.lastNameEn ?? "")"
        self.lblReceiverName.text = "\(App.shared.sendMoneyAFS?.selectedBeneficiary?.firstNameEn ?? "") \(App.shared.sendMoneyAFS?.selectedBeneficiary?.lastNameEn ?? "")"
        self.lblPayInMethod.text = App.shared.sendMoneyAFS?.payInOption?.name ?? ""
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func takeScreenshotAction(_ sender: Any) {
        let _ = self.takeScreenshot()
    }
    
    
    @IBAction func termsAction(_ sender: Any) {
        if (self.acceptTerms) {
            self.ivTerms.image = UIImage(named: "ic_terms_unchecked")
            self.acceptTerms = false
            self.enableNext(flag: false)
        }else {
            self.ivTerms.image = UIImage(named: "ic_terms_checked")
            self.acceptTerms = true
        }
        self.enableNext(flag: self.acceptTerms)
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
    
    func fillData() {
        App.shared.sendMoneyAFS?.afsGuid = self.paymentDetails?.afsGUID ?? ""
    }
    
    private func showAgreeTextAlert() {
        var text = ""
        for textItem in App.shared.config?.remittancesSettings?.confirmAlertPionies ?? [ConfirmAlertPiony]() {
            if (isArabic()) {
                text = "\(text)\n\n\(textItem.alertAr ?? "")"
            }else {
                text = "\(text)\n\n\(textItem.alertEn ?? "")"
            }
        }
        
        self.showAlert(title: "alert".localized, message: text, actionTitle: "confirm".localized, cancelTitle: "cancel".localized, actionHandler: {
            
            //confirm api
            self.fillData()
            self.showLoading()
            self.getApiManager().sendMoneyAFS(token: self.getAccessToken(), sendModel: App.shared.sendMoneyAFS) { (response) in
                self.hideLoading()
                if (response.success ?? false) {
                    self.openCompletedScreen(transaction: response.data ?? [AfsSentDatum]())
                }else {
                    self.handleError(code : response.code ?? "", message : response.message)
                }
            }
            
        })
    }
    
    @IBAction func continueAction(_ sender: Any) {
        
        if (self.acceptTerms) {
            if (paymentDetails?.includeOTP ?? false) {
                //show verrify OTP to confirm remittance
                startOTPVerificationProcess()
            }else {
                //no OTP verification needed
                showAgreeTextAlert()
            }
        }else {
            self.showBanner(title: "alert".localized, message: "you_must_agree_terms".localized, style: UIColor.INFO)

        }
    }
    
    private func startOTPVerificationProcess() {
        let vc : afs_VerifyPaymentVC = self.getStoryBoard(name: Constants.STORYBOARDS.afs).instantiateViewController(withIdentifier: "afs_VerifyPaymentVC") as! afs_VerifyPaymentVC
        vc.delegate = self
        vc.afsGuid = self.paymentDetails?.afsGUID ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func openCompletedScreen(transaction : [AfsSentDatum]) {
        let vc : afs_CompletedVC = self.getStoryBoard(name: Constants.STORYBOARDS.afs).instantiateViewController(withIdentifier: "afs_CompletedVC") as! afs_CompletedVC
        vc.details = transaction
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func goToHome(_ sender: Any) {
        goHomeWithConfirmation()
    }
    
}


extension afs_PaymentDetailsVC : VerifyAFSProtocol {
    func onVerify(code: String) {
        App.shared.sendMoneyAFS?.otpCode = code
        self.showAgreeTextAlert()
    }
}

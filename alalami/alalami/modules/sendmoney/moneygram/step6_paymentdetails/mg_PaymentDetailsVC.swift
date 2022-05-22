//
//  mg_PaymentDetailsVC.swift
//  alalami
//
//  Created by Zaid Khaled on 9/9/20.
//  Copyright © 2020 technzone. All rights reserved.
//

//test
// tesrkkk

//start

import UIKit

class mg_PaymentDetailsVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var lChek: MyUILabel!
    
    
    @IBOutlet weak var paymentDetails: MyUILabel!
    @IBOutlet weak var btnBack: UIButton!
    
    
    
    //screenshot
    @IBOutlet weak var btnScreenshot: UIButton!
    
    //container view
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    
    
    //table details
    @IBOutlet weak var tableDetails: UITableView!
    var items = [MGResponseList]()
    
    var includeOtp : Bool = false
    var PayMethodId:Int = 0

    
    @IBOutlet weak var ivTerms: UIImageView!
    var acceptTerms = false
    
    //action
    @IBOutlet weak var cvContinue: CardView!
    @IBOutlet weak var btnContinue: MyUIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lChek.textAlignment = .natural
        paymentDetails.textAlignment = .natural


        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
        }
        
        if (isArabic()) {
            lChek.textAlignment = .right
            paymentDetails.textAlignment = .right
        }else{
            lChek.textAlignment = .left
            paymentDetails.textAlignment = .left

        }
        
        
        
        
        tableDetails.delegate = self
        tableDetails.dataSource = self
        
        self.loadPaymentDetails()
        
        self.enableNext(flag: false)
        
        paymentDetails.text = "transfer_Details".localized
        
    }
    
    func loadPaymentDetails() {
        self.showLoading()
        self.getApiManager().getMGPaymentDetails(token: self.getAccessToken(), sendModel: App.shared.sendMoneyMG) { (response) in
            self.hideLoading()
            self.items.removeAll()
            self.items.append(contentsOf: response.data?.confirmInfo ?? [MGResponseList]())
            self.includeOtp = response.data?.includeOTP ?? false
            self.PayMethodId =  response.data?.PayMethodId ?? 0

            self.tableDetails.reloadData()
            self.validateViewHeight()
        }
    }
    
    private func validateViewHeight() {
        let itemsHeight = items.count * 40
        let staticHeight = 230
        let totalHeight  = itemsHeight + staticHeight
        containerViewHeight.constant = CGFloat(totalHeight)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DetailsInnerCell = self.tableDetails.dequeueReusableCell(withIdentifier: "DetailsInnerCell") as! DetailsInnerCell
        
        let item = self.items[indexPath.row]
        
        cell.lblTitle.text = item.caption ?? "".localized
        cell.lblValue.text = item.value ?? "".localized
        
        
//        if(isArabic()){
//            cell.lblTitle.textAlignment = .right
//            cell.lblValue.textAlignment = .left
//
//        }else{
//            cell.lblTitle.textAlignment = .left
//            cell.lblValue.textAlignment = .right
//        }
        
        if let iconUrl = URL(string: "\(Constants.IMAGE_URL)\(item.icon ?? "")") {
            cell.ivLogo.isHidden = false
            cell.ivLogo.kf.setImage(with: iconUrl)
        }else {
            cell.ivLogo.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
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
        
    }
    
//    private func showAgreeTextAlert() {
//        var text = ""
//        for textItem in App.shared.config?.remittancesSettings?.confirmAlertPionies ?? [ConfirmAlertPiony]() {
//            if (isArabic()) {
//                text = "\(text)\n\n\(textItem.alertAr ?? "")"
//            }else {
//                text = "\(text)\n\n\(textItem.alertEn ?? "")"
//            }
//        }
//
//        self.showAlert(title: "alert".localized, message: text, actionTitle: "confirm".localized, cancelTitle: "cancel".localized, actionHandler: {
//
//            self.confirmApi()
//
//        })
//
//
//
//    }
    
    
    private func showAgreeTextAlert() {
        var text = ""
        for textItem in App.shared.config?.remittancesSettings?.confirmAlertPionies ?? [ConfirmAlertPiony]() {
            if (isArabic()) {
                text = "\(text)\n\n\(textItem.alertAr ?? "")"
            }else {
                text = "\(text)\n\n\(textItem.alertEn ?? "")"
            }
        }
        
        self.showAlertDaynamic(title: "alert".localized, message: text, actionTitle: "confirm".localized, cancelTitle: "cancel".localized, actionHandler: {
            
            self.confirmApi()
            
        }, cancelHandler: (() -> Void)?{
            print("cancel")
            

            
            self.presentNav(name: "TabBarNav", sb: Constants.STORYBOARDS.main)

   
        })
        
        
    }
    
    private func startOtpVerificationProcess() {
        let vc : MG_VerifyPaymentVC = self.getStoryBoard(name: Constants.STORYBOARDS.money_gram).instantiateViewController(withIdentifier: "MG_VerifyPaymentVC") as! MG_VerifyPaymentVC
        vc.delegate = self
        vc.mgGuid = App.shared.sendMoneyMG?.selectedServiceOption?.mgGUID ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func confirmApi() {
        self.fillData()
        self.showLoading()
        self.getApiManager().sendMoneyMG(token: self.getAccessToken(), sendModel: App.shared.sendMoneyMG) { (response) in
            self.hideLoading()
            if (response.success ?? false) {
                self.openCompletedScreen(details: response.data ?? [MGSentDatum]())
            }else {
                self.handleError(code : response.code ?? "", message : response.message)
                
//                if(response.message != nil){
//
//                    self.handleError(code : response.code ?? "", message : ["somethig wrong"])
//
//
//                }else{
//                    self.handleError(code : response.code ?? "", message : response.message)
//
//                    print("error")
//                }
        
            }
        }
    }
    
    
    private func confirmWith() {
        self.fillData()
        self.showLoading()
        self.getApiManager().sendMoneyMG2(token: self.getAccessToken(), sendModel: App.shared.sendMoneyMG) { [self] (response) in
            self.hideLoading()
            if (response.success ?? false) {
                
                showAgreeTextAlert()
                
                
            }else {
                self.handleError(code : response.code ?? "", message : response.message)
                
                self.showBanner(title: "alert".localized, message: "\(response.message)".localized, style: UIColor.INFO)

            }
        }
    }
    
    
    private func confirmNI() {
        self.fillData()
        self.showLoading()
        self.getApiManager().sendMoneyMG2(token: self.getAccessToken(), sendModel: App.shared.sendMoneyMG) { [self] (response) in
            self.hideLoading()
            if (response.success ?? false) {
                
                var x = response.data?[0]
                var link = x?.value
                
                print("confirm -------------------------")
                print("\(link)")

                
                let vc : NIScreenVC = self.getStoryBoard(name: Constants.STORYBOARDS.money_gram).instantiateViewController(withIdentifier: "NIScreenVC") as! NIScreenVC
                    vc.links = link
//                    vc.details = response.data ?? [MGSentDatum]()

                self.navigationController?.pushViewController(vc, animated: true)
                
                
            }else {
                self.handleError(code : response.code ?? "", message : response.message)
                
                self.showBanner(title: "alert".localized, message: "\(response.message)".localized, style: UIColor.INFO)

            }
        }
    }
    
    private func confirmWithOut() {
        self.fillData()
        self.showLoading()
        self.getApiManager().sendMoneyMG2(token: self.getAccessToken(), sendModel: App.shared.sendMoneyMG) { [self] (response) in
            self.hideLoading()
            if (response.success ?? false) {
                
                
                startOtpVerificationProcess()

                
            }else {
                self.handleError(code : response.code ?? "", message : response.message)
                
                self.showBanner(title: "alert".localized, message: "\(response.message)".localized, style: UIColor.INFO)

                
                
            }
        }
    }
    
    
    
    
    @IBAction func goBackHome(_ sender: Any) {
        goHomeWithConfirmation()
    }
    
    @IBAction func continueAction(_ sender: Any) {
        
        print("PayMethodId\(PayMethodId)")
        
        if (self.acceptTerms) {
            
            
            if (self.includeOtp) {
                //verify OTP to continue
//                startOtpVerificationProcess()
                confirmWithOut()
                
                
            }else {
                //no need for verification, confirm api
//                showAgreeTextAlert()
                
                if PayMethodId == 7{
                    confirmNI()
                }else{
                    confirmWith()

                }
            }
        }else {
            self.showBanner(title: "alert".localized, message: "you_must_agree_terms".localized, style: UIColor.INFO)
        }
        
        
        
        
    }
    
    
    func openCompletedScreen(details : [MGSentDatum]) {
        let vc : mg_CompletedVC = self.getStoryBoard(name: Constants.STORYBOARDS.money_gram).instantiateViewController(withIdentifier: "mg_CompletedVC") as! mg_CompletedVC
        vc.details = details
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}


extension mg_PaymentDetailsVC : VerifyMGProtocol {
    func onVerify(code: String) {
        App.shared.sendMoneyMG?.otpCode = code
        self.showAgreeTextAlert()
    }
}

//
//  VerificationVC.swift
//  alalami
//
//  Created by Zaid Khaled on 9/2/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit
import CBPinEntryView

class VerificationVC: BaseVC, CBPinEntryViewDelegate {
    
    @IBOutlet weak var pinView: CBPinEntryView!
    
    //confirm
    @IBOutlet weak var cvConfirm: CardView!
    @IBOutlet weak var btnConfirm: MyUIButton!
    
    @IBOutlet weak var btnResend: MyUIButton!
    @IBOutlet weak var lblCounter: MyUILabel!
    
    var access_token: String?
    var countDown:Int = 59
    var timer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pinView.delegate = self
        
        self.pinView.subviews.forEach { $0.semanticContentAttribute = .forceLeftToRight }
        
        self.sendVerificationCode()
    }
    
    func sendVerificationCode() {
        self.showLoading()
        self.getApiManager().sendVerificationCode(token: self.access_token ?? "") { (response) in
            self.hideLoading()

            self.startTimer()

            if response.success == false {
                self.handleError(code: response.code, message: response.message ?? ["Something Wrong"])

            }else{
                self.enableConfirm(flag: false)
            }
            
//                            self.enableConfirm(flag: false)
//                            self.startTimer()
        }
    }
    
    func enableConfirm(flag : Bool) {
        if (flag) {
            self.cvConfirm.backgroundColor = UIColor.enabled
            self.btnConfirm.setTitleColor(UIColor.enabled_text, for: .normal)
             btnConfirm.isEnabled = true
        }else {
            self.cvConfirm.backgroundColor = UIColor.disabled
            self.btnConfirm.setTitleColor(UIColor.disabled_text, for: .normal)
            if (Constants.SHOULD_DISABLE_BUTTON) {
                btnConfirm.isEnabled = false
            }
        }
    }
    
    func entryChanged(_ completed: Bool) {
        if (completed) {
            self.pinView.resignFirstResponder()
            self.enableConfirm(flag: true)
        }else {
            self.enableConfirm(flag: false)
        }
    }
    func entryCompleted(with entry: String?) {
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        stopTimer()
    }
    
    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        countDown = 59
        self.lblCounter.text = "(59)"
    }
    
    @objc func updateTimer() {
        if(countDown > 0) {
            countDown = countDown - 1
            self.lblCounter.text = "(\(countDown))"
            self.enableResend(enable: false)
        }else {
            self.lblCounter.text = ""
            self.enableResend(enable: true)
        }
    }
    
    func enableResend(enable : Bool) {
        if (enable == true) {
            self.btnResend.setTitleColor(UIColor.black, for: .normal)
            self.btnResend.isEnabled = true
        }else {
            self.btnResend.setTitleColor(UIColor.text_disabled, for: .normal)
            self.btnResend.isEnabled = false
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.showAlert(title: "alert".localized, message: "confirm_cancel_vertification".localized, actionTitle: "yes".localized, cancelTitle: "no".localized, actionHandler: {
            //go back
            self.dismiss(animated: true, completion: nil)
        }) {
            //no
        }
    }
    
    @IBAction func resendAction(_ sender: Any) {
        self.enableResend(enable: false)
        self.startTimer()
        self.resendCode()
    }
    
    
    @IBAction func submitAction(_ sender: Any) {
        self.verify()
    }
    
    //methods
    func resendCode() {
        self.stopTimer()
        self.sendVerificationCode()
    }
    
    func verify() {
        let pinCode = self.pinView.getPinAsString().replacedArabicDigitsWithEnglish.trim()
        if (pinCode.count == 6) {
            //verify
            self.showLoading()
            self.getApiManager().verifyCode(token: self.access_token ?? "", code: pinCode) { (response) in
                self.hideLoading()
                if (response.code ?? "" == "0" || response.code ?? "" == "200") {
                    self.openSuccessScreen()
                }else {
                    self.showBanner(title: "alert".localized, message: response.message, style: UIColor.INFO)
                }
            }
        }else {
            self.pinView.setError(isError: true)
            self.showBanner(title: "alert".localized, message: "enter_pin_digits".localized, style: UIColor.INFO)
        }
    }
    
    
    func openSuccessScreen() {
        self.presentVC(name: "SuccessVC", sb: Constants.STORYBOARDS.authentication)
    }
    
    
}

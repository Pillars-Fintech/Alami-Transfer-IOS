//
//  MG_VerifyPaymentVC.swift
//  alalami
//
//  Created by Zaid Khaled on 12/5/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit

protocol VerifyMGProtocol {
    func onVerify(code : String)
}

class MG_VerifyPaymentVC: BaseVC {
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var btnResend: MyUIButton!
    @IBOutlet weak var lblCounter: MyUILabel!
    
    //pin code
    @IBOutlet weak var fieldPin: MyUITextField!
    @IBOutlet weak var cvPin: CardView!
    
    //next
    @IBOutlet weak var cvChange: CardView!
    @IBOutlet weak var btnChange: MyUIButton!
    
    var delegate : VerifyMGProtocol?
    
    var countDown:Int = 59
    var timer:Timer?
    
    var mgGuid : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if (isArabic()) {
//            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
//        }
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        
        self.fieldPin.delegate = self
        
        self.enableNext(flag: false)
        self.startTimer()
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
    
    func enableNext(flag : Bool) {
        if (flag) {
            self.cvChange.backgroundColor = UIColor.enabled
            self.btnChange.setTitleColor(UIColor.enabled_text, for: .normal)
            btnChange.isEnabled = true
        }else {
            self.cvChange.backgroundColor = UIColor.disabled
            self.btnChange.setTitleColor(UIColor.disabled_text, for: .normal)
            if (Constants.SHOULD_DISABLE_BUTTON) {
                btnChange.isEnabled = false
            }
        }
    }
    
    
    @IBAction func submitPinCodeAction(_ sender: Any) {
        if (self.validate()) {
            self.delegate?.onVerify(code: (self.fieldPin.text ?? "").trim().replacedArabicDigitsWithEnglish)
        }
    }
    
    //methods
    func resendCode() {
        self.stopTimer()
        self.sendVerificationCode()
    }
    
    func sendVerificationCode() {
        self.showLoading()
        self.getApiManager().resendMGOtpCode(token: getAccessToken(), mgGuid: self.mgGuid ?? "") { (response) in
            self.hideLoading()
            self.fieldPin.text = ""
            self.enableNext(flag: false)
            self.startTimer()
        }
    }
    
    
    func validate() -> Bool {
        let pinCode = (self.fieldPin.text ?? "").trim().replacedArabicDigitsWithEnglish
        
        if (pinCode.count == 0) {
            self.cvPin.backgroundColor = UIColor.app_red
            self.showBanner(title: "alert".localized, message: "enter_pin_digits".localized, style: UIColor.INFO)
            return false
        }
        
        return true
    }
    
    func validateFields() {
        let pin = (self.fieldPin.text ?? "").trim()
        
        let isValidPin = pin.count > 0
        if (isValidPin) {
            self.enableNext(flag: true)
        }else {
            self.enableNext(flag: false)
        }
        
    }
    
    
    @IBAction func pinTextChanged(_ sender: Any) {
        self.validateFields()
    }
    
    @IBAction func resendCodeAction(_ sender: Any) {
        self.enableResend(enable: false)
        self.startTimer()
        self.resendCode()
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        self.showAlertDaynamic(title: "alert".localized, message: "confirm_go_home".localized, actionTitle: "ok".localized, cancelTitle: "cancel".localized, actionHandler: {
            self.goHome()
        }, cancelHandler: {
            
        })
        
        
        
        
        
//        self.navigationController?.popViewController(animated: true)
    }
    
}


extension MG_VerifyPaymentVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.fieldPin) {
            self.cvPin.backgroundColor = UIColor.card_focused_color
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == self.fieldPin) {
            self.cvPin.backgroundColor = UIColor.card_color
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == self.fieldPin) {
            self.fieldPin.resignFirstResponder()
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.fieldPin {
            let maxLength = 40
            let currentString: NSString = textField.text as NSString? ?? ""
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            
            return newString.length <= maxLength
        }
        
        return true
    }
    
}

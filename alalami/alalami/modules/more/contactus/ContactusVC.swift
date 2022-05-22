//
//  ContactusVC.swift
//  alalami
//
//  Created by Zaid Khaled on 10/4/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit
import MultilineTextField
import JJFloatingActionButton

class ContactusVC: BaseVC {
    
    @IBOutlet weak var btnBack: UIButton!
    
    //name
    @IBOutlet weak var cvName: CardView!
    @IBOutlet weak var fieldName: MyUITextField!
    
    //phone
    @IBOutlet weak var cvPhone: CardView!
    @IBOutlet weak var fieldPhone: MyUITextField!
    
    //email
    @IBOutlet weak var cvEmail: CardView!
    @IBOutlet weak var fieldEmail: MyUITextField!
    
    //message
    @IBOutlet weak var cvMessage: CardView!
    @IBOutlet weak var fieldMessage: MultilineTextField!
    
    //action
    @IBOutlet weak var cvContinue: CardView!
    @IBOutlet weak var btnContinue: MyUIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fieldName.delegate = self
        fieldPhone.delegate = self
        fieldEmail.delegate = self
        
        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
        }
        
        self.fieldMessage.placeholder = "enter_message_here".localized
        // Do any additional setup after loading the view.
        if (self.isArabic()) {
            self.fieldMessage.textAlignment = .right
            self.fieldMessage.placeholderAlignment = .right
        }else {
            self.fieldMessage.textAlignment = .left
            self.fieldMessage.placeholderAlignment = .left
        }
        
        self.fieldMessage.delegate = self
        
        self.filluserData()
        
        setupFloating()
        
    }
    
    func setupFloating() {
        let actionButton = JJFloatingActionButton()
        
        let item = actionButton.addItem()
        item.titleLabel.text = "call_support".localized
        item.titleLabel.font = UIFont(name: self.getFontName(type: Constants.FONT_TYPE.regular), size: 13)
        item.imageView.image = UIImage(named: "ic_about1")
        item.buttonColor = UIColor.app_green
        item.buttonImageColor = .white
        item.action = { item in
            //call support
            self.callNumber(phone: App.shared.config?.company?.phone ?? "")
        }
        
        let item1 = actionButton.addItem()
        item1.titleLabel.text = "website".localized
        item1.titleLabel.font = UIFont(name: self.getFontName(type: Constants.FONT_TYPE.regular), size: 13)
        item1.imageView.image = UIImage(named: "ic_about2")
        item1.buttonColor = UIColor.highlight_blue
        item1.buttonImageColor = .white
        item1.action = { item in
            //website
            self.openWebsite()
        }
        
        let item2 = actionButton.addItem()
        item2.titleLabel.text = "whatsapp".localized
        item2.titleLabel.font = UIFont(name: self.getFontName(type: Constants.FONT_TYPE.regular), size: 13)
        item2.imageView.image = UIImage(named: "ic_about3")
        item2.buttonColor = UIColor.whatsapp_color
        item2.buttonImageColor = .white
        item2.action = { item in
            //whatsapp
            self.openWhatsappChat()
        }
        
        let item3 = actionButton.addItem()
        item3.titleLabel.text = "twitter".localized
        item3.titleLabel.font = UIFont(name: self.getFontName(type: Constants.FONT_TYPE.regular), size: 13)
        item3.imageView.image = UIImage(named: "ic_about4")
        item3.buttonColor = UIColor.twitter_color
        item3.buttonImageColor = .white
        item3.action = { item in
            let twitterUrl = App.shared.config?.company?.twitter ?? ""
            if (twitterUrl.contains(find: "http")) {
                self.openUrl(str: twitterUrl)
            }else {
                //twitter
                self.openTwitterProfile()
            }
        }
        
        let item4 = actionButton.addItem()
        item4.titleLabel.text = "instagram".localized
        item4.titleLabel.font = UIFont(name: self.getFontName(type: Constants.FONT_TYPE.regular), size: 13)
        item4.imageView.image = UIImage(named: "ic_about5")
        item4.buttonColor = UIColor.instagram_color
        item4.buttonImageColor = .white
        item4.action = { item in
            let instagramUrl = App.shared.config?.company?.instagram ?? ""
            if (instagramUrl.contains(find: "http")) {
                self.openUrl(str: instagramUrl)
            }else {
                //instagram
                self.openInstagramAccount()
            }
        }
        
        let item5 = actionButton.addItem()
        item5.titleLabel.text = "facebook".localized
        item5.titleLabel.font = UIFont(name: self.getFontName(type: Constants.FONT_TYPE.regular), size: 13)
        item5.imageView.image = UIImage(named: "ic_about6")
        item5.buttonColor = UIColor.facebook_color
        item5.buttonImageColor = .white
        item5.action = { item in
            let facebookUrl = App.shared.config?.company?.facebook ?? ""
            if (facebookUrl.contains(find: "http")) {
                self.openUrl(str: facebookUrl)
            }else {
                //facebook
                self.openFacebookPage()
            }
        }
        
        actionButton.buttonColor = UIColor.app_red
        actionButton.shadowColor = UIColor.app_red
        actionButton.buttonImage = UIImage(named: "ic_fab_dots")
        
        view.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 11.0, *) {
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -85).isActive = true
        } else {
            // Fallback on earlier versions
        }
    }
    
    func openFacebookPage() {
        if (App.shared.config?.company?.facebook?.count ?? 0 > 0) {
            if let url = URL(string: "fb://profile/\(App.shared.config?.company?.facebook ?? "")") {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:],completionHandler: { (success) in
                        print("Open fb://profile/\(App.shared.config?.company?.facebook ?? ""): \(success)")
                    })
                } else {
                    let success = UIApplication.shared.openURL(url)
                    print("Open fb://profile/\(App.shared.config?.company?.facebook ?? ""): \(success)")
                }
            }
        }else {
            self.showBanner(title: "alert".localized, message: "not_available".localized, style: UIColor.INFO)
        }
    }
    
    func openTwitterProfile() {
        if (App.shared.config?.company?.twitter?.count ?? 0 > 0) {
            let twitterURL = NSURL(string: App.shared.config?.company?.twitter ?? "")!
            if UIApplication.shared.canOpenURL(twitterURL as URL) {
                UIApplication.shared.open(twitterURL as URL)
            } else {
                UIApplication.shared.open(NSURL(string: App.shared.config?.company?.twitter ?? "")! as URL)
            }
        }else {
            self.showBanner(title: "alert".localized, message: "not_available".localized, style: UIColor.INFO)
        }
    }
    
    func openInstagramAccount() {
        if (App.shared.config?.company?.instagram?.count ?? 0 > 0) {
            let Username =  App.shared.config?.company?.instagram ?? ""// Your Instagram Username here
            let appURL = URL(string: "instagram://user?username=\(Username)")!
            let application = UIApplication.shared
            
            if application.canOpenURL(appURL) {
                application.open(appURL)
            } else {
                // if Instagram app is not installed, open URL inside Safari
                let webURL = URL(string: "https://instagram.com/\(Username)")!
                application.open(webURL)
            }
        }else {
            self.showBanner(title: "alert".localized, message: "not_available".localized, style: UIColor.INFO)
        }
        
    }
    
    func openWebsite() {
        if (App.shared.config?.company?.website?.count ?? 0 > 0) {
            let application = UIApplication.shared
            let webURL = URL(string: App.shared.config?.company?.website ?? "")!
            application.open(webURL)
        }else {
            self.showBanner(title: "alert".localized, message: "not_available".localized, style: UIColor.INFO)
        }
    }
    
    func openWhatsappChat() {
        if (App.shared.config?.company?.whatsapp?.count ?? 0 > 0) {
            if let url = URL(string: "https://api.whatsapp.com/send?phone=\(App.shared.config?.company?.whatsapp ?? "")"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }else {
            self.showBanner(title: "alert".localized, message: "not_available".localized, style: UIColor.INFO)
        }
    }
    
    @IBAction func fieldTextChanged(_ sender: Any) {
        self.validateFields()
    }
    
    
    func validate() -> Bool {
        if (self.fieldName.text?.count ?? 0 == 0) {
            self.showBanner(title: "alert".localized, message: "enter_your_name".localized, style: UIColor.INFO)
            self.cvName.backgroundColor = UIColor.app_red
            return false
        }
        if (!isPureText(text: fieldName.text ?? "")) {
            self.showBanner(title: "alert".localized, message: "text_regex_name".localized, style: UIColor.INFO)
            self.cvName.backgroundColor = UIColor.app_red
            return false
        }
        if (self.fieldPhone.text?.count ?? 0 == 0) {
            self.showBanner(title: "alert".localized, message: "enter_your_phone".localized, style: UIColor.INFO)
            self.cvPhone.backgroundColor = UIColor.app_red
            return false
        }
        let email = (fieldEmail.text ?? "").trim()
        if (email.count == 0) {
            self.showBanner(title: "alert".localized, message: "enter_email_address".localized, style: UIColor.INFO)
            self.cvEmail.backgroundColor = UIColor.app_red
            return false
        }
        
        if (email.isValidEmail() == false) {
            self.showBanner(title: "alert".localized, message: "enter_valid_email".localized, style: UIColor.INFO)
            self.cvEmail.backgroundColor = UIColor.app_red
            return false
        }
        
        if (self.fieldMessage.text?.count ?? 0 == 0) {
            self.showBanner(title: "alert".localized, message: "enter_your_message".localized, style: UIColor.INFO)
            self.cvMessage.backgroundColor = UIColor.app_red
            return false
        }
        if (!isPureText(text: fieldMessage.text ?? "")) {
            self.showBanner(title: "alert".localized, message: "text_regex_message".localized, style: UIColor.INFO)
            self.cvMessage.backgroundColor = UIColor.app_red
            return false
        }
        return true
    }
    
    func validateFields() {
        if (self.fieldName.text?.count ?? 0 == 0) {
            self.enableNext(flag: false)
            return
        }
        if (self.fieldPhone.text?.count ?? 0 == 0) {
            self.enableNext(flag: false)
            return
        }
        if (self.fieldEmail.text?.count ?? 0 == 0) {
            self.enableNext(flag: false)
            return
        }
        if (self.fieldMessage.text?.count ?? 0 == 0) {
            self.enableNext(flag: false)
            return
        }
        if (!isPureTextNumber(text: self.fieldMessage.text ?? "")) {
            self.enableNext(flag: false)
            return
        }
        if (!isPureText(text: [fieldName.text ?? ""])) {
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
    
    func filluserData() {
        let userData = App.shared.accountInfo
        self.fieldName.text = "\(userData?.firstNameEn ?? "") \(userData?.lastNameEn ?? "")"
        self.fieldEmail.text = userData?.emailAddress ?? ""
        self.fieldPhone.text = userData?.mobile ?? ""

//        self.fieldPhone.text = userData?.phone ?? ""

    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueAction(_ sender: Any) {
        if (self.validate()) {
            self.showLoading()
            self.getApiManager().contactUs(token: self.getAccessToken(), name: (self.fieldName.text ?? "").trim(), phone: (self.fieldPhone.text ?? "").trim(), email: (self.fieldEmail.text ?? "").trim(), message: (self.fieldMessage.text ?? "").trim()) { (response) in
                self.hideLoading()
                if (response.success ?? false) {
                    self.showBanner(title: "alert".localized, message: "message_sent_successfully".localized, style: UIColor.SUCCESS)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }else {
                    self.handleError(code : response.code ?? "", message : response.message)
                }
            }
        }
    }
    
}

extension ContactusVC : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        switch (textView) {
        case self.fieldMessage:
            self.validateFields()
            break
        default: break
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView == self.fieldMessage) {
           self.cvMessage.backgroundColor = UIColor.card_focused_color
       }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView == self.fieldMessage) {
           self.cvMessage.backgroundColor = UIColor.card_color
       }
    }
    
}

extension ContactusVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.fieldName) {
            self.cvName.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldPhone) {
            self.cvPhone.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldEmail) {
            self.cvEmail.backgroundColor = UIColor.card_focused_color
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == self.fieldName) {
            self.cvName.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldPhone) {
            self.cvPhone.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldEmail) {
            self.cvEmail.backgroundColor = UIColor.card_color
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == self.fieldName) {
            self.fieldPhone.becomeFirstResponder()
        }else if (textField == self.fieldPhone) {
            self.fieldEmail.becomeFirstResponder()
        }else if (textField == self.fieldEmail) {
            self.fieldMessage.becomeFirstResponder()
        }else if (textField == self.fieldMessage) {
            self.fieldMessage.resignFirstResponder()
        }
        return false
    }
}

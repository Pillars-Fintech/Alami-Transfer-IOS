//
//  MoreVC.swift
//  alalami
//
//  Created by Zaid Khaled on 9/6/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit

class MoreVC: BaseVC {
    
    //short name
    @IBOutlet weak var lblTopShortName: MyUILabel!
    
    //notifications
    @IBOutlet weak var cvCount: CardView!
    @IBOutlet weak var lblCount: UILabel!
    
    //user info
    @IBOutlet weak var lblShortName: MyUILabel!
    @IBOutlet weak var lblFullName: MyUILabel!
    
    //mail
    @IBOutlet weak var viewMailsCounter: UIView!
    @IBOutlet weak var lblMailsCounter: MyUILabel!
    
    //indicators
    @IBOutlet weak var ivIndicator1: UIImageView!
    @IBOutlet weak var ivIndicator2: UIImageView!
    @IBOutlet weak var ivIndicator3: UIImageView!
    @IBOutlet weak var ivIndicator4: UIImageView!
    @IBOutlet weak var ivIndicator5: UIImageView!
    @IBOutlet weak var ivIndicator6: UIImageView!
    
    //label
    
    
    @IBOutlet weak var lGeneral: MyUILabel!
    @IBOutlet weak var lAboutUs: MyUILabel!
    @IBOutlet weak var lShare: MyUILabel!
    @IBOutlet weak var lContactUs: MyUILabel!
    @IBOutlet weak var lTerms: MyUILabel!
    
    
    //app version
    @IBOutlet weak var lblVersion: MyUILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isArabic()) {
              ivIndicator1.image = UIImage(named: "ic_indicator_ar")
              ivIndicator2.image = UIImage(named: "ic_indicator_ar")
              ivIndicator3.image = UIImage(named: "ic_indicator_ar")
              ivIndicator4.image = UIImage(named: "ic_indicator_ar")
              ivIndicator5.image = UIImage(named: "ic_indicator_ar")
              ivIndicator6.image = UIImage(named: "ic_indicator_ar")
        }
        
        
        
        if (isArabic()) {
            lGeneral.textAlignment = .right
            lAboutUs.textAlignment = .right
            lShare.textAlignment = .right
            lContactUs.textAlignment = .right
            lTerms.textAlignment = .right

        }else{
            lGeneral.textAlignment = .left
            lAboutUs.textAlignment = .left
            lShare.textAlignment = .left
            lContactUs.textAlignment = .left
            lTerms.textAlignment = .left

        }
        
        
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0".replacedArabicDigitsWithEnglish
        self.lblVersion.text = "\("version".localized) \(appVersion)"
        
        
        loadAccountInfo()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshNotifications), name: NSNotification.Name(rawValue: "notificationsCountShouldRefresh"), object: nil)
    }
    
    @objc private func refreshNotifications() {
        validateNotificationsCount()
    }
    
    private func loadAccountInfo() {
        self.lblFullName.text = getUserFullName()
        self.lblShortName.text = getUserShortName()
        self.lblTopShortName.text = getUserShortName()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadMailCount()
        validateNotificationsCount()
    }
    
    func validateNotificationsCount() {
        let count = UserDefaults.standard.value(forKey: Constants.DEFAULT_KEYS.NOTIFICATION_COUNT) as? Int ?? 0
        if (count > 0) {
            self.cvCount.isHidden = false
            self.lblCount.text = "\(count)"
        }else {
            self.cvCount.isHidden = true
        }
    }
    
    func loadMailCount() {
        self.getApiManager().getMailCounts(token: self.getAccessToken()) { (response) in
            if (response.success ?? false) {
                let mailCount = response.data?.messageCount ?? 0
                if (mailCount > 0) {
                    self.viewMailsCounter.isHidden = false
                    self.lblMailsCounter.text = "\(mailCount)"
                }else {
                    self.viewMailsCounter.isHidden = true
                }
            }else {
                self.viewMailsCounter.isHidden = true
                self.handleError(code: response.code, message: response.message)
            }
        }
    }
    
    @IBAction func helpCenterAction(_ sender: Any) {
        self.openUrl(str: App.shared.config?.configString?.helpURL ?? "", screenTitle: "help_center".localized)
    }
    
    @IBAction func generalAction(_ sender: Any) {
        self.pushParentVC(name: "GeneralSettingsVC", sb: Constants.STORYBOARDS.more)
    }
    
    @IBAction func mailsAction(_ sender: Any) {
        self.pushParentVC(name: "MailsVC", sb: Constants.STORYBOARDS.more)
    }
    
    @IBAction func aboutUsAction(_ sender: Any) {
        self.openUrl(str: App.shared.config?.configString?.aboutUsURL ?? "", screenTitle: "about_us".localized)
    }
    
    @IBAction func contactUsAction(_ sender: Any) {
        self.pushParentVC(name: "ContactusVC", sb: Constants.STORYBOARDS.more)
    }
    
    @IBAction func termsAction(_ sender: Any) {
        self.openUrl(str: App.shared.config?.configString?.termsAndConditionsURL ?? "", screenTitle: "terms_and_conditions".localized)
    }
    
    @IBAction func shareAction(_ sender: Any) {
        let config = App.shared.config
        let appLink = config?.updateStatus?.iosUpdateLst?.masterIosUpdateURL ?? ""
        let shareText = config?.updateStatus?.iosUpdateLst?.masterIosUpdateDescription ?? ""
        self.shareAction(content: "\(shareText)\n\n\(appLink)")
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        self.logout()
    }
    
    func logout() {
        self.showAlert(title: "alert".localized, message: "confirm_logout".localized, actionTitle: "logout".localized, cancelTitle: "cancel".localized, actionHandler: {
           // self.emptyBiometryData()
            self.presentVC(name: "LoginNav", sb: Constants.STORYBOARDS.authentication)
            
        })
    }
    
    //top actions
    @IBAction func profileAction(_ sender: Any) {
        openProfileScreen()
    }
    
    @IBAction func notificationsAction(_ sender: Any) {
        openNotificationsScreen()
    }
    
    
}

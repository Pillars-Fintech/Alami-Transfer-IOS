//
//  GeneralSettingsVC.swift
//  alalami
//
//  Created by Zaid Khaled on 10/1/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit
import MOLH
import Sheeeeeeeeet
import LocalAuthentication

class GeneralSettingsVC: BaseVC {

    

    let appLanguageVC = LanguageVC()
    
    @IBOutlet weak var btnBack: UIButton!
    
    //notifications
    @IBOutlet weak var notificationsSwitch: UISwitch!
    
    //touch ID
    @IBOutlet weak var viewTouchId: UIView!
    @IBOutlet weak var touchIDSwitch: UISwitch!
    @IBOutlet weak var lblTouchId: MyUILabel!
    
    //language
    @IBOutlet weak var btnLanguage: MyUIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
        }
        
        self.loadSettings()
        
        if (MOLHLanguage.currentAppleLanguage() == "ar") {
            self.btnLanguage.setTitle("العربية", for: .normal)
        }else {
            self.btnLanguage.setTitle("English", for: .normal)
        }
        
        self.validateBiometricType()

    }
    
    func validateBiometricType() {
        let authContext = LAContext()
        if #available(iOS 11, *) {
            let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch(authContext.biometryType) {
            case .none:
                self.viewTouchId.isHidden = true
                break
            case .touchID:
                self.lblTouchId.text = "touch_id".localized
                break
            case .faceID:
                self.lblTouchId.text = "face_id".localized
                break
            @unknown default:
                self.viewTouchId.isHidden = true
                break
            }
        } else {
            self.viewTouchId.isHidden = true
        }
    }
    
    func loadSettings() {
        let defaults = UserDefaults.standard
        self.notificationsSwitch.isOn = defaults.value(forKey: Constants.DEFAULT_KEYS.IS_NOTIFICATION_ACTIVE) as? Bool ?? true
        self.touchIDSwitch.isOn = defaults.value(forKey: Constants.DEFAULT_KEYS.IS_TOUCHID_ACTIVE) as? Bool ?? false
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func notificationsSwitchPressed(_ sender: Any) {
        UserDefaults.standard.setValue(self.notificationsSwitch.isOn, forKey: Constants.DEFAULT_KEYS.IS_NOTIFICATION_ACTIVE)
    }
    
    @IBAction func touchIdSwitchPressed(_ sender: Any) {
        UserDefaults.standard.setValue(self.touchIDSwitch.isOn, forKey: Constants.DEFAULT_KEYS.IS_TOUCHID_ACTIVE)
    }
    
    @IBAction func languageAction(_ sender: Any) {
        self.showLanguageSheet()
        
    }
    
    func showLanguageSheet() {
        var imageName = "ic_more_indicator"
        if (isArabic()) {
            imageName = "ic_more_indicator_ar"
        }
        let item1 = MenuItem(title: "العربية", value: 1, image: UIImage(named: imageName))
        let item2 = MenuItem(title: "English", value: 2, image: UIImage(named: imageName))
        
        let menu = Menu(title: "select_language".localized, items: [item1, item2])
        
        
        
        
        
        let sheet = menu.toActionSheet { [self] (ActionSheet, item) in

            if let value = item.value as? Int {
                
                switch (value) {
                case 1:
                    //arabic
                    if (MOLHLanguage.currentAppleLanguage() == "en") {
                        MOLH.setLanguageTo("ar")
                        MOLHLanguage.setAppleLAnguageTo("ar")
                        MOLH.reset()
//                        exit(0)

                        
                    }

                    break
                case 2:
                    //english
                    if (MOLHLanguage.currentAppleLanguage() == "ar") {
                        MOLH.setLanguageTo("en")
                        MOLHLanguage.setAppleLAnguageTo("en")

                        MOLH.reset()
//                        exit(0)



                    }

                    break
                default:
                    print("1")
                    break
                }
                

            }

            

        }
        sheet.present(in: self, from: self.btnLanguage)

    }
    
}

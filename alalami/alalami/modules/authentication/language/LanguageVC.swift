//
//  LanguageVC.swift
//  alalami
//
//  Created by Zaid Khaled on 8/31/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit
import MOLH

class LanguageVC: BaseVC {
    
    @IBOutlet weak var lblWelcome: MyUILabel!
    @IBOutlet weak var lblChoose: MyUILabel!
    
    //english
    @IBOutlet weak var ivEnglish: UIImageView!
    @IBOutlet weak var lblEnglish: MyUILabel!
    
    //arabic
    @IBOutlet weak var ivArabic: UIImageView!
    @IBOutlet weak var lblArabic: MyUILabel!
    
    @IBOutlet weak var btnGetStarted: MyUIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isArabic()) {
            self.ivArabic.image = UIImage(named: "ic_language_selected")
            self.ivEnglish.image = UIImage(named: "ic_language_unselected")
        }else {
            self.ivEnglish.image = UIImage(named: "ic_language_selected")
            self.ivArabic.image = UIImage(named: "ic_language_unselected")
        }
        
    }
    
    func arabicUI() {
        self.ivArabic.image = UIImage(named: "ic_language_selected")
        self.ivEnglish.image = UIImage(named: "ic_language_unselected")
        if (self.isArabic() == false) {
            MOLH.setLanguageTo("ar")
            MOLHLanguage.setAppleLAnguageTo("ar")

            MOLH.reset()
        }
    }
    
    func englishUI() {
        self.ivEnglish.image = UIImage(named: "ic_language_selected")
        self.ivArabic.image = UIImage(named: "ic_language_unselected")
        if (self.isArabic() == true) {
            MOLH.setLanguageTo("en")
            MOLHLanguage.setAppleLAnguageTo("en")

            MOLH.reset()
        }
    }
    
    @IBAction func englishAction(_ sender: Any) {
        self.englishUI()
    }
    
    @IBAction func arabicAction(_ sender: Any) {
        self.arabicUI()
    }
    
    @IBAction func getStartedAction(_ sender: Any) {
        UserDefaults.standard.setValue(true, forKey: Constants.DEFAULT_KEYS.DID_SELECT_LANGUAGE)
        self.presentVC(name: "IntroVC", sb: Constants.STORYBOARDS.authentication)
    }
    
    
    
    
}

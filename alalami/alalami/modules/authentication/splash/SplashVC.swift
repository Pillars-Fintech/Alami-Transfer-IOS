//
//  SplashVC.swift
//  alalami
//
//  Created by Zaid Khaled on 8/31/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit
import SimpleAnimation

class SplashVC: BaseVC {
    
    @IBOutlet weak var ivLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        ivLogo.bounceIn(from: .left, x: 0, y: view.frame.maxY, duration: 2, delay: 0) { (flag) in
//
//        }
        
        self.ivLogo.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        UIView.animate(withDuration: 1.5, animations: {() -> Void in
            self.ivLogo.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
        
        loadConfig()
    }
    
    func loadConfig() {
        getApiManager().getConfig { (response) in
            App.shared.config = response.data
            self.startLoader()
        }
    }
    
    func startLoader() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
        let didChooseLanguage = UserDefaults.standard.value(forKey: Constants.DEFAULT_KEYS.DID_SELECT_LANGUAGE) as? Bool ?? false
        let didSeeIntro = UserDefaults.standard.value(forKey: Constants.DEFAULT_KEYS.DID_SEE_INTRO) as? Bool ?? false
       
            if (didChooseLanguage) {
                if (didSeeIntro) {
                    self.presentVC(name: "LoginNav", sb: Constants.STORYBOARDS.authentication)
                }else {
                    self.presentVC(name: "IntroVC", sb: Constants.STORYBOARDS.authentication)
                }
            }else {
                self.presentVC(name: "LanguageVC", sb: Constants.STORYBOARDS.authentication)
            }
        }
    }
    
    
}

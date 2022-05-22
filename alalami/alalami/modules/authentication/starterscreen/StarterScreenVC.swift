//
//  StarterScreenVC.swift
//  alalami
//
//  Created by Zaid Khaled on 12/21/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit

class StarterScreenVC: BaseVC {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func loginAction(_ sender: Any) {
        UserDefaults.standard.setValue(true, forKey: Constants.DEFAULT_KEYS.DID_SEE_STARTED)
        self.presentVC(name: "LoginNav", sb: Constants.STORYBOARDS.authentication)
    }
    
    @IBAction func registerAction(_ sender: Any) {
        UserDefaults.standard.setValue(true, forKey: Constants.DEFAULT_KEYS.DID_SEE_STARTED)
        self.pushVC(name: "RegisterStep1", sb: Constants.STORYBOARDS.authentication)
    }
}

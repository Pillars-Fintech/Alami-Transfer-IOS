//
//  PasswordChangedVC.swift
//  alalami
//
//  Created by Zaid Khaled on 9/2/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit

class PasswordChangedVC: BaseVC {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func getStartedAction(_ sender: Any) {
        self.presentVC(name: "LoginNav", sb: Constants.STORYBOARDS.authentication)
    }
}

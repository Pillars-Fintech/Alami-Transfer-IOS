//
//  NotificationCategoriesVC.swift
//  alalami
//
//  Created by Zaid Khaled on 10/28/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit

class NotificationCategoriesVC: BaseVC {

    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var ivIndicator1: UIImageView!
    @IBOutlet weak var ivIndicator2: UIImageView!
    @IBOutlet weak var ivIndicator3: UIImageView!
    @IBOutlet weak var ivIndicator: UIImageView!
    
    
    
    //MyUILabel
    @IBOutlet weak var lSend: MyUILabel!
    @IBOutlet weak var lReceive: MyUILabel!
    @IBOutlet weak var lProfile: MyUILabel!
    @IBOutlet weak var lGeneral: MyUILabel!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lSend.textAlignment = .natural
        lReceive.textAlignment = .natural
        lProfile.textAlignment = .natural
        lGeneral.textAlignment = .natural
        
        
        
        
        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
            ivIndicator1.image = UIImage(named: "ic_indicator_ar")
            ivIndicator2.image = UIImage(named: "ic_indicator_ar")
            ivIndicator3.image = UIImage(named: "ic_indicator_ar")
            ivIndicator.image = UIImage(named: "ic_indicator_ar")
        }
        
        if (isArabic()) {
            
            lSend.textAlignment = .right
            lReceive.textAlignment = .right
            lProfile.textAlignment = .right
            lGeneral.textAlignment = .right

    
        }else{
            
            lSend.textAlignment = .left
            lReceive.textAlignment = .left
            lProfile.textAlignment = .left
            lGeneral.textAlignment = .left
            
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         UIApplication.shared.applicationIconBadgeNumber = 0
        UserDefaults.standard.setValue(0, forKey: Constants.DEFAULT_KEYS.NOTIFICATION_COUNT)
    }
    
    @IBAction func sendAction(_ sender: Any) {
        openNotifications(type: Constants.NOTIFICATION_TYPES.send)
    }
    
    @IBAction func receiveAction(_ sender: Any) {
        openNotifications(type: Constants.NOTIFICATION_TYPES.receive)
    }
    
    @IBAction func profileAction(_ sender: Any) {
        openNotifications(type: Constants.NOTIFICATION_TYPES.profile)
    }
    
    @IBAction func generalAction(_ sender: Any) {
        openNotifications(type: Constants.NOTIFICATION_TYPES.general)
    }
    
    private func openNotifications(type : Int) {
        let vc : NotificationsVC = getStoryBoard(name: Constants.STORYBOARDS.profile).instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
        vc.type = type
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
